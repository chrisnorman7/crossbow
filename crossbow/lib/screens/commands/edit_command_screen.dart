import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../messages.dart';
import '../../src/contexts/value_context.dart';
import '../../src/providers.dart';
import '../../widgets/asset_reference_list_tile.dart';

/// A screen to edit the command with the given [commandId].
class EditCommandScreen extends ConsumerWidget {
  /// Create an instance.
  const EditCommandScreen({
    required this.commandId,
    required this.onChanged,
    super.key,
  });

  /// The ID of the command to edit.
  final int commandId;

  /// The function to call when the command is changed.
  final ValueChanged<int> onChanged;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(commandProvider.call(commandId));
    return Cancel(
      child: value.when(
        data: (final data) => getBody(
          context: context,
          ref: ref,
          commandContext: data,
        ),
        error: ErrorScreen.withPositional,
        loading: LoadingScreen.new,
      ),
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final WidgetRef ref,
    required final ValueContext<Command> commandContext,
  }) {
    final command = commandContext.value;
    final commands = commandContext.projectContext.db.commandsDao;
    return SimpleScaffold(
      title: editCommandTitle,
      body: ListView(
        children: [
          TextListTile(
            value: command.messageText ?? '',
            onChanged: (final value) async {
              await commands.setMessageText(
                commandId: commandId,
                text: value.isEmpty ? null : value,
              );
              invalidateCommandProvider(ref);
            },
            header: outputText,
            autofocus: true,
            labelText: outputText,
            title: outputText,
          ),
          AssetReferenceListTile(
            assetReferenceId: command.messageSoundId,
            onChanged: (final value) async {
              await commands.setMessageSoundId(
                commandId: command.id,
                assetReferenceId: value,
              );
              invalidateCommandProvider(ref);
            },
            nullable: true,
            title: outputSound,
          ),
        ],
      ),
    );
  }

  /// Invalidate the command provider.
  void invalidateCommandProvider(final WidgetRef ref) {
    ref.invalidate(commandProvider.call(commandId));
  }
}
