import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

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

  /// Create a menu item in the [menu].
  ///
  /// The created [MenuItem] will have the given [name].
  Future<MenuItem> createMenuItem({
    required final Menu menu,
    required final String name,
    final AssetReference? activateSound,
    final int position = 0,
    final AssetReference? selectSound,
  }) =>
      into(menuItems).insertReturning(
        MenuItemsCompanion(
          menuId: Value(menu.id),
          name: Value(name),
          activateSoundId: Value(activateSound?.id),
          selectSoundId: Value(selectSound?.id),
          position: Value(position),
        ),
      );

  /// Get the menu item with the given [id].
  Future<MenuItem> getMenuItem({required final int id}) async {
    final query = select(menuItems)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Get the menu items for [menu].
  Future<List<MenuItem>> getMenuItems({
    required final Menu menu,
  }) {
    final query = select(menuItems)
      ..where((final table) => table.menuId.equals(menu.id))
      ..orderBy([(final table) => OrderingTerm.asc(table.position)]);
    return query.get();
  }

  /// Get an [update] query that matches [menuItem].
  UpdateStatement<$MenuItemsTable, MenuItem> getUpdateQuery(
    final MenuItem menuItem,
  ) =>
      update(menuItems)..where((final table) => table.id.equals(menuItem.id));

  /// Move [menuItem] to the new [position].
  Future<MenuItem> moveMenuItem({
    required final MenuItem menuItem,
    required final int position,
  }) async =>
      (await getUpdateQuery(menuItem)
              .writeReturning(MenuItemsCompanion(position: Value(position))))
          .single;

  /// Delete [menuItem].
  @internal
  Future<int> deleteMenuItem({required final MenuItem menuItem}) {
    final query = delete(menuItems)
      ..where((final table) => table.id.equals(menuItem.id));
    return query.go();
  }

  /// Rename [menuItem] to [name].
  Future<MenuItem> setName({
    required final MenuItem menuItem,
    required final String name,
  }) async =>
      (await getUpdateQuery(menuItem)
              .writeReturning(MenuItemsCompanion(name: Value(name))))
          .single;

  /// Set the [selectSound] for [menuItem].
  Future<MenuItem> setSelectSound({
    required final MenuItem menuItem,
    final AssetReference? selectSound,
  }) async =>
      (await getUpdateQuery(menuItem).writeReturning(
        MenuItemsCompanion(selectSoundId: Value(selectSound?.id)),
      ))
          .single;

  /// Set the [activateSound] for [menuItem].
  Future<MenuItem> setActivateSound({
    required final MenuItem menuItem,
    final AssetReference? activateSound,
  }) async =>
      (await getUpdateQuery(menuItem).writeReturning(
        MenuItemsCompanion(activateSoundId: Value(activateSound?.id)),
      ))
          .single;

  /// Get the calling commands for [menuItem].
  Future<List<CallCommand>> getCallCommands({
    required final MenuItem menuItem,
  }) =>
      (select(callCommands)
            ..where(
              (final table) => table.callingMenuItemId.equals(menuItem.id),
            ))
          .get();

  /// Set the [variableName] for [menuItem].
  Future<MenuItem> setVariableName({
    required final MenuItem menuItem,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(menuItem).writeReturning(
        MenuItemsCompanion(variableName: Value(variableName)),
      ))
          .single;
}
