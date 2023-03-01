import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../hotkeys.dart';
import '../messages.dart';
import '../screens/commands/edit_command_screen.dart';
import '../src/providers.dart';
import '../util.dart';

/// A list tile that allows editing a command.
class CommandListTile extends ConsumerWidget {
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

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final commands = projectContext.db.commandsDao;
    final id = commandId;
    final Widget child;
    if (id == null) {
      child = ListTile(
        autofocus: autofocus,
        title: Text(title),
        subtitle: Text(unsetMessage),
        onTap: () async {
          final command =
              await commands.createCommand(messageText: 'Program me!');
          onChanged(command.id);
        },
      );
    } else {
      child = PushWidgetListTile(
        title: title,
        builder: (final context) =>
            EditCommandScreen(commandId: id, onChanged: onChanged),
        autofocus: autofocus,
        subtitle: setMessage,
      );
    }
    return CallbackShortcuts(
      bindings: {
        deleteHotkey: () async {
          if (id != null && nullable) {
            await intlConfirm(
              context: context,
              message:
                  Intl.message('Are you sure you want to delete this command?'),
              title: confirmDeleteTitle,
              yesCallback: () async {
                Navigator.of(context).pop();
                final command = await commands.getCommand(id: id);
                await projectContext.db.utilsDao.deleteCommandFull(command);
                onChanged(null);
              },
            );
          }
        }
      },
      child: child,
    );
  }
}
