import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/pop_levels.dart';

part 'pop_levels_dao.g.dart';

/// The pop levels DAO.
@DriftAccessor(tables: [PopLevels])
class PopLevelsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$PopLevelsDaoMixin {
  /// Create an instance.
  PopLevelsDao(super.db);

  /// Create a pop level.
  Future<PopLevel> createPopLevel({final double? fadeLength}) => into(popLevels)
      .insertReturning(PopLevelsCompanion(fadeLength: Value(fadeLength)));

  /// Get a pop level with the given [id].
  Future<PopLevel> getPopLevel({required final int id}) {
    final query = select(popLevels)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Get an [update] query that matches on the given [id].
  UpdateStatement<$PopLevelsTable, PopLevel> getUpdateQuery(final int id) =>
      update(popLevels)..where((final table) => table.id.equals(id));

  /// Set the [fadeLength] for the pop level with the given [id].
  Future<PopLevel> setFadeLength({
    required final int id,
    final double? fadeLength,
  }) async =>
      (await getUpdateQuery(id).writeReturning(
        PopLevelsCompanion(fadeLength: Value(fadeLength)),
      ))
          .single;

  /// Delete the pop level with the given [id].
  Future<int> deletePopLevel({required final int id}) async {
    final query = delete(popLevels)
      ..where((final table) => table.id.equals(id));
    return query.go();
  }

  /// Set the [description] for the pop level with the given [popLevelId].
  Future<PopLevel> setDescription({
    required final int popLevelId,
    required final String description,
  }) async =>
      (await getUpdateQuery(popLevelId).writeReturning(
        PopLevelsCompanion(description: Value(description)),
      ))
          .single;

  /// Set the [variableName] for the pop level with the given [popLevelId].
  Future<PopLevel> setVariableName({
    required final int popLevelId,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(popLevelId).writeReturning(
        PopLevelsCompanion(variableName: Value(variableName)),
      ))
          .single;
}
