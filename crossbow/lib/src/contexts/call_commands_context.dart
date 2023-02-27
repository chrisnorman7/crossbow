import 'package:crossbow_backend/crossbow_backend.dart';

/// What sort of command should be edited.
///
/// The [values] in this enum affect the generated SQL query.
enum CallCommandsTarget {
  /// Commands called by a [Command].
  command,

  /// Commands called by a [MenuItem].
  menuItem,

  /// Commands to be called from a [Menu]'s `onCancel` handler.
  menuOnCancel,
}

/// A context for retrieving a list of [CallCommand]s.
class CallCommandsContext {
  /// Create an instance.
  const CallCommandsContext({required this.target, required this.id});

  /// The target of the call commands query.
  final CallCommandsTarget target;

  /// The ID to use.
  final int id;
}
