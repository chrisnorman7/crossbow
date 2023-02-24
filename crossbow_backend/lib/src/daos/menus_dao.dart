import 'package:drift/drift.dart';

import '../../database.dart';

part 'menus_dao.g.dart';

/// The DAO for menus.
@DriftAccessor(tables: [Menus, MenuItems])
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
          onCancelCallCommandId: Value(onCancelCallCommandId),
        ),
      );

  /// Create a menu item in the menu with the given [menuId].
  ///
  /// The created [MenuItem] will have the given [name].
  Future<MenuItem> createMenuItem({
    required final int menuId,
    required final String name,
    final int? activateSoundId,
    final int? callCommandId,
    final int position = 0,
    final int? selectSoundId,
  }) =>
      into(menuItems).insertReturning(
        MenuItemsCompanion(
          menuId: Value(menuId),
          name: Value(name),
          activateSoundId: Value(activateSoundId),
          callCommandId: Value(callCommandId),
          selectSoundId: Value(selectSoundId),
          position: Value(position),
        ),
      );

  /// Get the menu with the given [id].
  Future<Menu> getMenu({required final int id}) async {
    final query = select(menus)..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Get the menu item with the given [id].
  Future<MenuItem> getMenuItem({required final int id}) async {
    final query = select(menuItems)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Get the menu items for the menu with the given [menuId].
  Future<List<MenuItem>> getMenuItems({
    required final int menuId,
  }) {
    final query = select(menuItems)
      ..where((final table) => table.menuId.equals(menuId))
      ..orderBy([(final table) => OrderingTerm.asc(table.position)]);
    return query.get();
  }

  /// Move the [MenuItem] with the given [menuItemId] to the new [position].
  Future<MenuItem> moveMenuItem({
    required final int menuItemId,
    required final int position,
  }) async {
    final query = update(menuItems)
      ..where((final table) => table.id.equals(menuItemId));
    return (await query
            .writeReturning(MenuItemsCompanion(position: Value(position))))
        .single;
  }

  /// Delete the menu item with the given [id].
  Future<int> deleteMenuItem({required final int id}) {
    final query = delete(menuItems)
      ..where((final table) => table.id.equals(id));
    return query.go();
  }

  /// Delete the menu with the given [id].
  Future<int> deleteMenu({required final int id}) {
    final query = delete(menus)..where((final table) => table.id.equals(id));
    return query.go();
  }

  /// Set the [MenuItem] with the given [menuItemId] to have a [CallCommand]
  /// with the given [callCommandId].
  Future<MenuItem> setMenuItemCallCommand({
    required final int menuItemId,
    required final int callCommandId,
  }) async {
    final query = update(menuItems)
      ..where((final table) => table.id.equals(menuItemId));
    return (await query.writeReturning(
      MenuItemsCompanion(callCommandId: Value(callCommandId)),
    ))
        .single;
  }

  /// Set the name of the menu with the given [menuId].
  Future<Menu> setMenuName({
    required final int menuId,
    required final String name,
  }) async {
    final query = update(menus)
      ..where((final table) => table.id.equals(menuId));
    return (await query.writeReturning(MenusCompanion(name: Value(name))))
        .single;
  }

  /// Set the `onCancelCallCommandId` for the menu with the given [menuId].
  Future<Menu> setOnCancelCallCommandId({
    required final int menuId,
    final int? callCommandId,
  }) async {
    final query = update(menus)
      ..where((final table) => table.id.equals(menuId));
    return (await query.writeReturning(
      MenusCompanion(onCancelCallCommandId: Value(callCommandId)),
    ))
        .single;
  }

  /// Rename the menu item with the given [menuItemId].
  Future<MenuItem> setMenuItemName({
    required final int menuItemId,
    required final String name,
  }) async {
    final query = update(menuItems)
      ..where((final table) => table.id.equals(menuItemId));
    return (await query.writeReturning(MenuItemsCompanion(name: Value(name))))
        .single;
  }

  /// Set the [musicId] for the menu with the given [menuId].
  Future<Menu> setMusicId({
    required final int menuId,
    final int? musicId,
  }) async {
    final query = update(menus)
      ..where((final table) => table.id.equals(menuId));
    return (await query.writeReturning(MenusCompanion(musicId: Value(musicId))))
        .single;
  }

  /// Set the [activateItemSoundId] for the menu with the given [menuId].
  Future<Menu> setActivateItemSoundId({
    required final int menuId,
    final int? activateItemSoundId,
  }) async {
    final query = update(menus)
      ..where((final table) => table.id.equals(menuId));
    return (await query.writeReturning(
      MenusCompanion(activateItemSoundId: Value(activateItemSoundId)),
    ))
        .single;
  }

  /// Set the [selectItemSoundId] for the menu with the given [menuId].
  Future<Menu> setSelectItemSoundId({
    required final int menuId,
    final int? selectItemSoundId,
  }) async {
    final query = update(menus)
      ..where((final table) => table.id.equals(menuId));
    return (await query.writeReturning(
      MenusCompanion(selectItemSoundId: Value(selectItemSoundId)),
    ))
        .single;
  }
}
