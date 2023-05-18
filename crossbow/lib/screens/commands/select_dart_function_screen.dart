import 'package:backstreets_widgets/screens.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/providers.dart';

/// A screen for selecting a dart function.
class SelectDartFunctionScreen extends ConsumerWidget {
  /// Create an instance.
  const SelectDartFunctionScreen({
    required this.onChanged,
    this.currentDartFunctionId,
    super.key,
  });

  /// The function to call with a new dart function.
  final ValueChanged<DartFunction?> onChanged;

  /// The ID of the current dart function.
  final int? currentDartFunctionId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final id = currentDartFunctionId;
    final value = ref.watch(dartFunctionsProvider);
    return value.when(
      data: (final data) => SelectItem(
        values: [null, ...data],
        onDone: onChanged,
        getSearchString: (final value) => value?.description ?? clearMessage,
        getWidget: (final value) => Text(value?.description ?? clearMessage),
        title: Intl.message('Select Dart Function'),
        value: id == null
            ? null
            : data.firstWhere((final element) => element.id == id),
      ),
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }
}
