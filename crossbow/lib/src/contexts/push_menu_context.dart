import 'package:crossbow_backend/crossbow_backend.dart';

import 'value_context.dart';

/// A class to hold a push menu [value] and its attached [menu].
class PushMenuContext extends ValueContext<PushMenu> {
  /// Create an instance.
  const PushMenuContext({
    required super.projectContext,
    required super.value,
    required this.menu,
  });

  /// The menu that [value] references.
  final Menu menu;
}
