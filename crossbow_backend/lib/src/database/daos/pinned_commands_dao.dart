import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/pinned_commands.dart';

part 'pinned_commands_dao.g.dart';

/// The pinned commands DAO.
@DriftAccessor(tables: [PinnedCommands])
class PinnedCommandsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$PinnedCommandsDaoMixin {
  /// Create an instance.
  PinnedCommandsDao(super.db);

  /// Get an [update] query that matches [pinnedCommand].
  UpdateStatement<$PinnedCommandsTable, PinnedCommand> getUpdateQuery(
    final PinnedCommand pinnedCommand,
  ) =>
      update(pinnedCommands)
        ..where((final table) => table.id.equals(pinnedCommand.id));

  /// Pin [command] with the given [name].
  Future<PinnedCommand> createPinnedCommand({
    required final Command command,
    required final String name,
  }) =>
      into(pinnedCommands).insertReturning(
        PinnedCommandsCompanion(
          commandId: Value(command.id),
          name: Value(name),
        ),
      );

  /// Get the pinned command with the given [id].
  Future<PinnedCommand> getPinnedCommand({required final int id}) {
    final query = select(pinnedCommands)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Set the [name] for [pinnedCommand].
  Future<PinnedCommand> setName({
    required final PinnedCommand pinnedCommand,
    required final String name,
  }) async =>
      (await getUpdateQuery(pinnedCommand)
              .writeReturning(PinnedCommandsCompanion(name: Value(name))))
          .single;

  /// Delete [pinnedCommand].
  ///
  /// This method *will not* delete the associated row from the [commands]
  /// table.
  Future<int> deletePinnedCommand({
    required final PinnedCommand pinnedCommand,
  }) {
    final query = delete(pinnedCommands)
      ..where((final table) => table.id.equals(pinnedCommand.id));
    return query.go();
  }

  /// Return a list of all pinned commands, sorted by name.
  Future<List<PinnedCommand>> getPinnedCommands() => (select(pinnedCommands)
        ..orderBy([(final table) => OrderingTerm.asc(table.name)]))
      .get();
}
