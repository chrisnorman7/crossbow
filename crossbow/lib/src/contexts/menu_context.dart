import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:crossbow_backend/database.dart';

/// Hold the context for a menu.
class MenuContext {
  /// Create an instance.
  const MenuContext({
    required this.projectContext,
    required this.menu,
    required this.menuItems,
  });

  /// The project context to work with.
  final ProjectContext projectContext;

  /// The menu that has been loaded.
  final Menu menu;

  /// The menu items for the attached [menu].
  final List<MenuItem> menuItems;
}
