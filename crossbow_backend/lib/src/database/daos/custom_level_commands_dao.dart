import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/call_commands.dart';
import '../tables/custom_level_commands.dart';

part 'custom_level_commands_dao.g.dart';

/// The custom level commands DAO.
@DriftAccessor(tables: [CustomLevelCommands, CallCommands])
class CustomLevelCommandsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$CustomLevelCommandsDaoMixin {
  /// Create an instance.
  CustomLevelCommandsDao(super.db);

  /// Create a new custom level command.
  Future<CustomLevelCommand> createCustomLevelCommand({
    required final CustomLevel customLevel,
    required final CommandTrigger commandTrigger,
    final int? interval,
  }) =>
      into(customLevelCommands).insertReturning(
        CustomLevelCommandsCompanion(
          commandTriggerId: Value(commandTrigger.id),
          customLevelId: Value(customLevel.id),
          interval: Value(interval),
        ),
      );

  /// Get a custom level command with the given [id].
  Future<CustomLevelCommand> getCustomLevelCommand({required final int id}) =>
      (select(customLevelCommands)..where((final table) => table.id.equals(id)))
          .getSingle();

  /// Get an [update] query which matches [customLevelCommand].
  UpdateStatement<$CustomLevelCommandsTable, CustomLevelCommand> getUpdateQuery(
    final CustomLevelCommand customLevelCommand,
  ) =>
      update(customLevelCommands)
        ..where((final table) => table.id.equals(customLevelCommand.id));

  /// Set the [commandTrigger] for [customLevelCommand].
  Future<CustomLevelCommand> setCommandTrigger({
    required final CustomLevelCommand customLevelCommand,
    required final CommandTrigger commandTrigger,
  }) async =>
      (await getUpdateQuery(customLevelCommand).writeReturning(
        CustomLevelCommandsCompanion(
          commandTriggerId: Value(commandTrigger.id),
        ),
      ))
          .single;

  /// Delete [customLevelCommand].
  Future<int> deleteCustomLevelCommand({
    required final CustomLevelCommand customLevelCommand,
  }) =>
      (delete(customLevelCommands)
            ..where((final table) => table.id.equals(customLevelCommand.id)))
          .go();

  /// Get the activation call commands associated with [customLevelCommand].
  Future<List<CallCommand>> getCallCommands({
    required final CustomLevelCommand customLevelCommand,
  }) =>
      (select(callCommands)
            ..where(
              (final table) => table.callingCustomLevelCommandId
                  .equals(customLevelCommand.id),
            ))
          .get();

  /// Get the release call commands associated with [customLevelCommand].
  Future<List<CallCommand>> getReleaseCommands({
    required final CustomLevelCommand customLevelCommand,
  }) =>
      (select(callCommands)
            ..where(
              (final table) => table.releasingCustomLevelCommandId.equals(
                customLevelCommand.id,
              ),
            ))
          .get();

  /// Set the [interval] for [customLevelCommand].
  Future<CustomLevelCommand> setInterval({
    required final CustomLevelCommand customLevelCommand,
    final int? interval,
  }) async =>
      (await getUpdateQuery(customLevelCommand).writeReturning(
        CustomLevelCommandsCompanion(interval: Value(interval)),
      ))
          .single;
}
