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

  /// Commands called by activating a [CustomLevelCommand].
  activatingCustomLevelCommand,

  /// Commands called by releasing a [CustomLevelCommand].
  releaseCustomLevelCommand,
}
