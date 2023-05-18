import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/command_triggers/select_command_trigger_screen.dart';
import '../src/providers.dart';
import 'error_list_tile.dart';

/// A list tile to show a command trigger with the given [commandTriggerId].
class CommandTriggerListTile extends ConsumerWidget {
  /// Create an instance.
  const CommandTriggerListTile({
    required this.commandTriggerId,
    required this.onChanged,
    required this.title,
    this.autofocus = false,
    super.key,
  });

  /// The ID of the command trigger to use.
  final int commandTriggerId;

  /// The function to call when the command trigger changes.
  final ValueChanged<CommandTrigger> onChanged;

  /// The title of the resulting list tile.
  final String title;

  /// Whether or not the list tile should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(commandTriggerProvider.call(commandTriggerId));
    return value.when(
      data: (final data) {
        final commandTrigger = data.value;
        return ListTile(
          autofocus: autofocus,
          title: Text(title),
          subtitle: Text(commandTrigger.description),
          onTap: () => pushWidget(
            context: context,
            builder: (final context) => SelectCommandTriggerScreen(
              onChanged: onChanged,
              currentCommandTriggerId: commandTrigger.id,
            ),
          ),
        );
      },
      error: ErrorListTile.withPositional,
      loading: LoadingWidget.new,
    );
  }
}
