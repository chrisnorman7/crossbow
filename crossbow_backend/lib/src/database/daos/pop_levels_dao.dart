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

  /// Get an [update] query that matches [popLevel].
  UpdateStatement<$PopLevelsTable, PopLevel> getUpdateQuery(
    final PopLevel popLevel,
  ) =>
      update(popLevels)..where((final table) => table.id.equals(popLevel.id));

  /// Set [fadeLength] for [popLevel].
  Future<PopLevel> setFadeLength({
    required final PopLevel popLevel,
    final double? fadeLength,
  }) async =>
      (await getUpdateQuery(popLevel).writeReturning(
        PopLevelsCompanion(fadeLength: Value(fadeLength)),
      ))
          .single;

  /// Delete [popLevel].
  Future<int> deletePopLevel({
    required final PopLevel popLevel,
  }) async {
    final query = delete(popLevels)
      ..where((final table) => table.id.equals(popLevel.id));
    return query.go();
  }

  /// Set the [description] for [popLevel].
  Future<PopLevel> setDescription({
    required final PopLevel popLevel,
    required final String description,
  }) async =>
      (await getUpdateQuery(popLevel).writeReturning(
        PopLevelsCompanion(description: Value(description)),
      ))
          .single;

  /// Set the [variableName] for [popLevel].
  Future<PopLevel> setVariableName({
    required final PopLevel popLevel,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(popLevel).writeReturning(
        PopLevelsCompanion(variableName: Value(variableName)),
      ))
          .single;
}
