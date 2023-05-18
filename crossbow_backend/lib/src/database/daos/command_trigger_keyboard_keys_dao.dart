import 'package:dart_sdl/dart_sdl.dart';
import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/command_trigger_keyboard_keys.dart';

part 'command_trigger_keyboard_keys_dao.g.dart';

/// The command trigger keyboard keys DAO.
@DriftAccessor(tables: [CommandTriggerKeyboardKeys])
class CommandTriggerKeyboardKeysDao
    extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$CommandTriggerKeyboardKeysDaoMixin {
  /// Create an instance.
  CommandTriggerKeyboardKeysDao(super.db);

  /// Create a new keyboard key.
  Future<CommandTriggerKeyboardKey> createCommandTriggerKeyboardKey({
    required final ScanCode scanCode,
    final bool control = false,
    final bool alt = false,
    final bool shift = false,
  }) =>
      into(commandTriggerKeyboardKeys).insertReturning(
        CommandTriggerKeyboardKeysCompanion(
          scanCode: Value(scanCode),
          control: Value(control),
          alt: Value(alt),
          shift: Value(shift),
        ),
      );

  /// Get the keyboard key with the given [id].
  Future<CommandTriggerKeyboardKey> getCommandTriggerKeyboardKey({
    required final int id,
  }) =>
      (select(commandTriggerKeyboardKeys)
            ..where((final table) => table.id.equals(id)))
          .getSingle();

  /// Get an [update] query which matches [commandTriggerKeyboardKey].
  UpdateStatement<$CommandTriggerKeyboardKeysTable, CommandTriggerKeyboardKey>
      getUpdateQuery(
    final CommandTriggerKeyboardKey commandTriggerKeyboardKey,
  ) =>
          update(commandTriggerKeyboardKeys)
            ..where(
              (final table) => table.id.equals(commandTriggerKeyboardKey.id),
            );

  /// Set the [scanCode] for [commandTriggerKeyboardKey].
  Future<CommandTriggerKeyboardKey> setScanCode({
    required final CommandTriggerKeyboardKey commandTriggerKeyboardKey,
    required final ScanCode scanCode,
  }) async =>
      (await getUpdateQuery(commandTriggerKeyboardKey).writeReturning(
        CommandTriggerKeyboardKeysCompanion(scanCode: Value(scanCode)),
      ))
          .single;

  /// Update the [control], [alt], and [shift] modifiers for
  /// [commandTriggerKeyboardKey].
  Future<CommandTriggerKeyboardKey> setModifiers({
    required final CommandTriggerKeyboardKey commandTriggerKeyboardKey,
    final bool? control,
    final bool? alt,
    final bool? shift,
  }) async {
    if (control == null && alt == null && shift == null) {
      throw StateError('At least one modifier must be present.');
    }
    return (await getUpdateQuery(commandTriggerKeyboardKey).writeReturning(
      CommandTriggerKeyboardKeysCompanion(
        control: Value(control ?? commandTriggerKeyboardKey.control),
        alt: Value(alt ?? commandTriggerKeyboardKey.alt),
        shift: Value(shift ?? commandTriggerKeyboardKey.shift),
      ),
    ))
        .single;
  }

  /// Delete the [commandTriggerKeyboardKey].
  Future<int> deleteCommandTriggerKeyboardKey({
    required final CommandTriggerKeyboardKey commandTriggerKeyboardKey,
  }) =>
      (delete(commandTriggerKeyboardKeys)
            ..where(
              (final table) => table.id.equals(commandTriggerKeyboardKey.id),
            ))
          .go();
}
