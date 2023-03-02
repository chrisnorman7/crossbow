import 'package:crossbow_backend/crossbow_backend.dart';

import 'value_context.dart';

/// Hold the context for a menu.
class MenuContext extends ValueContext<Menu> {
  /// Create an instance.
  const MenuContext({
    required super.projectContext,
    required super.value,
    required this.menuItems,
  });

  /// The menu items for the attached [value].
  final List<MenuItem> menuItems;
}
