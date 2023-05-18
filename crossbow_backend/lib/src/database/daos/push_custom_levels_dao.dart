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
    required final CustomLevel customLevel,
    final int? after,
    final double? fadeTime,
  }) =>
      into(pushCustomLevels).insertReturning(
        PushCustomLevelsCompanion(
          customLevelId: Value(customLevel.id),
          after: Value(after),
          fadeLength: Value(fadeTime),
        ),
      );

  /// Get the push custom level with the given [id].
  Future<PushCustomLevel> getPushCustomLevel({required final int id}) =>
      (select(pushCustomLevels)..where((final table) => table.id.equals(id)))
          .getSingle();

  /// Delete [pushCustomLevel].
  Future<int> deletePushCustomLevel({
    required final PushCustomLevel pushCustomLevel,
  }) =>
      (delete(pushCustomLevels)
            ..where((final table) => table.id.equals(pushCustomLevel.id)))
          .go();

  /// Get an [update] query that matches [pushCustomLevel].
  UpdateStatement<$PushCustomLevelsTable, PushCustomLevel> getUpdateQuery(
    final PushCustomLevel pushCustomLevel,
  ) =>
      update(pushCustomLevels)
        ..where((final table) => table.id.equals(pushCustomLevel.id));

  /// Set the [after] value for [pushCustomLevel].
  Future<PushCustomLevel> setAfter({
    required final PushCustomLevel pushCustomLevel,
    final int? after,
  }) async =>
      (await getUpdateQuery(pushCustomLevel)
              .writeReturning(PushCustomLevelsCompanion(after: Value(after))))
          .single;

  /// Set the [fadeLength] value for the [pushCustomLevel].
  Future<PushCustomLevel> setFadeLength({
    required final PushCustomLevel pushCustomLevel,
    final double? fadeLength,
  }) async =>
      (await getUpdateQuery(pushCustomLevel).writeReturning(
        PushCustomLevelsCompanion(fadeLength: Value(fadeLength)),
      ))
          .single;

  /// Set the [customLevel] that will be pushed by [pushCustomLevel].
  Future<PushCustomLevel> setCustomLevelId({
    required final PushCustomLevel pushCustomLevel,
    required final CustomLevel customLevel,
  }) async =>
      (await getUpdateQuery(pushCustomLevel).writeReturning(
        PushCustomLevelsCompanion(customLevelId: Value(customLevel.id)),
      ))
          .single;

  /// Set the [variableName] for [pushCustomLevel].
  Future<PushCustomLevel> setVariableName({
    required final PushCustomLevel pushCustomLevel,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(pushCustomLevel).writeReturning(
        PushCustomLevelsCompanion(variableName: Value(variableName)),
      ))
          .single;

  /// Get all push custom levels in the database.
  Future<List<PushCustomLevel>> getPushCustomLevels() =>
      select(pushCustomLevels).get();
}
