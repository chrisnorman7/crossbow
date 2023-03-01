import 'package:crossbow_backend/crossbow_backend.dart';

/// A class which provides a [projectContext], [commandTrigger], and
/// [commandTriggerKeyboardKey].
class CommandTriggerContext {
  /// Create an instance.
  const CommandTriggerContext({
    required this.projectContext,
    required this.commandTrigger,
    required this.commandTriggerKeyboardKey,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The command trigger to use.
  final CommandTrigger commandTrigger;

  /// The keyboard key which [commandTrigger] uses.
  final CommandTriggerKeyboardKey? commandTriggerKeyboardKey;
}
