import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
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
import '../../widgets/seconds_slider.dart';
import 'edit_command_screen.dart';

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
    final db = valueContext.projectContext.db;
    final commandsDao = db.commandsDao;
    final callCommandsDao = db.callCommandsDao;
    final callCommands = valueContext.value;
    final headerRow = TableRow(
      children: [
        TableCell(child: CenterText(text: Intl.message('Command'))),
        TableCell(child: CenterText(text: Intl.message('Call Delay'))),
        TableCell(child: CenterText(text: Intl.message('Random Chance'))),
        TableCell(child: CenterText(text: deleteMessage))
      ],
    );
    final callCommandRows = callCommands.map<TableRow>((final callCommand) {
      final callCommandId = callCommand.id;
      final after = callCommand.after;
      final randomNumberBase = callCommand.randomNumberBase;
      return TableRow(
        children: [
          TableCell(
            child: IconButton(
              onPressed: () => pushWidget(
                context: context,
                builder: (final context) => EditCommandScreen(
                  commandId: callCommand.commandId,
                  onChanged: (final value) => invalidateCallCommandsProvider(),
                ),
              ),
              icon: Icon(
                Icons.edit,
                semanticLabel: Intl.message('Edit Command'),
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
            child: Semantics(
              container: true,
              label: randomNumberBase == null
                  ? Intl.message('Every Time')
                  : randomChanceMessage(randomNumberBase),
              child: Slider(
                value: randomNumberBase?.toDouble() ?? 1.0,
                onChanged: (final value) async {
                  await callCommandsDao.setRandomNumberBase(
                    callCommandId: callCommandId,
                    randomNumberBase: value == 1 ? null : value.floor(),
                  );
                  invalidateCallCommandsProvider();
                },
                divisions: 100,
                min: 1.0,
                max: 101.0,
              ),
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
