import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../messages.dart';
import '../../src/contexts/call_commands_context.dart';
import '../../src/contexts/value_context.dart';
import '../../src/providers.dart';
import '../../util.dart';
import '../../widgets/command_list_tile.dart';

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
    final value =
        ref.watch(callCommandsProvider.call(widget.callCommandsContext));
    return value.when(
      data: (final data) => getBody(context: context, valueContext: data),
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final ValueContext<List<CallCommand>> valueContext,
  }) {
    final callCommandId = widget.callCommandsContext.id;
    final db = valueContext.projectContext.db;
    final commandsDao = db.commandsDao;
    final callCommandsDao = db.callCommandsDao;
    final callCommands = valueContext.value;
    final headerRow = TableRow(
      children: [
        TableCell(child: CenterText(text: Intl.message('Command'))),
        TableCell(child: CenterText(text: Intl.message('Call After'))),
        TableCell(child: CenterText(text: Intl.message('Random Base'))),
        TableCell(child: CenterText(text: deleteMessage))
      ],
    );
    final callCommandRows = callCommands.map<TableRow>((final callCommand) {
      final after = callCommand.after;
      final randomNumberBase = callCommand.randomNumberBase;
      return TableRow(
        children: [
          TableCell(
            child: CommandListTile(
              commandId: callCommand.commandId,
              title: Intl.message('Command'),
              nullable: false,
              onChanged: (final value) => invalidateCallCommandsProvider(),
            ),
          ),
          TableCell(
            child: IntListTile(
              value: after ?? 0,
              onChanged: (final value) async {
                await callCommandsDao.setAfter(
                  callCommandId: callCommandId,
                  after: value == 0 ? null : value,
                );
                invalidateCallCommandsProvider();
              },
              title: Intl.message('Run Delay'),
              min: 0,
              modifier: 200,
              subtitle: after == null
                  ? Intl.message('Run immediately')
                  : '${after / 1000} $secondsMessage',
            ),
          ),
          TableCell(
            child: IntListTile(
              value: randomNumberBase ?? 1,
              onChanged: (final value) async {
                await callCommandsDao.setRandomNumberBase(
                  callCommandId: callCommandId,
                  randomNumberBase: value <= 1 ? null : value,
                );
                invalidateCallCommandsProvider();
              },
              title: Intl.message('Random Chance'),
              min: 1,
              subtitle: randomNumberBase == null || randomNumberBase <= 1
                  ? Intl.message('Run every time')
                  : '1 $inMessage $randomNumberBase',
            ),
          ),
          TableCell(
            child: IconButton(
              onPressed: () => intlConfirm(
                context: context,
                message: Intl.message(
                  'Are you sure you want to delete this row?',
                ),
                title: confirmDeleteTitle,
                yesCallback: () async {
                  await commandsDao.deleteCommand(id: callCommand.commandId);
                  invalidateCallCommandsProvider();
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              icon: Icon(
                Icons.delete,
                semanticLabel: deleteMessage,
              ),
            ),
          )
        ],
      );
    });
    return Cancel(
      child: SimpleScaffold(
        title: callCommandsMessage,
        body: Table(children: [headerRow, ...callCommandRows]),
        floatingActionButton: FloatingActionButton(
          onPressed: newCallCommand,
          autofocus: true,
          tooltip: Intl.message('New Call Command'),
          child: intlNewIcon,
        ),
      ),
    );
  }

  /// Invalidate the call commands provider.
  void invalidateCallCommandsProvider() =>
      ref.invalidate(callCommandsProvider.call(widget.callCommandsContext));

  /// Create a new call command.
  Future<void> newCallCommand() async {
    final callingId = widget.callCommandsContext.id;
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final db = projectContext.db;
    final callCommandsDao = db.callCommandsDao;
    final command = await db.commandsDao.createCommand();
    final commandId = command.id;
    switch (widget.callCommandsContext.target) {
      case CallCommandsTarget.command:
        await callCommandsDao.createCallCommand(
          commandId: commandId,
          callingCommandId: callingId,
        );
        break;
      case CallCommandsTarget.menuItem:
        await callCommandsDao.createCallCommand(
          commandId: commandId,
          callingMenuItemId: callingId,
        );
        break;
      case CallCommandsTarget.menuOnCancel:
        await callCommandsDao.createCallCommand(
          commandId: commandId,
          onCancelMenuId: callingId,
        );
        break;
    }
    if (mounted) {
      invalidateCallCommandsProvider();
    }
  }
}
