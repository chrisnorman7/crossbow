import 'package:crossbow_backend/crossbow_backend.dart';

import 'call_commands_target.dart';

/// A context for retrieving a list of [CallCommand]s.
class CallCommandsContext {
  /// Create an instance.
  const CallCommandsContext({required this.target, required this.id});

  /// The target of the call commands query.
  final CallCommandsTarget target;

  /// The ID to use.
  final int id;
}
