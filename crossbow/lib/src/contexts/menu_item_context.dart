import 'package:crossbow_backend/crossbow_backend.dart';

import 'value_context.dart';

/// A value context to hold a [menu], and a menu item [value].
class MenuItemContext extends ValueContext<MenuItem> {
  /// Create and instance.
  const MenuItemContext({
    required super.projectContext,
    required this.menu,
    required super.value,
  });

  /// The menu that [value] belongs to.
  final Menu menu;
}
