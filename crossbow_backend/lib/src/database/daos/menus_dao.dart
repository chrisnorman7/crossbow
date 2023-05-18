import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

import '../database.dart';
import '../tables/call_commands.dart';
import '../tables/menus.dart';

part 'menus_dao.g.dart';

/// The DAO for menus.
@DriftAccessor(tables: [Menus, CallCommands])
class MenusDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$MenusDaoMixin {
  /// Create an instance.
  MenusDao(super.db);

  /// Create a new menu.
  Future<Menu> createMenu({
    required final String name,
    final AssetReference? activateItemSound,
    final AssetReference? music,
    final AssetReference? selectItemSound,
  }) =>
      into(menus).insertReturning(
        MenusCompanion(
          name: Value(name),
          activateItemSoundId: Value(activateItemSound?.id),
          selectItemSoundId: Value(selectItemSound?.id),
          musicId: Value(music?.id),
        ),
      );

  /// Get the menu with the given [id].
  Future<Menu> getMenu({required final int id}) async {
    final query = select(menus)..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Delete [menu].
  @internal
  Future<int> deleteMenu({
    required final Menu menu,
  }) {
    final query = delete(menus)
      ..where((final table) => table.id.equals(menu.id));
    return query.go();
  }

  /// Get an [update] query that matches [menu].
  UpdateStatement<$MenusTable, Menu> getUpdateQuery(final Menu menu) =>
      update(menus)..where((final table) => table.id.equals(menu.id));

  /// Set the [name] of [menu].
  Future<Menu> setName({
    required final Menu menu,
    required final String name,
  }) async =>
      (await getUpdateQuery(menu)
              .writeReturning(MenusCompanion(name: Value(name))))
          .single;

  /// Set the [music] for [menu].
  Future<Menu> setMusicId({
    required final Menu menu,
    final AssetReference? music,
  }) async =>
      (await getUpdateQuery(menu)
              .writeReturning(MenusCompanion(musicId: Value(music?.id))))
          .single;

  /// Set the [activateItemSound] for [menu].
  Future<Menu> setActivateItemSoundId({
    required final Menu menu,
    final AssetReference? activateItemSound,
  }) async =>
      (await getUpdateQuery(menu).writeReturning(
        MenusCompanion(activateItemSoundId: Value(activateItemSound?.id)),
      ))
          .single;

  /// Set the [selectItemSound] for [menu].
  Future<Menu> setSelectItemSoundId({
    required final Menu menu,
    final AssetReference? selectItemSound,
  }) async =>
      (await getUpdateQuery(menu).writeReturning(
        MenusCompanion(selectItemSoundId: Value(selectItemSound?.id)),
      ))
          .single;

  /// Get the on cancel commands for [menu].
  Future<List<CallCommand>> getOnCancelCallCommands({
    required final Menu menu,
  }) =>
      (select(callCommands)
            ..where((final table) => table.onCancelMenuId.equals(menu.id)))
          .get();

  /// Get all menus, ordered by their name.
  Future<List<Menu>> getMenus() async {
    final query = select(menus)
      ..orderBy([(final table) => OrderingTerm.asc(table.name)]);
    return query.get();
  }

  /// Set the [variableName] for [menu].
  Future<Menu> setVariableName({
    required final Menu menu,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(menu).writeReturning(
        MenusCompanion(variableName: Value(variableName)),
      ))
          .single;
}
