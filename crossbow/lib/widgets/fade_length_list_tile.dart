import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../messages.dart';

/// A list tile to edit the given [fadeLength].
class FadeLengthListTile extends StatelessWidget {
  /// Create an instance.
  const FadeLengthListTile({
    required this.fadeLength,
    required this.onChanged,
    this.autofocus = false,
    super.key,
  });

  /// The current fade length.
  final double? fadeLength;

  /// The function to call when editing the [fadeLength].
  final ValueChanged<double?> onChanged;

  /// Whether the list tile should autofocus.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final f = fadeLength ?? 0.0;
    return DoubleListTile(
      value: f,
      onChanged: (final value) => onChanged(value == 0.0 ? null : value),
      title: fadeLengthTitle,
      autofocus: autofocus,
      min: 0.0,
      modifier: 0.5,
      subtitle:
          fadeLength == null ? unsetMessage : '$fadeLength $secondsMessage',
    );
  }
}
