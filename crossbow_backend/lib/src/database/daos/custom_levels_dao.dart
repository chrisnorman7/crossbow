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
  }) =>
      into(customLevels)
          .insertReturning(CustomLevelsCompanion(name: Value(name)));

  /// Get a custom level with the given [id].
  Future<CustomLevel> getCustomLevel({required final int id}) =>
      (select(customLevels)..where((final table) => table.id.equals(id)))
          .getSingle();
}
