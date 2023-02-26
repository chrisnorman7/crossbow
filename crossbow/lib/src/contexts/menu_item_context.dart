import 'package:crossbow_backend/crossbow_backend.dart';

/// A context to hold a [menu], and a [menuItem].
class MenuItemContext {
  /// Create and instance.
  const MenuItemContext({
    required this.projectContext,
    required this.menu,
    required this.menuItem,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The menu that [menuItem] belongs to.
  final Menu menu;

  /// The menu to use.
  final MenuItem menuItem;
}
