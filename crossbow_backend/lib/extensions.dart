import 'src/database/database.dart';

/// Add a [name] getter.
extension CommandTriggerExtensions on CommandTrigger {
  /// Get a suitable name for a trigger map.
  String get name => 'trigger$id';
}
