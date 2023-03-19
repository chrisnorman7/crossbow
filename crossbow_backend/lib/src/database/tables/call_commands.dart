import 'package:drift/drift.dart';

import 'commands.dart';
import 'custom_level_commands.dart';
import 'menu_items.dart';
import 'menus.dart';
import 'mixins.dart';

/// The call commands table.
class CallCommands extends Table with WithPrimaryKey, WithAfter {
  /// The ID of the command that will call this row.
  IntColumn get callingCommandId => integer()
      .references(Commands, #id, onDelete: KeyAction.cascade)
      .nullable()();

  /// The ID of the menu item that will call this command.
  IntColumn get callingMenuItemId => integer()
      .references(MenuItems, #id, onDelete: KeyAction.cascade)
      .nullable()();

  /// The ID of the menu whose on cancel action will call this command.
  IntColumn get onCancelMenuId => integer()
      .references(Menus, #id, onDelete: KeyAction.cascade)
      .nullable()();

  /// The ID of the custom level command whose activation will will call this
  /// command.
  IntColumn get callingCustomLevelCommandId => integer()
      .references(CustomLevelCommands, #id, onDelete: KeyAction.cascade)
      .nullable()();

  /// The ID of the custom level command whose release will will call this
  /// command.
  IntColumn get releasingCustomLevelCommandId => integer()
      .references(CustomLevelCommands, #id, onDelete: KeyAction.cascade)
      .nullable()();

  /// The ID of the command to call.
  IntColumn get commandId =>
      integer().references(Commands, #id, onDelete: KeyAction.cascade)();

  /// A random number to use to decide whether or not this command will run.
  IntColumn get randomNumberBase => integer().nullable()();
}
