import 'package:drift/drift.dart';

import 'mixins.dart';

/// The dart functions table.
class DartFunctions extends Table with WithPrimaryKey, WithDescription {
  /// The name of this function.
  TextColumn get functionName => text().nullable()();
}
