import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

import '../database.dart';
import '../tables/pinned_commands.dart';

part 'pinned_commands_dao.g.dart';

/// The pinned commands DAO.
@DriftAccessor(tables: [PinnedCommands])
class PinnedCommandsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$PinnedCommandsDaoMixin {
  /// Create an instance.
  PinnedCommandsDao(super.db);

  /// Get an [update] query that matches on the given [id].
  UpdateStatement<$PinnedCommandsTable, PinnedCommand> getUpdateQuery(
    final int id,
  ) =>
      update(pinnedCommands)..where((final table) => table.id.equals(id));

  /// Pin the command with the given [commandId] with the given [name].
  Future<PinnedCommand> createPinnedCommand({
    required final int commandId,
    required final String name,
  }) =>
      into(pinnedCommands).insertReturning(
        PinnedCommandsCompanion(
          commandId: Value(commandId),
          name: Value(name),
        ),
      );

  /// Get the pinned command with the given [id].
  Future<PinnedCommand> getPinnedCommand({required final int id}) {
    final query = select(pinnedCommands)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Set the [name] for the pinned command with the given [pinnedCommandId].
  Future<PinnedCommand> setName({
    required final int pinnedCommandId,
    required final String name,
  }) async =>
      (await getUpdateQuery(pinnedCommandId)
              .writeReturning(PinnedCommandsCompanion(name: Value(name))))
          .single;

  /// Delete the pinned command with the given [pinnedCommandId].
  ///
  /// This method will not delete the associated row from the [commands] table.
  @internal
  Future<int> deletePinnedCommand({required final int pinnedCommandId}) {
    final query = delete(pinnedCommands)
      ..where((final table) => table.id.equals(pinnedCommandId));
    return query.go();
  }
}
