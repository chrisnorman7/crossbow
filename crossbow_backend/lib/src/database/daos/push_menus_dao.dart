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
    required final Menu menu,
    final int? after,
    final double? fadeLength,
  }) =>
      into(pushMenus).insertReturning(
        PushMenusCompanion(
          menuId: Value(menu.id),
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

  /// Delete [pushMenu].
  Future<int> deletePushMenu({required final PushMenu pushMenu}) async {
    final query = delete(pushMenus)
      ..where((final table) => table.id.equals(pushMenu.id));
    return query.go();
  }

  /// Get an [update] query that matches [pushMenu].
  UpdateStatement<$PushMenusTable, PushMenu> getUpdateQuery(
    final PushMenu pushMenu,
  ) =>
      update(pushMenus)..where((final table) => table.id.equals(pushMenu.id));

  /// Set the [menu] for [pushMenu].
  Future<PushMenu> setMenu({
    required final PushMenu pushMenu,
    required final Menu menu,
  }) async =>
      (await getUpdateQuery(pushMenu)
              .writeReturning(PushMenusCompanion(menuId: Value(menu.id))))
          .single;

  /// Set the [after] value for [pushMenu].
  Future<PushMenu> setAfter({
    required final PushMenu pushMenu,
    final int? after,
  }) async =>
      (await getUpdateQuery(pushMenu)
              .writeReturning(PushMenusCompanion(after: Value(after))))
          .single;

  /// Set the [fadeLength] value for [pushMenu].
  Future<PushMenu> setFadeLength({
    required final PushMenu pushMenu,
    final double? fadeLength,
  }) async =>
      (await getUpdateQuery(pushMenu).writeReturning(
        PushMenusCompanion(fadeLength: Value(fadeLength)),
      ))
          .single;

  /// Set the [variableName] for [pushMenu].
  Future<PushMenu> setVariableName({
    required final PushMenu pushMenu,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(pushMenu).writeReturning(
        PushMenusCompanion(variableName: Value(variableName)),
      ))
          .single;

  /// Get all push menus in the database.
  Future<List<PushMenu>> getPushMenus() => select(pushMenus).get();
}
