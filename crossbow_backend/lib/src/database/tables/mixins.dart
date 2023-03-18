import 'package:drift/drift.dart';

/// Add an [id] primary key.
mixin WithPrimaryKey on Table {
  /// The primary key.
  IntColumn get id => integer().autoIncrement()();
}

/// Add a [name] field.
mixin WithName on Table {
  /// The name of this object.
  TextColumn get name => text()
      .withLength(max: 100)
      .withDefault(const Constant('Untitled Object'))();
}

/// Add a [fadeLength] column.
mixin WithFadeLength on Table {
  /// The fade length to use when pushing a level.
  RealColumn get fadeLength => real().nullable()();
}

/// Add a [after] column.
mixin WithAfter on Table {
  /// How many milliseconds to wait before doing something.
  IntColumn get after => integer().nullable()();
}

/// Add the [interval] column.
mixin WithInterval on Table {
  /// How often something should happen.
  IntColumn get interval => integer().nullable()();
}
