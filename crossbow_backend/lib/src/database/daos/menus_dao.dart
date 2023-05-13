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
    final int? activateItemSoundId,
    final int? musicId,
    final int? selectItemSoundId,
    final int? onCancelCallCommandId,
  }) =>
      into(menus).insertReturning(
        MenusCompanion(
          name: Value(name),
          activateItemSoundId: Value(activateItemSoundId),
          selectItemSoundId: Value(selectItemSoundId),
          musicId: Value(musicId),
        ),
      );

  /// Get the menu with the given [id].
  Future<Menu> getMenu({required final int id}) async {
    final query = select(menus)..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Delete the menu with the given [id].
  @internal
  Future<int> deleteMenu({required final int id}) {
    final query = delete(menus)..where((final table) => table.id.equals(id));
    return query.go();
  }

  /// Get an [update] query that matches on [id].
  UpdateStatement<$MenusTable, Menu> getUpdateQuery(final int id) =>
      update(menus)..where((final table) => table.id.equals(id));

  /// Set the [name] of the menu with the given [menuId].
  Future<Menu> setName({
    required final int menuId,
    required final String name,
  }) async =>
      (await getUpdateQuery(menuId)
              .writeReturning(MenusCompanion(name: Value(name))))
          .single;

  /// Set the [musicId] for the menu with the given [menuId].
  Future<Menu> setMusicId({
    required final int menuId,
    final int? musicId,
  }) async =>
      (await getUpdateQuery(menuId)
              .writeReturning(MenusCompanion(musicId: Value(musicId))))
          .single;

  /// Set the [activateItemSoundId] for the menu with the given [menuId].
  Future<Menu> setActivateItemSoundId({
    required final int menuId,
    final int? activateItemSoundId,
  }) async =>
      (await getUpdateQuery(menuId).writeReturning(
        MenusCompanion(activateItemSoundId: Value(activateItemSoundId)),
      ))
          .single;

  /// Set the [selectItemSoundId] for the menu with the given [menuId].
  Future<Menu> setSelectItemSoundId({
    required final int menuId,
    final int? selectItemSoundId,
  }) async =>
      (await getUpdateQuery(menuId).writeReturning(
        MenusCompanion(selectItemSoundId: Value(selectItemSoundId)),
      ))
          .single;

  /// Get the on cancel commands for the menu with the given [menuId].
  Future<List<CallCommand>> getOnCancelCallCommands({
    required final int menuId,
  }) =>
      (select(callCommands)
            ..where((final table) => table.onCancelMenuId.equals(menuId)))
          .get();

  /// Get all menus, ordered by their name.
  Future<List<Menu>> getMenus() async {
    final query = select(menus)
      ..orderBy([(final table) => OrderingTerm.asc(table.name)]);
    return query.get();
  }

  /// Set the [variableName] for the the row with the given [menuId].
  Future<Menu> setVariableName({
    required final int menuId,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(menuId).writeReturning(
        MenusCompanion(variableName: Value(variableName)),
      ))
          .single;
}
