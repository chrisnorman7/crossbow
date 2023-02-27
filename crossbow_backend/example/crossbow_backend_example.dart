// ignore_for_file: avoid_print
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';

Future<void> main() async {
  final projectContext =
      await ProjectContext.blank(projectFile: File('project.json'));
  final db = projectContext.db;
  final menusDao = db.menusDao;
  final menuItemsDao = db.menuItemsDao;
  final menu = await menusDao.createMenu(name: 'Main Menu');
  final commands = db.commandsDao;
  final openGitHubCommand = await commands.createCommand(
    messageText: 'Opening GitHub...',
    url: 'https://github.com/chrisnorman7/crossbow.git',
  );
  final openGitHubCallCommand = await db.callCommandsDao
      .createCallCommand(commandId: openGitHubCommand.id);
  await menuItemsDao.createMenuItem(
    menuId: menu.id,
    name: 'Open GitHub',
    callCommandId: openGitHubCallCommand.id,
  );
  final stopGame = await db.stopGamesDao.createStopGame(after: 3000);
  final popLevel = await db.popLevelsDao.createPopLevel(fadeLength: 3.0);
  final quitCommand = await commands.createCommand(
    messageText: 'The game will now close.',
    popLevelId: popLevel.id,
    stopGameId: stopGame.id,
  );
  final quitCallCommand =
      await db.callCommandsDao.createCallCommand(commandId: quitCommand.id);
  await menuItemsDao.createMenuItem(
    menuId: menu.id,
    name: 'Quit Game',
    callCommandId: quitCallCommand.id,
  );
  final pushMenu =
      await db.pushMenusDao.createPushMenu(menuId: menu.id, after: 2000);
  await commands.setMessageText(
    commandId: projectContext.project.initialCommandId,
    text: 'Welcome to the crossbow example.',
  );
  await commands.setPushMenuId(
    commandId: projectContext.project.initialCommandId,
    pushMenuId: pushMenu.id,
  );
  await projectContext.run();
}
