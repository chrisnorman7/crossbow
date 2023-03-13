import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

import '../database.dart';
import '../tables/custom_level_commands.dart';
import '../tables/custom_levels.dart';

part 'custom_levels_dao.g.dart';

/// The custom levels DAO.
@DriftAccessor(tables: [CustomLevels, CustomLevelCommands])
class CustomLevelsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$CustomLevelsDaoMixin {
  /// Create an instance.
  CustomLevelsDao(super.db);

  /// Create a custom level.
  Future<CustomLevel> createCustomLevel({
    required final String name,
    final int? musicId,
  }) =>
      into(customLevels).insertReturning(
        CustomLevelsCompanion(
          name: Value(name),
          musicId: Value(musicId),
        ),
      );

  /// Get an [update] query, which matches on the given [id].
  UpdateStatement<$CustomLevelsTable, CustomLevel> getUpdateQuery(
    final int id,
  ) =>
      update(customLevels)..where((final table) => table.id.equals(id));

  /// Get a custom level with the given [id].
  Future<CustomLevel> getCustomLevel({required final int id}) =>
      (select(customLevels)..where((final table) => table.id.equals(id)))
          .getSingle();

  /// Set the [musicId] for the level with the given [customLevelId].
  Future<CustomLevel> setMusicId({
    required final int customLevelId,
    final int? musicId,
  }) async =>
      (await getUpdateQuery(customLevelId)
              .writeReturning(CustomLevelsCompanion(musicId: Value(musicId))))
          .single;

  /// Set the [name] for the level with the given [customLevelId].
  Future<CustomLevel> setName({
    required final int customLevelId,
    required final String name,
  }) async =>
      (await getUpdateQuery(customLevelId)
              .writeReturning(CustomLevelsCompanion(name: Value(name))))
          .single;

  /// Delete the level with the given [id].
  @internal
  Future<int> deleteCustomLevel({
    required final int id,
  }) =>
      (delete(customLevels)..where((final table) => table.id.equals(id))).go();

  /// Get the commands associated with the level with the given [customLevelId].
  Future<List<CustomLevelCommand>> getCustomLevelCommands({
    required final int customLevelId,
  }) {
    final query = select(customLevelCommands)
      ..where((final table) => table.customLevelId.equals(customLevelId));
    return query.get();
  }

  /// Get all the custom levels in the database.
  Future<List<CustomLevel>> getCustomLevels() {
    final query = select(customLevels)
      ..orderBy([(final table) => OrderingTerm.asc(table.name)]);
    return query.get();
  }
}
