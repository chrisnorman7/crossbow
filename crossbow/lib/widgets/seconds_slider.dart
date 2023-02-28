import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../hotkeys.dart';
import '../messages.dart';

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
    return CallbackShortcuts(
      bindings: {
        deleteHotkey: () => onChanged(null),
        const SingleActivator(LogicalKeyboardKey.home): () => onChanged(null),
        const SingleActivator(LogicalKeyboardKey.end): () =>
            onChanged(maxSeconds.toDouble()),
        const SingleActivator(LogicalKeyboardKey.pageUp): () =>
            onChanged(min(maxSeconds.toDouble(), value + 1.0)),
        const SingleActivator(LogicalKeyboardKey.pageDown): () {
          final newValue = value - 1.0;
          onChanged(newValue < 0 ? null : newValue);
        },
      },
      child: Semantics(
        container: true,
        label: seconds == null
            ? (immediatelyMessage ?? unsetMessage)
            : '${value.toStringAsFixed(1)} $secondsMessage',
        child: Slider(
          value: value,
          onChanged: (final value) => onChanged(value == 0.0 ? null : value),
          divisions: maxSeconds * 10,
          label: secondsMessage,
          max: maxSeconds.toDouble(),
        ),
      ),
    );
  }
}
