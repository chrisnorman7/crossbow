import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:dart_sdl/dart_sdl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../hotkeys.dart';
import '../../messages.dart';
import '../../src/contexts/command_trigger_context.dart';
import '../../src/providers.dart';
import '../../util.dart';
import 'edit_command_trigger_keyboard_key_screen.dart';

/// A screen for editing a [CommandTrigger] with the given [commandTriggerId].
class EditCommandTriggerScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const EditCommandTriggerScreen({
    required this.commandTriggerId,
    super.key,
  });

  /// The ID of the command trigger to edit.
  final int commandTriggerId;

  /// Create state for this widget.
  @override
  EditCommandTriggerScreenState createState() =>
      EditCommandTriggerScreenState();
}

/// State for [EditCommandTriggerScreen].
class EditCommandTriggerScreenState
    extends ConsumerState<EditCommandTriggerScreen> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final value =
        ref.watch(commandTriggerProvider.call(widget.commandTriggerId));
    return SimpleScaffold(
      title: Intl.message('Edit Command Trigger'),
      body: Cancel(
        child: value.when(
          data: getBody,
          error: ErrorListView.withPositional,
          loading: LoadingWidget.new,
        ),
      ),
    );
  }

  /// Get the body for this widget.
  Widget getBody(final CommandTriggerContext commandTriggerContext) {
    final projectContext = commandTriggerContext.projectContext;
    final dao = projectContext.db.commandTriggersDao;
    final commandTrigger = commandTriggerContext.value;
    final button = commandTrigger.gameControllerButton;
    final keyboardKey = commandTriggerContext.commandTriggerKeyboardKey;
    return ListView(
      children: [
        TextListTile(
          value: commandTrigger.description,
          onChanged: (final value) async {
            await dao.setDescription(
              commandTriggerId: commandTrigger.id,
              description: value,
            );
            invalidateCommandTriggerProvider();
          },
          header: descriptionMessage,
          autofocus: true,
        ),
        ListTile(
          title: Text(Intl.message('Game Controller Button')),
          subtitle: Text(button == null ? unsetMessage : button.name),
          onTap: () => pushWidget(
            context: context,
            builder: (final context) => SelectItem<GameControllerButton?>(
              values: const [null, ...GameControllerButton.values],
              onDone: (final value) async {
                await dao.setGameControllerButton(
                  commandTriggerId: commandTrigger.id,
                  gameControllerButton: value,
                );
                invalidateCommandTriggerProvider();
              },
              getSearchString: (final value) => value?.name ?? clearMessage,
              getWidget: (final value) => Text(value?.name ?? clearMessage),
              value: button,
            ),
          ),
        ),
        CallbackShortcuts(
          bindings: {
            deleteHotkey: () async {
              if (keyboardKey != null) {
                await projectContext.db.commandTriggerKeyboardKeysDao
                    .deleteCommandTriggerKeyboardKey(
                  commandTriggerKeyboardKeyId: keyboardKey.id,
                );
                invalidateCommandTriggerProvider();
              }
            }
          },
          child: ListTile(
            title: Text(Intl.message('Keyboard Key')),
            subtitle: Text(
              keyboardKey == null
                  ? unsetMessage
                  : commandTriggerKeyboardKeyToString(keyboardKey),
            ),
            onTap: () async {
              final int keyboardKeyId;
              if (keyboardKey == null) {
                keyboardKeyId = (await projectContext
                        .db.commandTriggerKeyboardKeysDao
                        .createCommandTriggerKeyboardKey(
                  scanCode: ScanCode.space,
                ))
                    .id;
                await dao.setKeyboardKeyId(
                  commandTriggerId: commandTrigger.id,
                  keyboardKeyId: keyboardKeyId,
                );
              } else {
                keyboardKeyId = keyboardKey.id;
              }
              if (mounted) {
                await pushWidget(
                  context: context,
                  builder: (final context) =>
                      EditCommandTriggerKeyboardKeyScreen(
                    commandTriggerKeyboardKeyId: keyboardKeyId,
                  ),
                );
              }
              invalidateCommandTriggerProvider();
            },
          ),
        )
      ],
    );
  }

  /// Invalidate the command trigger provider.
  void invalidateCommandTriggerProvider() =>
      ref.invalidate(commandTriggerProvider.call(widget.commandTriggerId));
}
