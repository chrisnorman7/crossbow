import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../messages.dart';
import 'common_shortcuts.dart';

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
  final String everyTimeMessage;

  /// The maximum chance.
  final int maxChance;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final randomChance = chance;
    return CommonShortcuts(
      deleteCallback: () => onChanged(null),
      homeCallback: () => onChanged(null),
      endCallback: () => onChanged(maxChance),
      child: Column(
        children: [
          TextButton(
            onPressed: () => pushWidget(
              context: context,
              builder: (final context) => GetText(
                onDone: (final value) {
                  Navigator.pop(context);
                  final n = int.parse(value);
                  onChanged(n <= 1 ? null : n);
                },
                labelText: Intl.message('Random Chance'),
                text: randomChance?.toString() ?? '1',
                title: Intl.message('Edit Random Chance'),
                tooltip: doneMessage,
                validator: (final value) {
                  final n = int.tryParse(value ?? '');
                  if (n == null || n < 1) {
                    return invalidInputMessage;
                  }
                  return null;
                },
              ),
            ),
            child: Text(
              randomChance == null
                  ? everyTimeMessage
                  : randomChanceMessage(randomChance),
            ),
          ),
          Slider(
            value: randomChance?.toDouble() ?? 1.0,
            onChanged: (final value) => onChanged(
              value == 1 ? null : value.round(),
            ),
            divisions: 100,
            min: 1.0,
            max: maxChance.toDouble(),
          )
        ],
      ),
    );
  }
}
