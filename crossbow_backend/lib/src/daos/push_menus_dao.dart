import 'package:drift/drift.dart';

import '../../crossbow_backend.dart';

part 'push_menus_dao.g.dart';

/// Push menus DAO.
@DriftAccessor(tables: [PushMenus])
class PushMenusDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$PushMenusDaoMixin {
  /// Create an instance.
  PushMenusDao(super.db);

  /// Create a new push menu.
  Future<PushMenu> createPushMenu({required final int menuId}) =>
      into(pushMenus)
          .insertReturning(PushMenusCompanion(menuId: Value(menuId)));

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
}
