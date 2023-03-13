import 'package:dart_sdl/dart_sdl.dart';
import 'package:drift/drift.dart';

import 'mixins.dart';

/// The command keyboard triggers table.
class CommandTriggerKeyboardKeys extends Table with WithPrimaryKey {
  /// The scan code to use.
  IntColumn get scanCode => intEnum<ScanCode>()();

  /// Whether or not the control key must be held.
  BoolColumn get control => boolean().withDefault(const Constant(false))();

  /// Whether or not the alt key must be held.
  BoolColumn get alt => boolean().withDefault(const Constant(false))();

  /// Whether or not the shift key must be held.
  BoolColumn get shift => boolean().withDefault(const Constant(false))();
}
