import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'CommandsDao',
    () {
      final db = getDatabase();
      final commandsDao = db.commandsDao;
      final menus = db.menusDao;
      final pushMenus = db.pushMenusDao;
      final callCommandsDao = db.callCommandsDao;
      final pinnedCommandsDao = db.pinnedCommandsDao;
      final customLevelsDao = db.customLevelsDao;
      final pushCustomLevelsDao = db.pushCustomLevelsDao;
      final dartFunctionsDao = db.dartFunctionsDao;

      test(
        '.createCommand',
        () async {
          final command = await commandsDao.createCommand();
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
          final command1 = await commandsDao.createCommand();
          expect(
            (await commandsDao.getCommand(id: command1.id)).id,
            command1.id,
          );
          final command2 = await commandsDao.createCommand();
          expect(
            await commandsDao.getCommand(id: command2.id),
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
          final pushMenu = await pushMenus.createPushMenu(menu: menu);
          final command = await commandsDao.createCommand(pushMenu: pushMenu);
          expect(command.pushMenuId, pushMenu.id);
          var updatedCommand = await commandsDao.setPushMenuId(
            command: command,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.pushMenuId, null);
          updatedCommand = await commandsDao.setPushMenuId(
            command: command,
            pushMenu: pushMenu,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.pushMenuId, pushMenu.id);
        },
      );

      test(
        '.deleteCommand',
        () async {
          var command = await commandsDao.createCommand();
          final menu = await menus.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenus.createPushMenu(menu: menu);
          command = await commandsDao.setPushMenuId(
            command: command,
            pushMenu: pushMenu,
          );
          final callingCommand = await commandsDao.createCommand();
          final callCommand = await callCommandsDao.createCallCommand(
            command: command,
            callingCommand: callingCommand,
          );
          expect(await commandsDao.deleteCommand(command: command), 1);
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
          final command = await commandsDao.createCommand();
          expect(command.messageText, null);
          const string = 'Hello world.';
          final updatedCommand = await commandsDao.setMessageText(
            command: command,
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
          final command = await commandsDao.createCommand(
            messageSound: assetReference,
          );
          expect(command.messageSoundId, assetReference.id);
          var updatedCommand =
              await commandsDao.setMessageSoundId(command: command);
          expect(updatedCommand.messageSoundId, null);
          updatedCommand = await commandsDao.setMessageSoundId(
            command: command,
            assetReference: assetReference,
          );
          expect(updatedCommand.messageSoundId, assetReference.id);
        },
      );

      test(
        '.setStopGameId',
        () async {
          final stopGame = await db.stopGamesDao.createStopGame();
          final command = await commandsDao.createCommand(stopGame: stopGame);
          expect(command.stopGameId, stopGame.id);
          var updatedCommand = await commandsDao.setStopGameId(
            command: command,
          );
          expect(updatedCommand.stopGameId, null);
          updatedCommand = await commandsDao.setStopGameId(
            command: command,
            stopGame: stopGame,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.stopGameId, stopGame.id);
        },
      );

      test(
        '.setPopLevelId',
        () async {
          final popLevel = await db.popLevelsDao.createPopLevel();
          final command = await commandsDao.createCommand(popLevel: popLevel);
          expect(command.popLevelId, popLevel.id);
          var updatedCommand = await commandsDao.setPopLevelId(
            command: command,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.popLevelId, null);
          updatedCommand = await commandsDao.setPopLevelId(
            command: command,
            popLevel: popLevel,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.popLevelId, popLevel.id);
        },
      );

      test(
        '.setUrl',
        () async {
          final command = await commandsDao.createCommand();
          expect(command.url, null);
          const url = 'https://www.github.com/chrisnorman7/';
          final updatedCommand = await commandsDao.setUrl(
            command: command,
            url: url,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.url, url);
        },
      );

      test(
        '.getCallCommands',
        () async {
          final command = await commandsDao.createCommand();
          final menu = await menus.createMenu(name: 'Test Menu');
          final menuItem = await db.menuItemsDao.createMenuItem(
            menu: menu,
            name: 'Test',
          );
          await callCommandsDao.createCallCommand(
            command: command,
            onCancelMenu: menu,
            callingMenuItem: menuItem,
          );
          expect(
            await commandsDao.getCallCommands(command: command),
            isEmpty,
          );
          final createdCallCommands = [
            await callCommandsDao.createCallCommand(
              command: command,
              callingCommand: command,
            ),
            await callCommandsDao.createCallCommand(
              command: command,
              callingCommand: command,
              after: 1234,
            ),
          ];
          final queryCallCommands = await commandsDao.getCallCommands(
            command: command,
          );
          expect(queryCallCommands.length, createdCallCommands.length);
          for (var i = 0; i < createdCallCommands.length; i++) {
            expect(createdCallCommands[i].id, queryCallCommands[i].id);
          }
        },
      );

      test(
        '.getPinnedCommand',
        () async {
          final command = await commandsDao.createCommand();
          final pinnedCommand = await pinnedCommandsDao.createPinnedCommand(
            command: command,
            name: 'Test',
          );
          final retrievedPinnedCommand =
              await commandsDao.getPinnedCommand(command: command);
          expect(retrievedPinnedCommand!.commandId, command.id);
          expect(retrievedPinnedCommand.id, pinnedCommand.id);
          expect(retrievedPinnedCommand.name, pinnedCommand.name);
          final command2 = await commandsDao.createCommand();
          expect(
            await commandsDao.getPinnedCommand(command: command2),
            null,
          );
        },
      );

      test(
        '.isPinned',
        () async {
          final command = await commandsDao.createCommand();
          final pinnedCommand = await pinnedCommandsDao.createPinnedCommand(
            command: command,
            name: 'Test',
          );
          expect(await commandsDao.isPinned(command: command), true);
          final unpinnedCommand = await commandsDao.createCommand();
          expect(
            await commandsDao.isPinned(command: unpinnedCommand),
            false,
          );
          await pinnedCommandsDao.deletePinnedCommand(
            pinnedCommand: pinnedCommand,
          );
          expect(await commandsDao.isPinned(command: command), false);
        },
      );

      test(
        '.isCalled',
        () async {
          final command = await commandsDao.createCommand();
          final callingCommand1 = await commandsDao.createCommand();
          final callingCommand2 = await commandsDao.createCommand();
          final callCommand1 = await callCommandsDao.createCallCommand(
            command: command,
            callingCommand: callingCommand1,
          );
          final callCommand2 = await callCommandsDao.createCallCommand(
            command: command,
            callingCommand: callingCommand2,
          );
          expect(await commandsDao.isCalled(command: command), isTrue);
          expect(
            await commandsDao.isCalled(command: callingCommand1),
            isFalse,
          );
          expect(
            await commandsDao.isCalled(command: callingCommand2),
            isFalse,
          );
          await callCommandsDao.deleteCallCommand(
            callCommand: callCommand1,
          );
          expect(await commandsDao.isCalled(command: command), isTrue);
          await callCommandsDao.deleteCallCommand(
            callCommand: callCommand2,
          );
          expect(await commandsDao.isCalled(command: command), isFalse);
        },
      );

      test(
        '.getCallingCallCommands',
        () async {
          final command = await commandsDao.createCommand();
          final callingCommand = await commandsDao.createCommand();
          final callCommand1 = await callCommandsDao.createCallCommand(
            command: command,
            callingCommand: callingCommand,
          );
          var callingCallCommands =
              await commandsDao.getCallingCallCommands(command: command);
          expect(callingCallCommands.length, 1);
          expect(
            callingCallCommands.single,
            predicate<CallCommand>(
              (final value) =>
                  value.id == callCommand1.id &&
                  value.callingCommandId == callingCommand.id &&
                  value.commandId == command.id,
            ),
          );
          final callingCommand2 = await commandsDao.createCommand();
          final callCommand2 = await callCommandsDao.createCallCommand(
            command: command,
            callingCommand: callingCommand2,
          );
          callingCallCommands = await commandsDao.getCallingCallCommands(
            command: command,
          );
          expect(callingCallCommands.length, 2);
          expect(callingCallCommands.first.id, callCommand1.id);
          expect(
            callingCallCommands.last,
            predicate<CallCommand>(
              (final value) =>
                  value.id == callCommand2.id &&
                  value.callingCommandId == callingCommand2.id &&
                  value.commandId == command.id,
            ),
          );
        },
      );

      test(
        '.setPushCustomLevelId',
        () async {
          final level = await customLevelsDao.createCustomLevel(
            name: 'Test Custom Level',
          );
          final pushCustomLevel =
              await pushCustomLevelsDao.createPushCustomLevel(
            customLevel: level,
          );
          final command = await commandsDao.createCommand(
            pushCustomLevel: pushCustomLevel,
          );
          expect(command.pushCustomLevelId, pushCustomLevel.id);
          var updatedCommand =
              await commandsDao.setPushCustomLevelId(command: command);
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.pushCustomLevelId, null);
          updatedCommand = await commandsDao.setPushCustomLevelId(
            command: command,
            pushCustomLevel: pushCustomLevel,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.pushCustomLevelId, pushCustomLevel.id);
        },
      );

      test(
        '.setDartFunctionId',
        () async {
          final dartFunction = await dartFunctionsDao.createDartFunction(
            description: 'Testing.',
          );
          final command = await commandsDao.createCommand(
            dartFunction: dartFunction,
          );
          expect(command.dartFunctionId, dartFunction.id);
          var updatedCommand =
              await commandsDao.setDartFunctionId(command: command);
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.dartFunctionId, null);
          updatedCommand = await commandsDao.setDartFunctionId(
            command: command,
            dartFunction: dartFunction,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.dartFunctionId, dartFunction.id);
        },
      );

      test(
        '.setVariableName',
        () async {
          final command = await commandsDao.createCommand();
          expect(command.variableName, null);
          final updatedCommand = await commandsDao.setVariableName(
            command: command,
            variableName: 'pinned',
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.variableName, 'pinned');
        },
      );

      test(
        '.getCommands',
        () async {
          final commands = await db.select(db.commands).get();
          expect(await commandsDao.getCommands(), commands);
        },
      );

      test(
        '.setDescription',
        () async {
          final command = await commandsDao.createCommand();
          expect(command.description, 'An unremarkable command.');
          final updatedCommand = await commandsDao.setDescription(
            command: command,
            description: 'Test command.',
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.description, 'Test command.');
        },
      );
    },
  );
}
