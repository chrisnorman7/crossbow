import 'package:crossbow_backend/crossbow_backend.dart';

/// A class to hold a [pushMenu] and its attached [menu].
class PushMenuContext {
  /// Create an instance.
  const PushMenuContext({
    required this.pushMenu,
    required this.menu,
  });

  /// The push menu to use.
  final PushMenu pushMenu;

  /// The menu to use.
  final Menu menu;
}
