import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../hotkeys.dart';
import '../messages.dart';

/// A slider to show a random [chance].
class RandomChanceSlider extends StatelessWidget {
  /// Create an instance.
  const RandomChanceSlider({
    required this.chance,
    required this.onChanged,
    required this.everyTimeMessage,
    this.maxChance = 101,
    super.key,
  });

  /// The chance that something will happen.
  final int? chance;

  /// The function to call when [chance] changes.
  final ValueChanged<int?> onChanged;

  /// The message to show when [chance] is `null`.
  final String? everyTimeMessage;

  /// The maximum chance.
  final int maxChance;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final randomChance = chance;
    return Semantics(
      container: true,
      label: randomChance == null
          ? everyTimeMessage
          : randomChanceMessage(randomChance),
      child: CallbackShortcuts(
        bindings: {
          deleteHotkey: () => onChanged(null),
          const SingleActivator(LogicalKeyboardKey.home): () => onChanged(null),
          const SingleActivator(LogicalKeyboardKey.end): () =>
              onChanged(maxChance)
        },
        child: Slider(
          value: randomChance?.toDouble() ?? 1.0,
          onChanged: (final value) => onChanged(
            value == 1 ? null : value.round(),
          ),
          divisions: 100,
          min: 1.0,
          max: maxChance.toDouble(),
        ),
      ),
    );
  }
}
