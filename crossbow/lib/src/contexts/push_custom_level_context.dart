import 'package:crossbow_backend/crossbow_backend.dart';

import 'value_context.dart';

/// Holds a push custom level [value], and the [customLevel] to be pushed.
class PushCustomLevelContext extends ValueContext<PushCustomLevel> {
  /// Create an instance.
  const PushCustomLevelContext({
    required super.projectContext,
    required super.value,
    required this.customLevel,
  });

  /// The custom level which will be pushed by [value].
  final CustomLevel customLevel;
}
