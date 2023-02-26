import 'package:drift/drift.dart';

import '../database/database.dart';
import '../database/tables/menu_items.dart';
import '../database/tables/menus.dart';

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

  /// Get the menu with the given [id].
  Future<Menu> getMenu({required final int id}) async {
    final query = select(menus)..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Delete the menu with the given [id].
  Future<int> deleteMenu({required final int id}) {
    final query = delete(menus)..where((final table) => table.id.equals(id));
    return query.go();
  }

  /// Set the name of the menu with the given [menuId].
  Future<Menu> setName({
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
