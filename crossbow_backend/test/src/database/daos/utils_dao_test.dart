import 'package:crossbow_backend/crossbow_backend.dart';
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
      final commandTriggerKeyboardKeysDao = db.commandTriggerKeyboardKeysDao;
      final commandTriggersDao = db.commandTriggersDao;
      final assetReferencesDao = db.assetReferencesDao;
      final popLevelsDao = db.popLevelsDao;
      final pinnedCommandsDao = db.pinnedCommandsDao;

      test(
        '.deleteAssetReference',
        () async {
          final assetReference = await assetReferencesDao.createAssetReference(
            folderName: 'test',
            name: 'test.mp3',
          );
          await utilsDao.deleteAssetReference(assetReference);
          expect(
            assetReferencesDao.getAssetReference(id: assetReference.id),
            throwsStateError,
          );
        },
      );

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
        '.deleteCommandTriggerKeyboardKey',
        () async {
          final key = await commandTriggerKeyboardKeysDao
              .createCommandTriggerKeyboardKey(scanCode: ScanCode.delete);
          await utilsDao.deleteCommandTriggerKeyboardKey(key);
          expect(
            commandTriggerKeyboardKeysDao.getCommandTriggerKeyboardKey(
              id: key.id,
            ),
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
          await utilsDao.deleteCommand(command);
          expect(commandsDao.getCommand(id: command.id), throwsStateError);
          expect(
            assetReferencesDao.getAssetReference(id: assetReference.id),
            throwsStateError,
          );
          expect(
            db.popLevelsDao.getPopLevel(id: popLevel.id),
            throwsStateError,
          );
          expect(pushMenusDao.getPushMenu(id: pushMenu.id), throwsStateError);
          expect(
            db.stopGamesDao.getStopGame(id: stopGame.id),
            throwsStateError,
          );
          expect(
            db.callCommandsDao.getCallCommand(id: callCommand.id),
            throwsStateError,
          );
          expect(
            commandsDao.getCommand(id: command2.id),
            throwsStateError,
          );
        },
      );

      test(
        '.deleteCallCommand',
        () async {
          final commandToCall = await commandsDao.createCommand();
          final command = await commandsDao.createCommand();
          final callCommand = await callCommandsDao.createCallCommand(
            commandId: commandToCall.id,
            callingCommandId: command.id,
          );
          await utilsDao.deleteCallCommand(callCommand);
          expect(
            commandsDao.getCommand(id: commandToCall.id),
            throwsStateError,
          );
          expect(
            callCommandsDao.getCallCommand(id: callCommand.id),
            throwsStateError,
          );
          expect(
            await commandsDao.getCommand(id: command.id),
            predicate<Command>((final value) => value.id == command.id),
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
          expect(
            assetReferencesDao.getAssetReference(id: mistakeActivateSound.id),
            throwsStateError,
          );
          expect(
            assetReferencesDao.getAssetReference(id: mistakeSelectSound.id),
            throwsStateError,
          );
          expect(menuItemsDao.getMenuItem(id: mistake.id), throwsStateError);
          expect(
            (await assetReferencesDao.getAssetReference(id: activateSound.id))
                .id,
            activateSound.id,
          );
          expect(
            (await assetReferencesDao.getAssetReference(id: selectSound.id)).id,
            selectSound.id,
          );
          expect(
            (await assetReferencesDao.getAssetReference(id: music.id)).id,
            music.id,
          );
          expect(
            callCommandsDao.getCallCommand(id: callCommand1.id),
            throwsStateError,
          );
          expect(
            callCommandsDao.getCallCommand(id: callCommand2.id),
            throwsStateError,
          );
          expect(commandsDao.getCommand(id: command1.id), throwsStateError);
          expect(commandsDao.getCommand(id: command2.id), throwsStateError);
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
          expect(
            menuItemsDao.getMenuItem(id: menuItem1.id),
            throwsStateError,
          );
          expect(
            menuItemsDao.getMenuItem(id: menuItem2.id),
            throwsStateError,
          );
          expect(menusDao.getMenu(id: menu.id), throwsStateError);
          expect(
            assetReferencesDao.getAssetReference(id: activateSound.id),
            throwsStateError,
          );
          expect(
            assetReferencesDao.getAssetReference(id: selectSound.id),
            throwsStateError,
          );
          expect(
            assetReferencesDao.getAssetReference(id: music.id),
            throwsStateError,
          );
          expect(
            callCommandsDao.getCallCommand(id: callCommand1.id),
            throwsStateError,
          );
          expect(
            callCommandsDao.getCallCommand(id: callCommand2.id),
            throwsStateError,
          );
          expect(commandsDao.getCommand(id: command1.id), throwsStateError);
          expect(commandsDao.getCommand(id: command2.id), throwsStateError);
        },
      );

      test(
        '.deletePopLevel',
        () async {
          final popLevel = await popLevelsDao.createPopLevel();
          final command =
              await commandsDao.createCommand(popLevelId: popLevel.id);
          await utilsDao.deletePopLevel(popLevel);
          expect(popLevelsDao.getPopLevel(id: popLevel.id), throwsStateError);
          final updatedCommand = await commandsDao.getCommand(id: command.id);
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.popLevelId, null);
        },
      );

      test(
        '.deletePushMenu',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenusDao.createPushMenu(menuId: menu.id);
          final command =
              await commandsDao.createCommand(pushMenuId: pushMenu.id);
          await utilsDao.deletePushMenu(pushMenu);
          expect(pushMenusDao.getPushMenu(id: pushMenu.id), throwsStateError);
          expect((await menusDao.getMenu(id: menu.id)).id, menu.id);
          expect((await commandsDao.getCommand(id: command.id)).id, command.id);
        },
      );

      test(
        '.deletePinnedCommand',
        () async {
          final command = await commandsDao.createCommand();
          final pinnedCommand = await pinnedCommandsDao.createPinnedCommand(
            commandId: command.id,
            name: 'Test',
          );
          await utilsDao.deletePinnedCommand(pinnedCommand);
          expect(
            pinnedCommandsDao.getPinnedCommand(id: pinnedCommand.id),
            throwsStateError,
          );
          expect(
            await commandsDao.getCommand(id: command.id),
            predicate<Command>((final value) => value.id == command.id),
          );
        },
      );
    },
  );
}
