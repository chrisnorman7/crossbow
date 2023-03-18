import 'package:backstreets_widgets/screens.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../src/contexts/value_context.dart';
import '../src/providers.dart';
import '../widgets/asset_reference_play_sound_semantics.dart';

/// A screen for selecting a custom level.
class SelectCustomLevelScreen extends ConsumerWidget {
  /// Create an instance.
  const SelectCustomLevelScreen({
    required this.onChanged,
    this.currentCustomLevelId,
    super.key,
  });

  /// The function to call when a new menu is selected.
  final ValueChanged<int> onChanged;

  /// The ID of the current custom level.
  final int? currentCustomLevelId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(customLevelsProvider);
    return value.when(
      data: getBody,
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody(final ValueContext<List<CustomLevel>> valueContext) {
    final levels = valueContext.value;
    final customLevelId = currentCustomLevelId;
    return SelectItem(
      values: levels,
      onDone: (final value) => onChanged(value.id),
      getSearchString: (final value) => value.name,
      getWidget: (final value) => AssetReferencePlaySoundSemantics(
        assetReferenceId: value.musicId,
        child: Text(value.name),
      ),
      title: Intl.message('Select Custom Level'),
      value: customLevelId == null
          ? null
          : levels.firstWhere((final element) => element.id == customLevelId),
    );
  }
}
