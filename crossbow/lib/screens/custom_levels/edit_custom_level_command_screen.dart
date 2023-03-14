import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/contexts/call_commands_context.dart';
import '../../src/contexts/call_commands_target.dart';
import '../../src/contexts/custom_level_command_context.dart';
import '../../src/providers.dart';
import '../../widgets/call_commands_list_tile.dart';
import '../../widgets/command_trigger_list_tile.dart';

/// A screen to edit a custom level command with the given
/// [customLevelCommandId].
class EditCustomLevelCommandScreen extends ConsumerWidget {
  /// Create an instance.
  const EditCustomLevelCommandScreen({
    required this.customLevelCommandId,
    super.key,
  });

  /// The ID of the custom level command to edit.
  final int customLevelCommandId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(
      customLevelCommandProvider.call(customLevelCommandId),
    );
    return Cancel(
      child: SimpleScaffold(
        title: Intl.message('Edit Level Command'),
        body: value.when(
          data: (final data) => getBody(
            context: context,
            ref: ref,
            customLevelCommandContext: data,
          ),
          error: ErrorListView.withPositional,
          loading: LoadingWidget.new,
        ),
      ),
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final WidgetRef ref,
    required final CustomLevelCommandContext customLevelCommandContext,
  }) {
    final projectContext = customLevelCommandContext.projectContext;
    final customLevelCommandsDao = projectContext.db.customLevelCommandsDao;
    final command = customLevelCommandContext.value;
    final commandTrigger = customLevelCommandContext.commandTrigger;
    return ListView(
      children: [
        CommandTriggerListTile(
          commandTriggerId: commandTrigger.id,
          onChanged: (final value) async {
            await customLevelCommandsDao.setCommandTriggerId(
              customLevelCommandId: command.id,
              commandTriggerId: value,
            );
            invalidateCustomLevelCommandProvider(ref);
          },
          title: commandTriggerMessage,
          autofocus: true,
        ),
        CallCommandsListTile(
          callCommandsContext: CallCommandsContext(
            target: CallCommandsTarget.customLevelCommand,
            id: command.id,
          ),
          title: callCommandsMessage,
          autofocus: true,
        )
      ],
    );
  }

  /// Invalidate the custom level command provider.
  void invalidateCustomLevelCommandProvider(final WidgetRef ref) =>
      ref.invalidate(customLevelCommandProvider.call(customLevelCommandId));
}
