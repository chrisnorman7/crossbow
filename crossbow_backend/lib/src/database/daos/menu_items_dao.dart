import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/call_commands.dart';
import '../tables/menu_items.dart';

part 'menu_items_dao.g.dart';

/// A DAO for menu items.
@DriftAccessor(tables: [MenuItems, CallCommands])
class MenuItemsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$MenuItemsDaoMixin {
  /// Create an instance.
  MenuItemsDao(super.db);

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
          selectSoundId: Value(selectSoundId),
          position: Value(position),
        ),
      );

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

  /// Rename the menu item with the given [menuItemId].
  Future<MenuItem> setName({
    required final int menuItemId,
    required final String name,
  }) async {
    final query = update(menuItems)
      ..where((final table) => table.id.equals(menuItemId));
    return (await query.writeReturning(MenuItemsCompanion(name: Value(name))))
        .single;
  }

  /// Set the select sound for the menu item with the given [menuItemId].
  Future<MenuItem> setSelectSoundId({
    required final int menuItemId,
    final int? selectSoundId,
  }) async {
    final query = update(menuItems)
      ..where((final table) => table.id.equals(menuItemId));
    return (await query.writeReturning(
      MenuItemsCompanion(selectSoundId: Value(selectSoundId)),
    ))
        .single;
  }

  /// Set the select sound for the menu item with the given [menuItemId].
  Future<MenuItem> setActivateSoundId({
    required final int menuItemId,
    final int? activateSoundId,
  }) async {
    final query = update(menuItems)
      ..where((final table) => table.id.equals(menuItemId));
    return (await query.writeReturning(
      MenuItemsCompanion(activateSoundId: Value(activateSoundId)),
    ))
        .single;
  }

  /// Get the calling commands for the menu item with the given [menuItemId].
  Future<List<CallCommand>> getCallCommands({required final int menuItemId}) =>
      (select(callCommands)
            ..where(
              (final table) => table.callingMenuItemId.equals(menuItemId),
            ))
          .get();
}
