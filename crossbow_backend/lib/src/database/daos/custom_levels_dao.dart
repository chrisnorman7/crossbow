import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/custom_levels.dart';

part 'custom_levels_dao.g.dart';

/// The custom levels DAO.
@DriftAccessor(tables: [CustomLevels])
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
}
