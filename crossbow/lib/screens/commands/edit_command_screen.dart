import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/contexts/call_commands_context.dart';
import '../../src/contexts/command_context.dart';
import '../../src/providers.dart';
import '../../widgets/asset_reference_list_tile.dart';
import '../../widgets/call_commands_list_tile.dart';
import '../../widgets/pop_level_list_tile.dart';
import '../../widgets/push_menu_list_tile.dart';
import '../../widgets/stop_game_list_tile.dart';
import '../../widgets/url_list_tile.dart';

/// A screen to edit the command with the given [commandId].
class EditCommandScreen extends ConsumerWidget {
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

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(commandProvider.call(commandId));
    return Cancel(
      child: value.when(
        data: (final data) => getBody(
          context: context,
          ref: ref,
          commandContext: data,
        ),
        error: ErrorScreen.withPositional,
        loading: LoadingScreen.new,
      ),
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final WidgetRef ref,
    required final CommandContext commandContext,
  }) {
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
                  invalidatePinnedCommandsProvider(ref);
                  invalidateCommandProvider(ref);
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
            } else {
              await utilsDao.deletePinnedCommand(pinnedCommand);
            }
            invalidatePinnedCommandsProvider(ref);
            invalidateCommandProvider(ref);
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
                commandId: commandId,
                text: value.isEmpty ? null : value,
              );
              invalidateCommandProvider(ref);
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
              invalidateCommandProvider(ref);
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
              invalidateCommandProvider(ref);
            },
          ),
          PopLevelListTile(
            popLevelId: command.popLevelId,
            onChanged: (final value) async {
              await commands.setPopLevelId(
                commandID: command.id,
                popLevelId: value,
              );
              invalidateCommandProvider(ref);
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
              invalidateCommandProvider(ref);
            },
          ),
          CallbackShortcuts(
            bindings: {
              deleteShortcut: () async {
                await commands.setUrl(commandId: command.id);
                invalidateCommandProvider(ref);
              }
            },
            child: UrlListTile(
              url: command.url,
              onChanged: (final value) async {
                await commands.setUrl(
                  commandId: command.id,
                  url: value,
                );
                invalidateCommandProvider(ref);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Invalidate the command provider.
  void invalidateCommandProvider(final WidgetRef ref) =>
      ref.invalidate(commandProvider.call(commandId));

  /// Invalidate the [pinnedCommandsProvider].
  void invalidatePinnedCommandsProvider(final WidgetRef ref) => ref
    ..invalidate(pinnedCommandsProvider)
    ..invalidate(callCommandsProvider);
}
