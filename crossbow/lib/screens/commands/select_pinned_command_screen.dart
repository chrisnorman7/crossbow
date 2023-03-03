import 'package:backstreets_widgets/screens.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/providers.dart';

/// A widget for selecting a pinned command.
class SelectPinnedCommandScreen extends ConsumerWidget {
  /// Create an instance.
  const SelectPinnedCommandScreen({
    required this.onChanged,
    this.pinnedCommandId,
    this.nullable = true,
    this.clearPinnedCommandLabel,
    super.key,
  });

  /// The function to call with the ID of the selected pinned command.
  final ValueChanged<PinnedCommand?> onChanged;

  /// The int of the current pinned command.
  final int? pinnedCommandId;

  /// Whether or not the new pinned command can be `null`.
  final bool nullable;

  /// The label for selecting a `null` pinned command.
  final String? clearPinnedCommandLabel;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final clearPinnedCommand = clearPinnedCommandLabel ?? clearMessage;
    final id = pinnedCommandId;
    final value = ref.watch(pinnedCommandsProvider);
    return value.when(
      data: (final data) {
        final pinnedCommands = data.value;
        return SelectItem<PinnedCommand?>(
          values: [if (nullable) null, ...pinnedCommands],
          onDone: onChanged,
          getSearchString: (final value) => value?.name ?? clearPinnedCommand,
          getWidget: (final value) => Text(value?.name ?? clearPinnedCommand),
          title: Intl.message('Select Pinned Command'),
          value: id == null
              ? null
              : pinnedCommands.firstWhere((final element) => element.id == id),
        );
      },
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }
}
