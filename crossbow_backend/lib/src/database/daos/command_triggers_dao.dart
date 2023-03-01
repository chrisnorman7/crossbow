import 'package:dart_sdl/dart_sdl.dart';
import 'package:drift/drift.dart';

import '../../../crossbow_backend.dart';

part 'command_triggers_dao.g.dart';

/// The command triggers DAO.
@DriftAccessor(tables: [CommandTriggers])
class CommandTriggersDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$CommandTriggersDaoMixin {
  /// Create an instance.
  CommandTriggersDao(super.db);

  /// Create a new command trigger.
  Future<CommandTrigger> createCommandTrigger({
    required final String description,
    final GameControllerButton? gameControllerButton,
    final int? keyboardKeyId,
  }) =>
      into(commandTriggers).insertReturning(
        CommandTriggersCompanion(
          description: Value(description),
          gameControllerButton: Value(gameControllerButton),
          keyboardKeyId: Value(keyboardKeyId),
        ),
      );

  /// Get an [update] query which matches on the given [id].
  UpdateStatement<$CommandTriggersTable, CommandTrigger> getUpdateQuery(
    final int id,
  ) =>
      update(commandTriggers)..where((final table) => table.id.equals(id));

  /// Get the command trigger with the given [id].
  Future<CommandTrigger> getCommandTrigger({required final int id}) {
    final query = select(commandTriggers)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Change the [description] for the command trigger with the given
  /// [commandTriggerId].
  Future<CommandTrigger> setDescription({
    required final int commandTriggerId,
    required final String description,
  }) async =>
      (await getUpdateQuery(commandTriggerId).writeReturning(
        CommandTriggersCompanion(description: Value(description)),
      ))
          .single;

  /// Set the [gameControllerButton] for the command trigger with the given
  /// [commandTriggerId].
  Future<CommandTrigger> setGameControllerButton({
    required final int commandTriggerId,
    final GameControllerButton? gameControllerButton,
  }) async =>
      (await getUpdateQuery(commandTriggerId).writeReturning(
        CommandTriggersCompanion(
          gameControllerButton: Value(gameControllerButton),
        ),
      ))
          .single;

  /// Set the [keyboardKeyId] for the command trigger with the given
  /// [commandTriggerId].
  Future<CommandTrigger> setKeyboardKeyId({
    required final int commandTriggerId,
    final int? keyboardKeyId,
  }) async =>
      (await getUpdateQuery(commandTriggerId).writeReturning(
        CommandTriggersCompanion(keyboardKeyId: Value(keyboardKeyId)),
      ))
          .single;
}
