import 'package:backstreets_widgets/util.dart';
import 'package:flutter/material.dart';

import '../screens/commands/call_commands_screen.dart';
import '../src/contexts/call_commands_context.dart';

/// A list tile that allows editing call commands.
class CallCommandsListTile extends StatelessWidget {
  /// Create an instance.
  const CallCommandsListTile({
    required this.callCommandsContext,
    required this.title,
    this.autofocus = false,
    super.key,
  });

  /// The context for getting call commands.
  final CallCommandsContext callCommandsContext;

  /// The title of the list tile.
  final String title;

  /// Whether this list tile should be autofocused or not.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => ListTile(
        autofocus: autofocus,
        title: Text(title),
        onTap: () => pushWidget(
          context: context,
          builder: (final context) =>
              CallCommandsScreen(callCommandsContext: callCommandsContext),
        ),
      );
}
