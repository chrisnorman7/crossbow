import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_sdl/dart_sdl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/providers.dart';

/// A screen for editing a command trigger keyboard key with the given
/// [commandTriggerKeyboardKeyId].
class EditCommandTriggerKeyboardKeyScreen extends ConsumerWidget {
  /// Create an instance.
  const EditCommandTriggerKeyboardKeyScreen({
    required this.commandTriggerKeyboardKeyId,
    super.key,
  });

  /// The ID of the command trigger keyboard key to edit.
  final int commandTriggerKeyboardKeyId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(
      commandTriggerKeyboardKeyProvider.call(
        commandTriggerKeyboardKeyId,
      ),
    );
    return Cancel(
      child: SimpleScaffold(
        title: Intl.message('Edit Keyboard Key'),
        body: value.when(
          data: (final data) {
            final projectContext = data.projectContext;
            final dao = projectContext.db.commandTriggerKeyboardKeysDao;
            final commandTriggerKeyboardKey = data.value;
            return ListView(
              children: [
                ListTile(
                  autofocus: true,
                  title: Text(Intl.message('Scan Code')),
                  subtitle: Text(commandTriggerKeyboardKey.scanCode.name),
                  onTap: () => pushWidget(
                    context: context,
                    builder: (final context) => SelectEnum<ScanCode>(
                      values: ScanCode.values,
                      onDone: (final value) async {
                        await dao.setScanCode(
                          commandTriggerKeyboardKey: commandTriggerKeyboardKey,
                          scanCode: value,
                        );
                        invalidateCommandTriggerKeyboardKeyProvider(ref);
                      },
                      title: Intl.message('Select Scan Code'),
                      value: commandTriggerKeyboardKey.scanCode,
                    ),
                  ),
                ),
                CheckboxListTile(
                  value: commandTriggerKeyboardKey.control,
                  onChanged: (final value) async {
                    await dao.setModifiers(
                      commandTriggerKeyboardKey: commandTriggerKeyboardKey,
                      control: value ?? false,
                    );
                    invalidateCommandTriggerKeyboardKeyProvider(ref);
                  },
                  title: Text(controlKey),
                ),
                CheckboxListTile(
                  value: commandTriggerKeyboardKey.alt,
                  onChanged: (final value) async {
                    await dao.setModifiers(
                      commandTriggerKeyboardKey: commandTriggerKeyboardKey,
                      alt: value ?? false,
                    );
                    invalidateCommandTriggerKeyboardKeyProvider(ref);
                  },
                  title: Text(altKey),
                ),
                CheckboxListTile(
                  value: commandTriggerKeyboardKey.shift,
                  onChanged: (final value) async {
                    await dao.setModifiers(
                      commandTriggerKeyboardKey: commandTriggerKeyboardKey,
                      shift: value ?? false,
                    );
                    invalidateCommandTriggerKeyboardKeyProvider(ref);
                  },
                  title: Text(shiftKey),
                )
              ],
            );
          },
          error: ErrorListView.withPositional,
          loading: LoadingWidget.new,
        ),
      ),
    );
  }

  /// Invalidate the command trigger keyboard key provider.
  void invalidateCommandTriggerKeyboardKeyProvider(final WidgetRef ref) =>
      ref.invalidate(
        commandTriggerKeyboardKeyProvider.call(commandTriggerKeyboardKeyId),
      );
}
