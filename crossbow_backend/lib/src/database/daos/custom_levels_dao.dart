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
    final AssetReference? music,
  }) =>
      into(customLevels).insertReturning(
        CustomLevelsCompanion(
          name: Value(name),
          musicId: Value(music?.id),
        ),
      );

  /// Get a custom level with the given [id].
  Future<CustomLevel> getCustomLevel({required final int id}) =>
      (select(customLevels)..where((final table) => table.id.equals(id)))
          .getSingle();

  /// Get an [update] query, which matches [customLevel].
  UpdateStatement<$CustomLevelsTable, CustomLevel> getUpdateQuery(
    final CustomLevel customLevel,
  ) =>
      update(customLevels)
        ..where((final table) => table.id.equals(customLevel.id));

  /// Set the [music] for [customLevel].
  Future<CustomLevel> setMusicId({
    required final CustomLevel customLevel,
    final AssetReference? music,
  }) async =>
      (await getUpdateQuery(customLevel)
              .writeReturning(CustomLevelsCompanion(musicId: Value(music?.id))))
          .single;

  /// Set the [name] for [customLevel].
  Future<CustomLevel> setName({
    required final CustomLevel customLevel,
    required final String name,
  }) async =>
      (await getUpdateQuery(customLevel)
              .writeReturning(CustomLevelsCompanion(name: Value(name))))
          .single;

  /// Delete [customLevel].
  @internal
  Future<int> deleteCustomLevel({
    required final CustomLevel customLevel,
  }) =>
      (delete(customLevels)
            ..where((final table) => table.id.equals(customLevel.id)))
          .go();

  /// Get the commands associated with [customLevel].
  Future<List<CustomLevelCommand>> getCustomLevelCommands({
    required final CustomLevel customLevel,
  }) =>
      (select(customLevelCommands)
            ..where(
              (final table) => table.customLevelId.equals(customLevel.id),
            ))
          .get();

  /// Get all the custom levels in the database.
  Future<List<CustomLevel>> getCustomLevels() {
    final query = select(customLevels)
      ..orderBy([(final table) => OrderingTerm.asc(table.name)]);
    return query.get();
  }

  /// Set the [variableName] for [customLevel].
  Future<CustomLevel> setVariableName({
    required final CustomLevel customLevel,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(customLevel).writeReturning(
        CustomLevelsCompanion(variableName: Value(variableName)),
      ))
          .single;
}
