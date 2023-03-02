import 'package:crossbow_backend/crossbow_backend.dart';

import 'value_context.dart';

/// A value context which holds a command [value], as well as a [pinnedCommand].
class CommandContext extends ValueContext<Command> {
  /// Create an instance.
  const CommandContext({
    required super.projectContext,
    required super.value,
    required this.pinnedCommand,
  });

  /// The pinned command to use.
  final PinnedCommand? pinnedCommand;
}
