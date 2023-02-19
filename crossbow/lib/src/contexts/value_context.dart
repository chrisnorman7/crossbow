import 'package:crossbow_backend/crossbow_backend.dart';

/// A context that holds a [value], and a [projectContext].
class ValueContext<T> {
  /// Create an instance.
  const ValueContext({
    required this.projectContext,
    required this.value,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The database row to reflect.
  final T value;
}
