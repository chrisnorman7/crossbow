import 'package:dart_sdl/dart_sdl.dart';
import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

import '../../../crossbow_backend.dart';
import '../../../extensions.dart';

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
    final CommandTriggerKeyboardKey? keyboardKey,
  }) =>
      into(commandTriggers).insertReturning(
        CommandTriggersCompanion(
          description: Value(description),
          gameControllerButton: Value(gameControllerButton),
          keyboardKeyId: Value(keyboardKey?.id),
        ),
      );

  /// Get an [update] query which matches on the given [commandTrigger].
  UpdateStatement<$CommandTriggersTable, CommandTrigger> getUpdateQuery(
    final CommandTrigger commandTrigger,
  ) =>
      update(commandTriggers)
        ..where((final table) => table.id.equals(commandTrigger.id));

  /// Get the command trigger with the given [id].
  Future<CommandTrigger> getCommandTrigger({required final int id}) {
    final query = select(commandTriggers)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Change the [description] for [commandTrigger].
  Future<CommandTrigger> setDescription({
    required final CommandTrigger commandTrigger,
    required final String description,
  }) async =>
      (await getUpdateQuery(commandTrigger).writeReturning(
        CommandTriggersCompanion(description: Value(description)),
      ))
          .single;

  /// Set the [gameControllerButton] for [commandTrigger].
  Future<CommandTrigger> setGameControllerButton({
    required final CommandTrigger commandTrigger,
    final GameControllerButton? gameControllerButton,
  }) async =>
      (await getUpdateQuery(commandTrigger).writeReturning(
        CommandTriggersCompanion(
          gameControllerButton: Value(gameControllerButton),
        ),
      ))
          .single;

  /// Set the [keyboardKey] for the [commandTrigger].
  Future<CommandTrigger> setKeyboardKeyId({
    required final CommandTrigger commandTrigger,
    final CommandTriggerKeyboardKey? keyboardKey,
  }) async =>
      (await getUpdateQuery(commandTrigger).writeReturning(
        CommandTriggersCompanion(keyboardKeyId: Value(keyboardKey?.id)),
      ))
          .single;

  /// Get all the command triggers in the database.
  Future<List<CommandTrigger>> getCommandTriggers() {
    final query = select(commandTriggers)
      ..orderBy([(final table) => OrderingTerm.asc(table.description)]);
    return query.get();
  }

  /// Delete the [commandTrigger].
  @internal
  Future<int> deleteCommandTrigger({
    required final CommandTrigger commandTrigger,
  }) =>
      (delete(commandTriggers)
            ..where((final table) => table.id.equals(commandTrigger.id)))
          .go();

  /// Get the name of the command trigger with the given [commandTriggerId].
  Future<String> getCommandTriggerName({
    required final int commandTriggerId,
  }) async {
    final query = select(commandTriggers)
      ..where((final table) => table.id.equals(commandTriggerId));
    final commandTrigger = await query.getSingle();
    return commandTrigger.name;
  }

  /// Set the [variableName] for [commandTrigger].
  Future<CommandTrigger> setVariableName({
    required final CommandTrigger commandTrigger,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(commandTrigger).writeReturning(
        CommandTriggersCompanion(variableName: Value(variableName)),
      ))
          .single;
}
