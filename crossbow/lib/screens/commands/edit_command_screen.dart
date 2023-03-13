import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/contexts/call_commands_context.dart';
import '../../src/contexts/call_commands_target.dart';
import '../../src/contexts/command_context.dart';
import '../../src/providers.dart';
import '../../util.dart';
import '../../widgets/asset_reference_list_tile.dart';
import '../../widgets/call_commands_list_tile.dart';
import '../../widgets/pop_level_list_tile.dart';
import '../../widgets/push_menu_list_tile.dart';
import '../../widgets/stop_game_list_tile.dart';
import '../../widgets/url_list_tile.dart';

/// A widget for editing a command.
class EditCommandScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const EditCommandScreen({
    required this.commandId,
    required this.onChanged,
    super.key,
  });

  /// The ID of the command to edit.
  final int commandId;

  /// The function to call when the command is changed.
  final ValueChanged<int> onChanged;

  /// Create state for this widget.
  @override
  EditCommandScreenState createState() => EditCommandScreenState();
}

/// State for [EditCommandScreen].
class EditCommandScreenState extends ConsumerState<EditCommandScreen> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final value = ref.watch(commandProvider.call(widget.commandId));
    return Cancel(
      child: value.when(
        data: getBody,
        error: ErrorScreen.withPositional,
        loading: LoadingScreen.new,
      ),
    );
  }

  /// Get the body for this widget.
  Widget getBody(final CommandContext commandContext) {
    final projectContext = commandContext.projectContext;
    final pinnedCommandsDao = projectContext.db.pinnedCommandsDao;
    final utilsDao = projectContext.db.utilsDao;
    final command = commandContext.value;
    final pinnedCommand = commandContext.pinnedCommand;
    final commands = commandContext.projectContext.db.commandsDao;
    return SimpleScaffold(
      actions: [
        if (pinnedCommand != null)
          TextButton(
            onPressed: () => pushWidget(
              context: context,
              builder: (final context) => GetText(
                onDone: (final value) async {
                  Navigator.pop(context);
                  await pinnedCommandsDao.setName(
                    pinnedCommandId: pinnedCommand.id,
                    name: value,
                  );
                  invalidatePinnedCommandsProvider();
                  invalidateCommandProvider();
                },
                labelText: Intl.message('Pinned Name'),
                text: pinnedCommand.name,
                title: Intl.message('Get Pinned Name'),
                tooltip: doneMessage,
              ),
            ),
            child: Text(pinnedCommand.name),
          ),
        TextButton(
          onPressed: () async {
            if (pinnedCommand == null) {
              await pinnedCommandsDao.createPinnedCommand(
                commandId: command.id,
                name: Intl.message('Untitled Command'),
              );
            } else if (await commands.isCalled(commandId: command.id)) {
              if (mounted) {
                await intlShowMessage(
                  context: context,
                  message: cantDeleteCalledCommand,
                  title: errorTitle,
                );
              }
              return;
            } else {
              await utilsDao.deletePinnedCommand(pinnedCommand);
            }
            invalidatePinnedCommandsProvider();
            invalidateCommandProvider();
          },
          child: Text(
            pinnedCommand == null ? pinMessage : unpinMessage,
          ),
        )
      ],
      title: editCommandTitle,
      body: ListView(
        children: [
          TextListTile(
            value: command.messageText ?? '',
            onChanged: (final value) async {
              await commands.setMessageText(
                commandId: command.id,
                text: value.isEmpty ? null : value,
              );
              invalidateCommandProvider();
            },
            header: outputText,
            autofocus: true,
            labelText: outputText,
            title: outputText,
          ),
          AssetReferenceListTile(
            assetReferenceId: command.messageSoundId,
            onChanged: (final value) async {
              await commands.setMessageSoundId(
                commandId: command.id,
                assetReferenceId: value,
              );
              if (value != null) {
                ref.invalidate(assetReferenceProvider.call(value));
              }
              invalidateCommandProvider();
            },
            nullable: true,
            title: outputSound,
          ),
          CallCommandsListTile(
            callCommandsContext: CallCommandsContext(
              target: CallCommandsTarget.command,
              id: command.id,
            ),
            title: callCommandsMessage,
          ),
          PushMenuListTile(
            pushMenuId: command.pushMenuId,
            onChanged: (final value) async {
              await commands.setPushMenuId(
                commandId: command.id,
                pushMenuId: value,
              );
              invalidateCommandProvider();
            },
          ),
          PopLevelListTile(
            popLevelId: command.popLevelId,
            onChanged: (final value) async {
              await commands.setPopLevelId(
                commandID: command.id,
                popLevelId: value,
              );
              invalidateCommandProvider();
            },
            title: Intl.message('Pop Level'),
          ),
          StopGameListTile(
            stopGameId: command.stopGameId,
            onChanged: (final value) async {
              await commands.setStopGameId(
                commandId: command.id,
                stopGameId: value,
              );
              invalidateCommandProvider();
            },
          ),
          CallbackShortcuts(
            bindings: {
              deleteShortcut: () async {
                await commands.setUrl(commandId: command.id);
                invalidateCommandProvider();
              }
            },
            child: UrlListTile(
              url: command.url,
              onChanged: (final value) async {
                await commands.setUrl(
                  commandId: command.id,
                  url: value,
                );
                invalidateCommandProvider();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Invalidate the command provider.
  void invalidateCommandProvider() =>
      ref.invalidate(commandProvider.call(widget.commandId));

  /// Invalidate the [pinnedCommandsProvider].
  void invalidatePinnedCommandsProvider() => ref
    ..invalidate(pinnedCommandsProvider)
    ..invalidate(callCommandsProvider);
}
