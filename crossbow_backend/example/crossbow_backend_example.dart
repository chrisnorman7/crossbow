// ignore_for_file: avoid_print
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';

Future<void> main() async {
  final projectContext =
      await ProjectContext.blank(projectFile: File('project.json'));
  final db = projectContext.db;
  final menus = db.menusDao;
  final menu = await menus.createMenu(name: 'Main Menu');
  await menus.createMenuItem(menuId: menu.id, name: 'Play Game');
  final stopGame = await db.stopGamesDao.createStopGame(after: 3000);
  final popLevel = await db.popLevelsDao.createPopLevel(fadeLength: 3.0);
  final command = await db.commandsDao.setPopLevel(
    commandID: (await db.commandsDao.setMessageText(
      commandId: (await db.commandsDao.setStopGame(
        commandId: (await db.commandsDao.createCommand()).id,
        stopGameId: stopGame.id,
      ))
          .id,
      text: 'The game will now close.',
    ))
        .id,
    popLevelId: popLevel.id,
  );
  await menus.setCallCommand(
    menuItemId: (await menus.createMenuItem(
      menuId: menu.id,
      name: 'Quit Game',
      position: 1,
    ))
        .id,
    callCommandId: (await db.callCommandsDao.createCallCommand(
      commandId: command.id,
    ))
        .id,
  );
  final commands = db.commandsDao;
  await commands.setMessageText(
    commandId: projectContext.project.initialCommandId,
  );
  final pushMenu = await db.pushMenusDao.createPushMenu(menuId: menu.id);
  await commands.setPushMenu(
    commandId: projectContext.project.initialCommandId,
    pushMenuId: pushMenu.id,
  );
  await projectContext.run();
}
