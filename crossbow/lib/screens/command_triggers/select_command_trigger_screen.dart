import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../messages.dart';
import '../../src/contexts/command_trigger_context.dart';
import '../../src/providers.dart';

/// A screen for selecting a command trigger.
class SelectCommandTriggerScreen extends ConsumerWidget {
  /// Create an instance.
  const SelectCommandTriggerScreen({
    required this.onChanged,
    this.currentCommandTriggerId,
    super.key,
  });

  /// The function to call with the new command trigger.
  final ValueChanged<CommandTrigger> onChanged;

  /// The ID of the current command trigger.
  final int? currentCommandTriggerId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(commandTriggersProvider);
    final id = currentCommandTriggerId;
    return value.when(
      data: (final data) {
        if (data.isEmpty) {
          return Cancel(
            child: SimpleScaffold(
              title: selectCommandTriggerMessage,
              body: const CenterText(
                text: 'You must create some command triggers first.',
                autofocus: true,
              ),
            ),
          );
        }
        return SelectItem<CommandTriggerContext>(
          values: data,
          onDone: (final value) => onChanged(value.value),
          getSearchString: (final value) => value.value.description,
          getWidget: (final value) => Text(value.value.description),
          title: selectCommandTriggerMessage,
          value: id == null
              ? null
              : data.firstWhere((final element) => element.value.id == id),
        );
      },
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }
}
