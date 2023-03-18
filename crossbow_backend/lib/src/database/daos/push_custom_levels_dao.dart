import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/push_custom_levels.dart';

part 'push_custom_levels_dao.g.dart';

/// The push custom levels DAO.
@DriftAccessor(tables: [PushCustomLevels])
class PushCustomLevelsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$PushCustomLevelsDaoMixin {
  /// Create an instance.
  PushCustomLevelsDao(super.db);

  /// Create a new push custom level.
  Future<PushCustomLevel> createPushCustomLevel({
    required final int customLevelId,
    final int? after,
    final double? fadeTime,
  }) =>
      into(pushCustomLevels).insertReturning(
        PushCustomLevelsCompanion(
          after: Value(after),
          customLevelId: Value(customLevelId),
          fadeLength: Value(fadeTime),
        ),
      );

  /// Get the push custom level with the given [id].
  Future<PushCustomLevel> getPushCustomLevel({required final int id}) =>
      (select(pushCustomLevels)..where((final table) => table.id.equals(id)))
          .getSingle();

  /// Delete the push custom level with the given [id].
  Future<int> deletePushCustomLevel({
    required final int id,
  }) =>
      (delete(pushCustomLevels)..where((final table) => table.id.equals(id)))
          .go();

  /// Get an [update] query that matches the given [id].
  UpdateStatement<$PushCustomLevelsTable, PushCustomLevel> getUpdateQuery(
    final int id,
  ) =>
      update(pushCustomLevels)..where((final table) => table.id.equals(id));

  /// Set the [after] value for the push custom level with the given
  /// [pushCustomLevelId].
  Future<PushCustomLevel> setAfter({
    required final int pushCustomLevelId,
    final int? after,
  }) async =>
      (await getUpdateQuery(pushCustomLevelId)
              .writeReturning(PushCustomLevelsCompanion(after: Value(after))))
          .single;

  /// Set the [fadeLength] value for the push custom level with the given
  /// [pushCustomLevelId].
  Future<PushCustomLevel> setFadeLength({
    required final int pushCustomLevelId,
    final double? fadeLength,
  }) async =>
      (await getUpdateQuery(pushCustomLevelId).writeReturning(
        PushCustomLevelsCompanion(fadeLength: Value(fadeLength)),
      ))
          .single;

  /// Set the [customLevelId] value for a push custom level with the given
  /// [pushCustomLevelId].
  Future<PushCustomLevel> setCustomLevelId({
    required final int pushCustomLevelId,
    required final int customLevelId,
  }) async =>
      (await getUpdateQuery(pushCustomLevelId).writeReturning(
        PushCustomLevelsCompanion(customLevelId: Value(customLevelId)),
      ))
          .single;
}
