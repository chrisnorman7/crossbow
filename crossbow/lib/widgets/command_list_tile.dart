import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../messages.dart';
import '../screens/commands/edit_command_screen.dart';
import '../screens/commands/select_pinned_command_screen.dart';
import '../src/providers.dart';
import '../util.dart';
import 'asset_reference_play_sound_semantics.dart';
import 'common_shortcuts.dart';
import 'error_list_tile.dart';

/// A list tile that allows editing a command.
class CommandListTile extends ConsumerStatefulWidget {
  /// Create an instance.
  const CommandListTile({
    required this.commandId,
    required this.title,
    required this.nullable,
    required this.onChanged,
    this.autofocus = false,
    super.key,
  });

  /// The ID of the command to edit.
  final int? commandId;

  /// The title of the list tile.
  final String title;

  /// Whether or not the [commandId] can be set to `null`.
  final bool nullable;

  /// The function to call when [commandId] changes.
  final ValueChanged<int?> onChanged;

  /// Whether or not the list tile should be autofocused.
  final bool autofocus;

  /// Create state for this widget.
  @override
  CommandListTileState createState() => CommandListTileState();
}

/// State for [CommandListTile].
class CommandListTileState extends ConsumerState<CommandListTile> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final commandId = widget.commandId;
    if (commandId == null) {
      return ListTile(
        autofocus: widget.autofocus,
        title: Text(widget.title),
        subtitle: Text(unsetMessage),
        onTap: () async {
          await pushWidget(
            context: context,
            builder: (final context) => SelectPinnedCommandScreen(
              onChanged: (final value) async {
                final int newCommandId;
                if (value == null) {
                  final projectContext = ref.watch(
                    projectContextNotifierProvider,
                  )!;
                  final command =
                      await projectContext.db.commandsDao.createCommand(
                    messageText: 'Program me!',
                  );
                  newCommandId = command.id;
                } else {
                  newCommandId = value.commandId;
                }
                widget.onChanged(newCommandId);
                if (mounted) {
                  await pushWidget(
                    context: context,
                    builder: (final context) => EditCommandScreen(
                      commandId: newCommandId,
                      onChanged: widget.onChanged,
                    ),
                  );
                }
              },
              clearPinnedCommandLabel: createCommandMessage,
            ),
          );
        },
      );
    }
    final value = ref.watch(commandProvider.call(commandId));
    return CommonShortcuts(
      copyText: commandId.toString(),
      child: value.when(
        data: (final valueContext) {
          final projectContext = valueContext.projectContext;
          final command = valueContext.value;
          final pinnedCommand = valueContext.pinnedCommand;
          return CommonShortcuts(
            deleteCallback: () async {
              if (widget.nullable) {
                if (pinnedCommand != null) {
                  await intlConfirm(
                    context: context,
                    message: Intl.message(
                      'Are you sure you want to delete this command?',
                    ),
                    title: confirmDeleteTitle,
                    yesCallback: () async {
                      Navigator.of(context).pop();
                      await projectContext.db.utilsDao.deleteCommand(command);
                      widget.onChanged(null);
                    },
                  );
                } else {
                  widget.onChanged(null);
                }
              }
            },
            child: AssetReferencePlaySoundSemantics(
              assetReferenceId: command.messageSoundId,
              child: ListTile(
                autofocus: widget.autofocus,
                title: Text(widget.title),
                subtitle: Text(setMessage),
                onTap: () => pushWidget(
                  context: context,
                  builder: (final context) => EditCommandScreen(
                    commandId: command.id,
                    onChanged: widget.onChanged,
                  ),
                ),
              ),
            ),
          );
        },
        error: ErrorListTile.withPositional,
        loading: LoadingWidget.new,
      ),
    );
  }
}
