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
  }) =>
      into(menus).insertReturning(MenusCompanion(name: Value(name)));

  /// Create a menu item in the menu with the given [menuId].
  ///
  /// The created [MenuItem] will have the given [name].
  Future<MenuItem> createMenuItem({
    required final int menuId,
    required final String name,
    final int position = 0,
  }) =>
      into(menuItems).insertReturning(
        MenuItemsCompanion(
          menuId: Value(menuId),
          name: Value(name),
          position: Value(position),
        ),
      );

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
}
