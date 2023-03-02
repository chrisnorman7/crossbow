import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

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

  /// Set the [fadeLength] for the pop level with the given [id].
  Future<PopLevel> setFadeLength({
    required final int id,
    final double? fadeLength,
  }) async {
    final query = update(popLevels)
      ..where((final table) => table.id.equals(id));
    return (await query
            .writeReturning(PopLevelsCompanion(fadeLength: Value(fadeLength))))
        .single;
  }

  /// Delete the pop level with the given [id].
  @internal
  Future<int> deletePopLevel({required final int id}) async {
    final query = delete(popLevels)
      ..where((final table) => table.id.equals(id));
    return query.go();
  }
}
