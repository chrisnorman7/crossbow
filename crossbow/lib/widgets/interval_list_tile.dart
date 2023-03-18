import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../messages.dart';

/// A list tile to edit the given [interval].
class IntervalListTile extends StatelessWidget {
  /// Create an instance.
  const IntervalListTile({
    required this.interval,
    required this.onChanged,
    this.autofocused = false,
    super.key,
  });

  /// The interval value to use.
  final int? interval;

  /// The function to call when [interval] changes.
  final ValueChanged<int?> onChanged;

  /// Whether the list tile should be autofocused.
  final bool autofocused;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final i = interval;
    return IntListTile(
      value: i ?? 0,
      onChanged: (final value) => onChanged(value == 0 ? null : value),
      title: intervalMessage,
      autofocus: autofocused,
      labelText: intervalMessage,
      min: 0,
      modifier: 100,
      subtitle: i == null ? unsetMessage : '$i ms',
    );
  }
}
