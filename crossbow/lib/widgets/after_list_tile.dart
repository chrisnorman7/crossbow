import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../messages.dart';

/// A list tile that shows the given [after] value.
class AfterListTile extends StatelessWidget {
  /// Create an instance.
  const AfterListTile({
    required this.after,
    required this.onChanged,
    required this.title,
    this.autofocus = false,
    super.key,
  });

  /// The after value to show.
  final int? after;

  /// The function to call when [after] changes.
  final ValueChanged<int?> onChanged;

  /// The title of this widget.
  final String title;

  /// Whether the list tile should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final value = after ?? 0;
    return CallbackShortcuts(
      bindings: {deleteShortcut: () => onChanged(null)},
      child: IntListTile(
        value: value,
        onChanged: (final value) => onChanged(value == 0 ? null : value),
        title: title,
        autofocus: autofocus,
        min: 0,
        modifier: 200,
        subtitle: value == 0 ? unsetMessage : '$value ms',
      ),
    );
  }
}
