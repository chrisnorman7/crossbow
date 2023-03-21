import 'src/database/database.dart';

/// Add a [name] getter.
extension CommandTriggerExtensions on CommandTrigger {
  /// Get a suitable name for a trigger map.
  String get name => 'trigger$id';
}

/// Add a [name] getter.
extension DartFunctionExtensions on DartFunction {
  /// Get a suitable name.
  ///
  /// If [functionName] is `null`, use [id] instead.
  String get name => functionName ?? 'function$id';
}
