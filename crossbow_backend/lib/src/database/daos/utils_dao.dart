import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/command_trigger_keyboard_keys.dart';
import '../tables/command_triggers.dart';
import '../tables/commands.dart';

part 'utils_dao.g.dart';

/// A DAO that adds utility methods to the [db].
@DriftAccessor(
  tables: [
    Commands,
    CommandTriggers,
    CommandTriggerKeyboardKeys,
  ],
)
class UtilsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$UtilsDaoMixin {
  /// Create an instance.
  UtilsDao(super.db);

  /// Delete the given [command], as well as all supporting rows.
  Future<void> deleteCommandFull(final Command command) async {
    final pushMenuId = command.pushMenuId;
    if (pushMenuId != null) {
      await db.pushMenusDao.deletePushMenu(id: pushMenuId);
    }
    final popLevelId = command.popLevelId;
    if (popLevelId != null) {
      await db.popLevelsDao.deletePopLevel(id: popLevelId);
    }
    final stopGameId = command.stopGameId;
    if (stopGameId != null) {
      await db.stopGamesDao.deleteStopGame(stopGameId: stopGameId);
    }
    final messageSoundId = command.messageSoundId;
    if (messageSoundId != null) {
      await db.assetReferencesDao.deleteAssetReference(id: messageSoundId);
    }
    await db.commandsDao.deleteCommand(id: command.id);
  }

  /// Delete the given [commandTrigger], as well as the connected
  /// [CommandTriggerKeyboardKey] instance.
  Future<void> deleteCommandTriggerFull(
    final CommandTrigger commandTrigger,
  ) async {
    final keyboardKeyId = commandTrigger.keyboardKeyId;
    if (keyboardKeyId != null) {
      await db.commandTriggerKeyboardKeysDao.deleteCommandTriggerKeyboardKey(
        commandTriggerKeyboardKeyId: keyboardKeyId,
      );
    }
    await db.commandTriggersDao
        .deleteCommandTrigger(commandTriggerId: commandTrigger.id);
  }
}
