import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'CommandsDao',
    () {
      final db = getDatabase();
      final commands = db.commandsDao;
      final menus = db.menusDao;
      final pushMenus = db.pushMenusDao;
      final callCommandsDao = db.callCommandsDao;

      test(
        '.createCommand',
        () async {
          final command = await commands.createCommand();
          expect(command.id, isNonZero);
          expect(command.messageSoundId, null);
          expect(command.messageText, null);
          expect(command.popLevelId, null);
          expect(command.pushMenuId, null);
          expect(command.stopGameId, null);
        },
      );

      test(
        '.getCommand',
        () async {
          final command1 = await commands.createCommand();
          expect(
            (await commands.getCommand(id: command1.id)).id,
            command1.id,
          );
          final command2 = await commands.createCommand();
          expect(
            await commands.getCommand(id: command2.id),
            predicate<Command>(
              (final value) =>
                  value.id == command2.id && value.id != command1.id,
            ),
          );
        },
      );

      test(
        '.setPushMenu',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenus.createPushMenu(menuId: menu.id);
          final command = await commands.createCommand(pushMenuId: pushMenu.id);
          expect(command.pushMenuId, pushMenu.id);
          var updatedCommand =
              await commands.setPushMenuId(commandId: command.id);
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.pushMenuId, null);
          updatedCommand = await commands.setPushMenuId(
            commandId: command.id,
            pushMenuId: pushMenu.id,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.pushMenuId, pushMenu.id);
        },
      );

      test(
        '.deleteCommand',
        () async {
          var command = await commands.createCommand();
          final menu = await menus.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenus.createPushMenu(menuId: menu.id);
          command = await commands.setPushMenuId(
            commandId: command.id,
            pushMenuId: pushMenu.id,
          );
          final callingCommand = await commands.createCommand();
          final callCommand = await callCommandsDao.createCallCommand(
            commandId: command.id,
            callingCommandId: callingCommand.id,
          );
          expect(await commands.deleteCommand(id: command.id), 1);
          expect(
            await pushMenus.getPushMenu(id: pushMenu.id),
            predicate<PushMenu>(
              (final value) =>
                  value.after == pushMenu.after &&
                  value.fadeLength == pushMenu.fadeLength &&
                  value.id == pushMenu.id &&
                  value.menuId == pushMenu.menuId,
            ),
          );
          expect(
            () => callCommandsDao.getCallCommand(id: callCommand.id),
            throwsStateError,
          );
        },
      );

      test(
        '.setMessageText',
        () async {
          final command = await commands.createCommand();
          expect(command.messageText, null);
          const string = 'Hello world.';
          final updatedCommand = await commands.setMessageText(
            commandId: command.id,
            text: string,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.messageText, string);
        },
      );

      test(
        '.setMessageSoundId',
        () async {
          final assetReference =
              await db.assetReferencesDao.createAssetReference(
            folderName: 'test',
            name: 'test',
          );
          final command = await commands.createCommand(
            messageSoundId: assetReference.id,
          );
          expect(command.messageSoundId, assetReference.id);
          var updatedCommand =
              await commands.setMessageSoundId(commandId: command.id);
          expect(updatedCommand.messageSoundId, null);
          updatedCommand = await commands.setMessageSoundId(
            commandId: command.id,
            assetReferenceId: assetReference.id,
          );
          expect(updatedCommand.messageSoundId, assetReference.id);
        },
      );

      test(
        '.setStopGameId',
        () async {
          final stopGame = await db.stopGamesDao.createStopGame();
          final command = await commands.createCommand(stopGameId: stopGame.id);
          expect(command.stopGameId, stopGame.id);
          var updatedCommand = await commands.setStopGameId(
            commandId: command.id,
          );
          expect(updatedCommand.stopGameId, null);
          updatedCommand = await commands.setStopGameId(
            commandId: command.id,
            stopGameId: stopGame.id,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.stopGameId, stopGame.id);
        },
      );

      test(
        '.setPopLevelId',
        () async {
          final popLevel = await db.popLevelsDao.createPopLevel();
          final command = await commands.createCommand(popLevelId: popLevel.id);
          expect(command.popLevelId, popLevel.id);
          var updatedCommand = await commands.setPopLevelId(
            commandID: command.id,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.popLevelId, null);
          updatedCommand = await commands.setPopLevelId(
            commandID: command.id,
            popLevelId: popLevel.id,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.popLevelId, popLevel.id);
        },
      );

      test(
        '.setUrl',
        () async {
          final command = await commands.createCommand();
          expect(command.url, null);
          const url = 'https://www.github.com/chrisnorman7/';
          final updatedCommand = await commands.setUrl(
            commandId: command.id,
            url: url,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.url, url);
        },
      );

      test(
        '.getCallCommands',
        () async {
          final command = await commands.createCommand();
          final menu = await menus.createMenu(name: 'Test Menu');
          final menuItem = await db.menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Test',
          );
          await callCommandsDao.createCallCommand(
            commandId: command.id,
            onCancelMenuId: menu.id,
            callingMenuItemId: menuItem.id,
          );
          expect(
            await commands.getCallCommands(commandId: command.id),
            isEmpty,
          );
          final createdCallCommands = [
            await callCommandsDao.createCallCommand(
              commandId: command.id,
              callingCommandId: command.id,
            ),
            await callCommandsDao.createCallCommand(
              commandId: command.id,
              callingCommandId: command.id,
              after: 1234,
            ),
          ];
          final queryCallCommands =
              await commands.getCallCommands(commandId: command.id);
          expect(queryCallCommands.length, createdCallCommands.length);
          for (var i = 0; i < createdCallCommands.length; i++) {
            expect(createdCallCommands[i].id, queryCallCommands[i].id);
          }
        },
      );
    },
  );
}
