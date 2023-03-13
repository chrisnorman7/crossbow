import 'package:crossbow_backend/crossbow_backend.dart';

import 'value_context.dart';

/// A value context which includes a [pinnedCommand].
class CallCommandContext extends ValueContext<CallCommand> {
  /// Create an instance.
  const CallCommandContext({
    required super.projectContext,
    required super.value,
    required this.pinnedCommand,
  });

  /// The pinned command that is associated with [value].
  final PinnedCommand? pinnedCommand;
}
