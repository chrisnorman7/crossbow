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
        commandTriggerKeyboardKey:
            await db.commandTriggerKeyboardKeysDao.getCommandTriggerKeyboardKey(
          id: keyboardKeyId,
        ),
      );
    }
    await db.commandTriggersDao.deleteCommandTrigger(
      commandTrigger: commandTrigger,
    );
  }

  /// Delete the given [command], as well as all supporting rows.
  ///
  /// If the [command] is pinned, throw [StateError].
  Future<void> deleteCommand(final Command command) async {
    final commandsDao = db.commandsDao;
    if (await commandsDao.isPinned(command: command)) {
      throw StateError('$command cannot be deleted because it is pinned.');
    }
    final pushMenuId = command.pushMenuId;
    if (pushMenuId != null) {
      final pushMenusDao = db.pushMenusDao;
      await pushMenusDao.deletePushMenu(
        pushMenu: await pushMenusDao.getPushMenu(
          id: pushMenuId,
        ),
      );
    }
    final popLevelId = command.popLevelId;
    if (popLevelId != null) {
      final popLevelsDao = db.popLevelsDao;
      await popLevelsDao.deletePopLevel(
        popLevel: await popLevelsDao.getPopLevel(
          id: popLevelId,
        ),
      );
    }
    final stopGameId = command.stopGameId;
    if (stopGameId != null) {
      final stopGamesDao = db.stopGamesDao;
      await stopGamesDao.deleteStopGame(
        stopGame: await stopGamesDao.getStopGame(
          id: stopGameId,
        ),
      );
    }
    final messageSoundId = command.messageSoundId;
    if (messageSoundId != null) {
      final assetReferencesDao = db.assetReferencesDao;
      await assetReferencesDao.deleteAssetReference(
        assetReference: await assetReferencesDao.getAssetReference(
          id: messageSoundId,
        ),
      );
    }
    await commandsDao.deleteCommand(command: command);
  }

  /// Delete the given [menuItem] and all associated rows.
  Future<void> deleteMenuItem(final MenuItem menuItem) async {
    final assetReferencesDao = db.assetReferencesDao;
    for (final id in [menuItem.activateSoundId, menuItem.selectSoundId]) {
      if (id != null) {
        await assetReferencesDao.deleteAssetReference(
          assetReference: await assetReferencesDao.getAssetReference(
            id: id,
          ),
        );
      }
    }
    await db.menuItemsDao.deleteMenuItem(menuItem: menuItem);
  }

  /// Delete the given [menu] and all related [MenuItem]s.
  Future<void> deleteMenu(final Menu menu) async {
    (await db.menuItemsDao.getMenuItems(menu: menu)).forEach(deleteMenuItem);
    final assetReferencesDao = db.assetReferencesDao;
    for (final id in [
      menu.activateItemSoundId,
      menu.musicId,
      menu.selectItemSoundId
    ]) {
      if (id != null) {
        await assetReferencesDao.deleteAssetReference(
          assetReference: await assetReferencesDao.getAssetReference(
            id: id,
          ),
        );
      }
    }
    await db.menusDao.deleteMenu(menu: menu);
  }

  /// Delete the given [customLevel], and all associated rows.
  Future<void> deleteCustomLevel(final CustomLevel customLevel) async {
    final assetReferencesDao = db.assetReferencesDao;
    for (final id in [customLevel.musicId]) {
      if (id != null) {
        await assetReferencesDao.deleteAssetReference(
          assetReference: await assetReferencesDao.getAssetReference(
            id: id,
          ),
        );
      }
    }
    await db.customLevelsDao.deleteCustomLevel(customLevel: customLevel);
  }
}
