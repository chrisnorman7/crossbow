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
    required final int customLevelId,
    required final int commandTriggerId,
    final int? interval,
  }) =>
      into(customLevelCommands).insertReturning(
        CustomLevelCommandsCompanion(
          commandTriggerId: Value(commandTriggerId),
          customLevelId: Value(customLevelId),
          interval: Value(interval),
        ),
      );

  /// Get a custom level command with the given [id].
  Future<CustomLevelCommand> getCustomLevelCommand({required final int id}) =>
      (select(customLevelCommands)..where((final table) => table.id.equals(id)))
          .getSingle();

  /// Get an [update] query which matches on the given [id].
  UpdateStatement<$CustomLevelCommandsTable, CustomLevelCommand> getUpdateQuery(
    final int id,
  ) =>
      update(customLevelCommands)..where((final table) => table.id.equals(id));

  /// Set the [commandTriggerId] for the custom level command with the ID
  /// [customLevelCommandId].
  Future<CustomLevelCommand> setCommandTriggerId({
    required final int customLevelCommandId,
    required final int commandTriggerId,
  }) async =>
      (await getUpdateQuery(customLevelCommandId).writeReturning(
        CustomLevelCommandsCompanion(
          commandTriggerId: Value(commandTriggerId),
        ),
      ))
          .single;

  /// Delete the command with the given [id].
  Future<int> deleteCustomLevelCommand({
    required final int id,
  }) =>
      (delete(customLevelCommands)..where((final table) => table.id.equals(id)))
          .go();

  /// Get the activation call commands associated with the custom level command
  /// with the given [customLevelCommandId].
  Future<List<CallCommand>> getCallCommands({
    required final int customLevelCommandId,
  }) =>
      (select(callCommands)
            ..where(
              (final table) => table.callingCustomLevelCommandId
                  .equals(customLevelCommandId),
            ))
          .get();

  /// Get the release call commands associated with the custom level command
  /// with the given [customLevelCommandId].
  Future<List<CallCommand>> getReleaseCommands({
    required final int customLevelCommandId,
  }) =>
      (select(callCommands)
            ..where(
              (final table) => table.releasingCustomLevelCommandId
                  .equals(customLevelCommandId),
            ))
          .get();

  /// Set the [interval] value for the custom level command with the given
  /// [customLevelCommandId].
  Future<CustomLevelCommand> setInterval({
    required final int customLevelCommandId,
    final int? interval,
  }) async =>
      (await getUpdateQuery(customLevelCommandId).writeReturning(
        CustomLevelCommandsCompanion(interval: Value(interval)),
      ))
          .single;
}
