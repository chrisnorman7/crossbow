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
}
