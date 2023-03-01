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
      final pushMenusDao = db.pushMenusDao;
      final commandsDao = db.commandsDao;
      final callCommandsDao = db.callCommandsDao;
      final utilsDao = db.utilsDao;
      final commandTriggersDao = db.commandTriggersDao;

      test(
        '.deleteCommand',
        () async {
          final assetReference =
              await db.assetReferencesDao.createAssetReference(
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
            db.assetReferencesDao.getAssetReference(id: assetReference.id),
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
            await commandsDao.getCommand(id: command2.id),
            predicate<Command>((final value) => value.id == command2.id),
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
    },
  );
}
