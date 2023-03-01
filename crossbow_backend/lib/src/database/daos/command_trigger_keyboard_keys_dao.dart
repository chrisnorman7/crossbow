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

  /// Get an [update] query which matches on the given [id].
  UpdateStatement<$CommandTriggerKeyboardKeysTable, CommandTriggerKeyboardKey>
      getUpdateQuery(final int id) => update(commandTriggerKeyboardKeys)
        ..where((final table) => table.id.equals(id));

  /// Get the keyboard key with the given [id].
  Future<CommandTriggerKeyboardKey> getCommandTriggerKeyboardKey({
    required final int id,
  }) =>
      (select(commandTriggerKeyboardKeys)
            ..where((final table) => table.id.equals(id)))
          .getSingle();

  /// Set the [scanCode] for the keyboard key with the given
  /// [commandTriggerKeyboardKeyId].
  Future<CommandTriggerKeyboardKey> setScanCode({
    required final int commandTriggerKeyboardKeyId,
    required final ScanCode scanCode,
  }) async =>
      (await getUpdateQuery(commandTriggerKeyboardKeyId).writeReturning(
        CommandTriggerKeyboardKeysCompanion(scanCode: Value(scanCode)),
      ))
          .single;

  /// Update the [control], [alt], and [shift] modifiers for the keyboard key
  /// with the given [commandTriggerKeyboardKeyId].
  Future<CommandTriggerKeyboardKey> setModifiers({
    required final int commandTriggerKeyboardKeyId,
    final bool? control,
    final bool? alt,
    final bool? shift,
  }) async {
    if (control == null && alt == null && shift == null) {
      throw StateError('At least one modifier must be present.');
    }
    const absent = Value<bool>.absent();
    final query = getUpdateQuery(commandTriggerKeyboardKeyId);
    final rows = await query.writeReturning(
      CommandTriggerKeyboardKeysCompanion(
        control: control == null ? absent : Value(control),
        alt: alt == null ? absent : Value(alt),
        shift: shift == null ? absent : Value(shift),
      ),
    );
    return rows.single;
  }
}
