import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/custom_level_commands.dart';

part 'custom_level_commands_dao.g.dart';

/// The custom level commands DAO.
@DriftAccessor(tables: [CustomLevelCommands])
class CustomLevelCommandsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$CustomLevelCommandsDaoMixin {
  /// Create an instance.
  CustomLevelCommandsDao(super.db);

  /// Create a new custom level command.
  Future<CustomLevelCommand> createCustomLevelCommand({
    required final int customLevelId,
    required final int commandTriggerId,
  }) =>
      into(customLevelCommands).insertReturning(
        CustomLevelCommandsCompanion(
          commandTriggerId: Value(commandTriggerId),
          customLevelId: Value(customLevelId),
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

  /// Get the commands associated with the level with the given [customLevelId].
  Future<List<CustomLevelCommand>> getCustomLevelCommands({
    required final int customLevelId,
  }) {
    final query = select(customLevelCommands)
      ..where((final table) => table.customLevelId.equals(customLevelId));
    return query.get();
  }

  /// Delete the command with the given [id].
  Future<int> deleteCustomLevelCommand({
    required final int id,
  }) =>
      (delete(customLevelCommands)..where((final table) => table.id.equals(id)))
          .go();
}
