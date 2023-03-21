import 'dart:math';

import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../messages.dart';
import 'common_shortcuts.dart';

/// A slider to set seconds.
class SecondsSlider extends StatelessWidget {
  /// Create an instance.
  const SecondsSlider({
    required this.seconds,
    required this.onChanged,
    this.maxSeconds = 3600,
    this.immediatelyMessage,
    super.key,
  });

  /// The number of seconds to start with.
  final double? seconds;

  /// The function to call when [seconds] change.
  final ValueChanged<double?> onChanged;

  /// The maximum number of seconds that can be set.
  final int maxSeconds;

  /// The message to be shown when [seconds] is `null`.
  final String? immediatelyMessage;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final value = seconds ?? 0.0;
    return CommonShortcuts(
      deleteCallback: () => onChanged(null),
      homeCallback: () => onChanged(null),
      endCallback: () => onChanged(maxSeconds.toDouble()),
      pageUpCallback: () => onChanged(min(maxSeconds.toDouble(), value + 1.0)),
      pageDownCallback: () {
        final newValue = value - 1.0;
        onChanged(newValue < 0 ? null : newValue);
      },
      child: Column(
        children: [
          TextButton(
            onPressed: () => pushWidget(
              context: context,
              builder: (final context) => GetText(
                onDone: (final value) {
                  Navigator.pop(context);
                  onChanged(double.tryParse(value));
                },
                labelText: secondsMessage,
                text: value.toStringAsFixed(1),
                title: secondsMessage,
                tooltip: doneMessage,
                validator: (final value) {
                  if (double.tryParse(value ?? '') == null) {
                    return invalidInputMessage;
                  }
                  return null;
                },
              ),
            ),
            child: Text(
              seconds == null
                  ? (immediatelyMessage ?? unsetMessage)
                  : '${value.toStringAsFixed(1)} $secondsMessage',
            ),
          ),
          Slider(
            value: value,
            onChanged: (final value) => onChanged(value == 0.0 ? null : value),
            divisions: maxSeconds * 10,
            label: secondsMessage,
            max: maxSeconds.toDouble(),
          ),
        ],
      ),
    );
  }
}
