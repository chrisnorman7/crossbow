import 'package:crossbow_backend/crossbow_backend.dart';

import 'value_context.dart';

/// A value context which provides a [projectContext], a command trigger
/// [value], and a [commandTriggerKeyboardKey].
class CommandTriggerContext extends ValueContext<CommandTrigger> {
  /// Create an instance.
  const CommandTriggerContext({
    required super.projectContext,
    required super.value,
    required this.commandTriggerKeyboardKey,
  });

  /// The keyboard key which [value] uses.
  final CommandTriggerKeyboardKey? commandTriggerKeyboardKey;
}
