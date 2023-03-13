import 'package:dart_sdl/dart_sdl.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'UtilsDao',
    () {
      final db = getDatabase();
      final menusDao = db.menusDao;
      final menuItemsDao = db.menuItemsDao;
      final pushMenusDao = db.pushMenusDao;
      final commandsDao = db.commandsDao;
      final callCommandsDao = db.callCommandsDao;
      final utilsDao = db.utilsDao;
      final commandTriggersDao = db.commandTriggersDao;
      final assetReferencesDao = db.assetReferencesDao;
      final pinnedCommandsDao = db.pinnedCommandsDao;
      final customLevelsDao = db.customLevelsDao;
      final customLevelCommandsDao = db.customLevelCommandsDao;

      test(
        '.deleteCommandTrigger',
        () async {
          final keyboardKey = await db.commandTriggerKeyboardKeysDao
              .createCommandTriggerKeyboardKey(
            scanCode: ScanCode.d,
          );
          final trigger = await commandTriggersDao.createCommandTrigger(
            description: 'Test trigger',
            keyboardKeyId: keyboardKey.id,
          );
          await utilsDao.deleteCommandTrigger(trigger);
          expect(
            db.commandTriggerKeyboardKeysDao
                .getCommandTriggerKeyboardKey(id: keyboardKey.id),
            throwsStateError,
          );
          expect(
            commandTriggersDao.getCommandTrigger(id: trigger.id),
            throwsStateError,
          );
        },
      );

      test(
        '.deleteCommand',
        () async {
          final assetReference = await assetReferencesDao.createAssetReference(
            folderName: 'folder',
            name: 'file',
          );
          final popLevel = await db.popLevelsDao.createPopLevel();
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenusDao.createPushMenu(menuId: menu.id);
          final stopGame = await db.stopGamesDao.createStopGame();
          final command = await commandsDao.createCommand(
            messageSoundId: assetReference.id,
            popLevelId: popLevel.id,
            pushMenuId: pushMenu.id,
            stopGameId: stopGame.id,
          );
          final command2 = await commandsDao.createCommand();
          final callCommand = await callCommandsDao.createCallCommand(
            commandId: command2.id,
            callingCommandId: command.id,
          );
          final pinnedCommand = await pinnedCommandsDao.createPinnedCommand(
            commandId: command.id,
            name: 'Cannot delete me',
          );
          await expectLater(utilsDao.deleteCommand(command), throwsStateError);
          await pinnedCommandsDao.deletePinnedCommand(
            pinnedCommandId: pinnedCommand.id,
          );
          await utilsDao.deleteCommand(command);
          expect(commandsDao.getCommand(id: command.id), throwsStateError);
          await expectLater(
            assetReferencesDao.getAssetReference(id: assetReference.id),
            throwsStateError,
          );
          await expectLater(
            db.popLevelsDao.getPopLevel(id: popLevel.id),
            throwsStateError,
          );
          await expectLater(
            pushMenusDao.getPushMenu(id: pushMenu.id),
            throwsStateError,
          );
          await expectLater(
            db.stopGamesDao.getStopGame(id: stopGame.id),
            throwsStateError,
          );
          await expectLater(
            db.callCommandsDao.getCallCommand(id: callCommand.id),
            throwsStateError,
          );
          expect(
            (await commandsDao.getCommand(id: command2.id)).id,
            command2.id,
          );
        },
      );

      test(
        '.deleteMenuItem',
        () async {
          final music = await assetReferencesDao.createAssetReference(
            folderName: 'music',
            name: 'main_theme.mp3',
          );
          final activateSound = await assetReferencesDao.createAssetReference(
            folderName: 'menus',
            name: 'activate.mp3',
          );
          final selectSound = await assetReferencesDao.createAssetReference(
            folderName: 'menus',
            name: 'select.mp3',
          );
          final menu = await menusDao.createMenu(
            name: 'Test Menu',
            musicId: music.id,
            activateItemSoundId: activateSound.id,
            selectItemSoundId: selectSound.id,
          );
          final play = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Play',
          );
          final mistakeActivateSound =
              await assetReferencesDao.createAssetReference(
            folderName: 'menus',
            name: 'mistake_activate.mp3',
          );
          final mistakeSelectSound =
              await assetReferencesDao.createAssetReference(
            folderName: 'menus',
            name: 'mistake_select.mp3',
          );
          final mistake = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Mistake',
            activateSoundId: mistakeActivateSound.id,
            selectSoundId: mistakeSelectSound.id,
          );
          final command1 = await commandsDao.createCommand();
          final command2 = await commandsDao.createCommand();
          final callCommand1 = await callCommandsDao.createCallCommand(
            commandId: command1.id,
            callingMenuItemId: mistake.id,
          );
          final callCommand2 = await callCommandsDao.createCallCommand(
            commandId: command2.id,
            callingMenuItemId: mistake.id,
          );
          await utilsDao.deleteMenuItem(mistake);
          await expectLater(
            assetReferencesDao.getAssetReference(id: mistakeActivateSound.id),
            throwsStateError,
          );
          await expectLater(
            assetReferencesDao.getAssetReference(id: mistakeSelectSound.id),
            throwsStateError,
          );
          await expectLater(
            menuItemsDao.getMenuItem(id: mistake.id),
            throwsStateError,
          );
          await expectLater(
            (await assetReferencesDao.getAssetReference(id: activateSound.id))
                .id,
            activateSound.id,
          );
          await expectLater(
            (await assetReferencesDao.getAssetReference(id: selectSound.id)).id,
            selectSound.id,
          );
          await expectLater(
            (await assetReferencesDao.getAssetReference(id: music.id)).id,
            music.id,
          );
          await expectLater(
            callCommandsDao.getCallCommand(id: callCommand1.id),
            throwsStateError,
          );
          await expectLater(
            callCommandsDao.getCallCommand(id: callCommand2.id),
            throwsStateError,
          );
          expect(
            (await commandsDao.getCommand(id: command1.id)).id,
            command1.id,
          );
          expect(
            (await commandsDao.getCommand(id: command2.id)).id,
            command2.id,
          );
          expect((await menuItemsDao.getMenuItem(id: play.id)).id, play.id);
          expect((await menusDao.getMenu(id: menu.id)).id, menu.id);
        },
      );

      test(
        '.deleteMenu',
        () async {
          final music = await assetReferencesDao.createAssetReference(
            folderName: 'music',
            name: 'main_theme.mp3',
          );
          final activateSound = await assetReferencesDao.createAssetReference(
            folderName: 'menus',
            name: 'activate.mp3',
          );
          final selectSound = await assetReferencesDao.createAssetReference(
            folderName: 'menus',
            name: 'select.mp3',
          );
          final menu = await menusDao.createMenu(
            name: 'Test Menu',
            musicId: music.id,
            activateItemSoundId: activateSound.id,
            selectItemSoundId: selectSound.id,
          );
          final command1 = await commandsDao.createCommand();
          final command2 = await commandsDao.createCommand();
          final callCommand1 = await callCommandsDao.createCallCommand(
            commandId: command1.id,
            onCancelMenuId: menu.id,
          );
          final callCommand2 = await callCommandsDao.createCallCommand(
            commandId: command2.id,
            onCancelMenuId: menu.id,
          );
          final menuItem1 = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Menu Item 1',
          );
          final menuItem2 = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Menu Item 2',
          );
          await utilsDao.deleteMenu(menu);
          await expectLater(
            menuItemsDao.getMenuItem(id: menuItem1.id),
            throwsStateError,
          );
          await expectLater(
            menuItemsDao.getMenuItem(id: menuItem2.id),
            throwsStateError,
          );
          await expectLater(menusDao.getMenu(id: menu.id), throwsStateError);
          await expectLater(
            assetReferencesDao.getAssetReference(id: activateSound.id),
            throwsStateError,
          );
          await expectLater(
            assetReferencesDao.getAssetReference(id: selectSound.id),
            throwsStateError,
          );
          await expectLater(
            assetReferencesDao.getAssetReference(id: music.id),
            throwsStateError,
          );
          await expectLater(
            callCommandsDao.getCallCommand(id: callCommand1.id),
            throwsStateError,
          );
          await expectLater(
            callCommandsDao.getCallCommand(id: callCommand2.id),
            throwsStateError,
          );
          expect(
            (await commandsDao.getCommand(id: command1.id)).id,
            command1.id,
          );
          expect(
            (await commandsDao.getCommand(id: command2.id)).id,
            command2.id,
          );
        },
      );

      test(
        '.deleteCustomLevel',
        () async {
          final trigger = await commandTriggersDao.createCommandTrigger(
            description: 'Test',
          );
          final music = await assetReferencesDao.createAssetReference(
            folderName: 'music',
            name: 'custom_level.mp3',
          );
          final level = await customLevelsDao.createCustomLevel(
            name: 'Test Level',
            musicId: music.id,
          );
          final customLevelCommand =
              await customLevelCommandsDao.createCustomLevelCommand(
            customLevelId: level.id,
            commandTriggerId: trigger.id,
          );
          final command = await commandsDao.createCommand();
          final callCommand = await callCommandsDao.createCallCommand(
            commandId: command.id,
            callingCustomLevelCommandId: customLevelCommand.id,
          );
          await utilsDao.deleteCustomLevel(level);
          await expectLater(
            callCommandsDao.getCallCommand(id: callCommand.id),
            throwsStateError,
          );
          await expectLater(
            assetReferencesDao.getAssetReference(id: music.id),
            throwsStateError,
          );
          await expectLater(
            customLevelCommandsDao.getCustomLevelCommand(
              id: customLevelCommand.id,
            ),
            throwsStateError,
          );
          await expectLater(
            customLevelsDao.getCustomLevel(id: level.id),
            throwsStateError,
          );
          expect((await commandsDao.getCommand(id: command.id)).id, command.id);
          expect(
            (await commandTriggersDao.getCommandTrigger(id: trigger.id)).id,
            trigger.id,
          );
        },
      );
    },
  );
}
