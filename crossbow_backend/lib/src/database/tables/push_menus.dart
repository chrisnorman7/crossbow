import 'package:drift/drift.dart';

import 'menus.dart';
import 'mixins.dart';

/// The push menus table.
class PushMenus extends Table with WithPrimaryKey, WithAfter, WithFadeTime {
  /// The ID of the menu to push.
  IntColumn get menuId =>
      integer().references(Menus, #id, onDelete: KeyAction.cascade)();
}
