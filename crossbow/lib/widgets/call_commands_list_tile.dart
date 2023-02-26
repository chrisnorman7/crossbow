import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';

/// What sort of command should be edited.
///
/// The [values] in this enum affect the generated SQL query.
enum CallCommandsTarget {
  /// Commands called by a [Command].
  command,

  /// Commands called by a [MenuItem].
  menuItem,

  /// Commands to be called from a [Menu]'s `onCancel` handler.
  menuOnCancel,
}

/// A list tile that allows editing call commands.
class CallCommandsListTile extends StatelessWidget {
  /// Create an instance.
  const CallCommandsListTile({
    required this.target,
    required this.id,
    required this.title,
    this.autofocus = false,
    super.key,
  });

  /// The type of the commands to retrieve.
  final CallCommandsTarget target;

  /// The ID of the [target].
  final int id;

  /// The title of the list tile.
  final String title;

  /// Whether this list tile should be autofocused or not.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => ListTile(
        autofocus: autofocus,
        title: Text(title),
      );
}
