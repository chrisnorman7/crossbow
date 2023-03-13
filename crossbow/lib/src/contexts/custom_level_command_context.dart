import 'package:crossbow_backend/crossbow_backend.dart';

import 'value_context.dart';

/// A value context that holds an additional [commandTrigger].
class CustomLevelCommandContext extends ValueContext<CustomLevelCommand> {
  /// Create an instance.
  const CustomLevelCommandContext({
    required super.projectContext,
    required super.value,
    required this.commandTrigger,
  });

  /// The command trigger to use.
  final CommandTrigger commandTrigger;
}
