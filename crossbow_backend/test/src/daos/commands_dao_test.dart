import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../custom_database.dart';

void main() {
  group(
    'CommandsDao',
    () {
      final db = getDatabase();
      final commands = db.commandsDao;
      final menus = db.menusDao;
      final pushMenus = db.pushMenusDao;

      test(
        '.createCommand',
        () async {
          final command = await commands.createCommand();
          expect(command.callCommandId, null);
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
          final initialCommand = await commands.createCommand();
          final command = await commands.setPushMenu(
            commandId: initialCommand.id,
            pushMenuId: pushMenu.id,
          );
          expect(command.id, initialCommand.id);
          expect(command.pushMenuId, pushMenu.id);
        },
      );

      test(
        '.deleteCommand',
        () async {
          var command = await commands.createCommand();
          final menu = await menus.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenus.createPushMenu(menuId: menu.id);
          command = await commands.setPushMenu(
            commandId: command.id,
            pushMenuId: pushMenu.id,
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
        '.setStopGame',
        () async {
          final command = await commands.createCommand();
          expect(command.stopGameId, null);
          final stopGame = await db.stopGamesDao.createStopGame();
          final updatedCommand = await commands.setStopGame(
            commandId: command.id,
            stopGameId: stopGame.id,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.stopGameId, stopGame.id);
        },
      );

      test(
        '.setPopLevel',
        () async {
          final command = await commands.createCommand();
          final popLevel = await db.popLevelsDao.createPopLevel();
          final updatedCommand = await commands.setPopLevel(
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
    },
  );
}
