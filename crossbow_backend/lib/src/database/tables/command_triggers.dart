import 'package:dart_sdl/dart_sdl.dart';
import 'package:drift/drift.dart';

import '../mixins.dart';
import 'command_trigger_keyboard_keys.dart';

/// The command triggers table.
class CommandTriggers extends Table with WithPrimaryKey {
  /// The description of this command trigger.
  TextColumn get description => text()();

  /// The game controller button that will trigger this command.
  IntColumn get gameControllerButton =>
      intEnum<GameControllerButton>().nullable()();

  /// The keyboard key to use.
  IntColumn get keyboardKeyId => integer()
      .references(CommandTriggerKeyboardKeys, #id, onDelete: KeyAction.setNull)
      .nullable()();
}
