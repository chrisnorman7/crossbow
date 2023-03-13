import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/call_commands.dart';

part 'utils_dao.g.dart';

/// A DAO that adds utility methods to the [db].
@DriftAccessor(
  tables: [CallCommands],
)
class UtilsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$UtilsDaoMixin {
  /// Create an instance.
  UtilsDao(super.db);

  /// Delete the given [commandTrigger], as well as the connected
  /// [CommandTriggerKeyboardKey] instance.
  Future<void> deleteCommandTrigger(
    final CommandTrigger commandTrigger,
  ) async {
    final keyboardKeyId = commandTrigger.keyboardKeyId;
    if (keyboardKeyId != null) {
      await db.commandTriggerKeyboardKeysDao.deleteCommandTriggerKeyboardKey(
        commandTriggerKeyboardKeyId: keyboardKeyId,
      );
    }
    await db.commandTriggersDao.deleteCommandTrigger(
      commandTriggerId: commandTrigger.id,
    );
  }

  /// Delete the given [command], as well as all supporting rows.
  ///
  /// If the [command] is pinned, throw [StateError].
  Future<void> deleteCommand(final Command command) async {
    final commandsDao = db.commandsDao;
    if (await commandsDao.isPinned(commandId: command.id)) {
      throw StateError('$command cannot be deleted because it is pinned.');
    }
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
    await commandsDao.deleteCommand(id: command.id);
  }

  /// Delete the given [menuItem] and all associated rows.
  Future<void> deleteMenuItem(final MenuItem menuItem) async {
    for (final id in [menuItem.activateSoundId, menuItem.selectSoundId]) {
      if (id != null) {
        await db.assetReferencesDao.deleteAssetReference(id: id);
      }
    }
    await db.menuItemsDao.deleteMenuItem(id: menuItem.id);
  }

  /// Delete the given [menu] and all related [MenuItem]s.
  Future<void> deleteMenu(final Menu menu) async {
    (await db.menuItemsDao.getMenuItems(menuId: menu.id))
        .forEach(deleteMenuItem);
    for (final id in [
      menu.activateItemSoundId,
      menu.musicId,
      menu.selectItemSoundId
    ]) {
      if (id != null) {
        await db.assetReferencesDao.deleteAssetReference(id: id);
      }
    }
    await db.menusDao.deleteMenu(id: menu.id);
  }
}
