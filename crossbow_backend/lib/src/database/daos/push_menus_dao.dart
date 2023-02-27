import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/push_menus.dart';

part 'push_menus_dao.g.dart';

/// Push menus DAO.
@DriftAccessor(tables: [PushMenus])
class PushMenusDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$PushMenusDaoMixin {
  /// Create an instance.
  PushMenusDao(super.db);

  /// Create a new push menu.
  Future<PushMenu> createPushMenu({
    required final int menuId,
    final int? after,
    final double? fadeLength,
  }) =>
      into(pushMenus).insertReturning(
        PushMenusCompanion(
          menuId: Value(menuId),
          after: Value(after),
          fadeLength: Value(fadeLength),
        ),
      );

  /// Get the push menu with the given [id].
  Future<PushMenu> getPushMenu({required final int id}) {
    final query = select(pushMenus)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Delete the push menu with the given [id].
  Future<int> deletePushMenu({required final int id}) async {
    final query = delete(pushMenus)
      ..where((final table) => table.id.equals(id));
    return query.go();
  }

  /// Set the [menuId] for the push menu with the given [pushMenuId].
  Future<PushMenu> setMenuId({
    required final int pushMenuId,
    required final int menuId,
  }) async {
    final query = update(pushMenus)
      ..where((final table) => table.id.equals(pushMenuId));
    return (await query
            .writeReturning(PushMenusCompanion(menuId: Value(menuId))))
        .single;
  }

  /// Set the [after] value for the push menu with the given [pushMenuId].
  Future<PushMenu> setAfter({
    required final int pushMenuId,
    final int? after,
  }) async {
    final query = update(pushMenus)
      ..where((final table) => table.id.equals(pushMenuId));
    return (await query.writeReturning(PushMenusCompanion(after: Value(after))))
        .single;
  }

  /// Set the [fadeLength] for the push menu with the given [pushMenuId].
  Future<PushMenu> setFadeLength({
    required final int pushMenuId,
    final double? fadeLength,
  }) async {
    final query = update(pushMenus)
      ..where((final table) => table.id.equals(pushMenuId));
    return (await query
            .writeReturning(PushMenusCompanion(fadeLength: Value(fadeLength))))
        .single;
  }
}
