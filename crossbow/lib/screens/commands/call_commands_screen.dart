import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../hotkeys.dart';
import '../../messages.dart';
import '../../src/contexts/call_command_context.dart';
import '../../src/contexts/call_commands_context.dart';
import '../../src/contexts/call_commands_target.dart';
import '../../src/providers.dart';
import '../../util.dart';
import '../../widgets/new_callback_shortcuts.dart';
import '../../widgets/random_chance_slider.dart';
import '../../widgets/seconds_slider.dart';
import 'edit_command_screen.dart';
import 'select_pinned_command_screen.dart';

/// Show a table of call commands, retrieved from the given
/// [callCommandsContext].
class CallCommandsScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const CallCommandsScreen({
    required this.callCommandsContext,
    super.key,
  });

  /// The call commands context to use.
  final CallCommandsContext callCommandsContext;

  /// Create state for this widget.
  @override
  CallCommandsScreenState createState() => CallCommandsScreenState();
}

/// State for [CallCommandsScreen].
class CallCommandsScreenState extends ConsumerState<CallCommandsScreen> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final value = ref.watch(
      callCommandsProvider.call(widget.callCommandsContext),
    );
    return value.when(
      data: (final data) => getBody(context: context, callCommands: data),
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final List<CallCommandContext> callCommands,
  }) {
    final headerRow = TableRow(
      children: [
        TableCell(child: CenterText(text: Intl.message('Command'))),
        TableCell(child: CenterText(text: Intl.message('Call Delay'))),
        TableCell(child: CenterText(text: Intl.message('Random Chance'))),
        TableCell(child: CenterText(text: deleteMessage))
      ],
    );
    final callCommandRows = <TableRow>[];
    for (var i = 0; i < callCommands.length; i++) {
      callCommandRows.add(
        getCallCommandTableRow(
          context: context,
          callCommandContext: callCommands[i],
          index: i,
        ),
      );
    }
    return Cancel(
      child: NewCallbackShortcuts(
        newCallback: newCallCommand,
        child: SimpleScaffold(
          title: callCommandsMessage,
          body: Table(children: [headerRow, ...callCommandRows]),
          floatingActionButton: Row(
            children: [
              TextButton(
                onPressed: () => pushWidget(
                  context: context,
                  builder: (final context) => SelectPinnedCommandScreen(
                    onChanged: (final value) =>
                        newCallCommand(commandId: value?.commandId),
                  ),
                ),
                child: Text(Intl.message('Select Pinned Command')),
              ),
              TextButton(
                onPressed: newCallCommand,
                autofocus: callCommands.isEmpty,
                child: Text(Intl.message('New Call Command')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Invalidate the call commands provider.
  void invalidateCallCommandsProvider() =>
      ref.invalidate(callCommandsProvider.call(widget.callCommandsContext));

  /// Create a new call command.
  Future<void> newCallCommand({
    final int? commandId,
  }) async {
    final callingId = widget.callCommandsContext.id;
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final db = projectContext.db;
    final callCommandsDao = db.callCommandsDao;
    final int actualCommandId;
    if (commandId == null) {
      final command = await db.commandsDao.createCommand();
      actualCommandId = command.id;
    } else {
      actualCommandId = commandId;
    }
    switch (widget.callCommandsContext.target) {
      case CallCommandsTarget.command:
        await callCommandsDao.createCallCommand(
          commandId: actualCommandId,
          callingCommandId: callingId,
        );
        break;
      case CallCommandsTarget.menuItem:
        await callCommandsDao.createCallCommand(
          commandId: actualCommandId,
          callingMenuItemId: callingId,
        );
        break;
      case CallCommandsTarget.menuOnCancel:
        await callCommandsDao.createCallCommand(
          commandId: actualCommandId,
          onCancelMenuId: callingId,
        );
        break;
      case CallCommandsTarget.activatingCustomLevelCommand:
        await callCommandsDao.createCallCommand(
          commandId: actualCommandId,
          callingCustomLevelCommandId: callingId,
        );
        break;
      case CallCommandsTarget.releaseCustomLevelCommand:
        await callCommandsDao.createCallCommand(
          commandId: actualCommandId,
          releasingCustomLevelCommandId: callingId,
        );
        break;
    }
    if (mounted) {
      invalidateCallCommandsProvider();
    }
  }

  /// Delete the given [callCommand].
  Future<void> deleteCallCommand(final CallCommand callCommand) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    await intlConfirm(
      context: context,
      message: Intl.message(
        'Are you sure you want to delete this row?',
      ),
      title: confirmDeleteTitle,
      yesCallback: () async {
        await projectContext.db.callCommandsDao
            .deleteCallCommand(callCommandId: callCommand.id);
        invalidateCallCommandsProvider();
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  /// Get a table row to suit the given [callCommandContext].
  TableRow getCallCommandTableRow({
    required final BuildContext context,
    required final CallCommandContext callCommandContext,
    required final int index,
  }) {
    final row = index + 1;
    final projectContext = callCommandContext.projectContext;
    final db = projectContext.db;
    final callCommandsDao = db.callCommandsDao;
    final commandsDao = db.commandsDao;
    final utilsDao = db.utilsDao;
    final callCommand = callCommandContext.value;
    final callCommandId = callCommand.id;
    final pinnedCommand = callCommandContext.pinnedCommand;
    final after = callCommand.after;
    final randomNumberBase = callCommand.randomNumberBase;
    return TableRow(
      children: [
        TableCell(
          child: CallbackShortcuts(
            bindings: {deleteHotkey: () => deleteCallCommand(callCommand)},
            child: Column(
              children: [
                TextButton(
                  onPressed: () => pushWidget(
                    context: context,
                    builder: (final context) => SelectPinnedCommandScreen(
                      onChanged: (final value) async {
                        if (value == null) {
                          final command = await commandsDao.createCommand();
                          await callCommandsDao.setCommandId(
                            callCommandId: callCommand.id,
                            commandId: command.id,
                          );
                        } else {
                          await callCommandsDao.setCommandId(
                            callCommandId: callCommand.id,
                            commandId: value.commandId,
                          );
                        }
                        if ((await commandsDao.isPinned(
                              commandId: callCommand.commandId,
                            )) ==
                            false) {
                          await utilsDao.deleteCommand(
                            await commandsDao.getCommand(
                              id: callCommand.commandId,
                            ),
                          );
                        }
                        if (pinnedCommand == null) {
                          await projectContext.db.callCommandsDao
                              .deleteCallCommand(callCommandId: callCommand.id);
                        }
                      },
                    ),
                  ),
                  child: Text(
                    Intl.message('Select Pinned Command'),
                  ),
                ),
                TextButton(
                  autofocus: index == 0,
                  onPressed: () => pushWidget(
                    context: context,
                    builder: (final context) => EditCommandScreen(
                      commandId: callCommand.commandId,
                      onChanged: (final value) =>
                          invalidateCallCommandsProvider(),
                    ),
                  ),
                  child: Text(
                    pinnedCommand?.name ?? editRowCommandMessage(row),
                  ),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: SecondsSlider(
            seconds: after == null ? null : after / 1000.0,
            onChanged: (final value) async {
              await callCommandsDao.setAfter(
                callCommandId: callCommandId,
                after: value == null ? null : (value * 1000).floor(),
              );
              invalidateCallCommandsProvider();
            },
            immediatelyMessage: Intl.message('Call immediately'),
          ),
        ),
        TableCell(
          child: RandomChanceSlider(
            chance: randomNumberBase,
            onChanged: (final value) async {
              await callCommandsDao.setRandomNumberBase(
                callCommandId: callCommandId,
                randomNumberBase: value,
              );
              invalidateCallCommandsProvider();
            },
            everyTimeMessage: everyTimeMessage,
          ),
        ),
        TableCell(
          child: CallbackShortcuts(
            bindings: {deleteHotkey: () => deleteCallCommand(callCommand)},
            child: IconButton(
              onPressed: () => deleteCallCommand(callCommand),
              icon: Icon(
                Icons.delete,
                semanticLabel: deleteRowMessage(row),
              ),
            ),
          ),
        )
      ],
    );
  }
}
