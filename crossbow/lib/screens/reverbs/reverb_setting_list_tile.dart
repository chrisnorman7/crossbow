import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/common_shortcuts.dart';
import '../../src/providers.dart';
import 'reverb_setting.dart';

/// A setting for a reverb [setting].
class ReverbSettingListTile extends ConsumerWidget {
  /// Create an instance.
  const ReverbSettingListTile({
    required this.reverbId,
    required this.setting,
    required this.onChanged,
    required this.value,
    super.key,
  });

  /// The ID of the reverb whose provider will be invalidated.
  final int reverbId;

  /// The setting to use.
  final ReverbSetting setting;

  /// The function to call with a new [value].
  final ValueChanged<double> onChanged;

  /// The current value.
  final double value;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) =>
      CommonShortcuts(
        deleteCallback: () => setValue(ref, setting.defaultValue),
        child: DoubleListTile(
          value: value,
          onChanged: (final value) => setValue(ref, value),
          title: setting.name,
          min: setting.min,
          max: setting.max,
          modifier: setting.modify,
        ),
      );

  /// Set a new [value].
  void setValue(final WidgetRef ref, final double value) {
    onChanged(value);
    ref.invalidate(reverbProvider.call(reverbId));
  }
}
