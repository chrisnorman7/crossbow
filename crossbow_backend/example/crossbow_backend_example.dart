// ignore_for_file: avoid_print
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';

Future<void> main() async {
  final projectContext = await ProjectContext.blank(
    projectFile: File('project.json'),
  );
  final db = projectContext.db;
  final menusDao = db.menusDao;
  final menuItemsDao = db.menuItemsDao;
  final menu = await menusDao.createMenu(name: 'Main Menu');
  final commands = db.commandsDao;
  final openGitHubCommand = await commands.createCommand(
    messageText: 'Opening GitHub...',
    url: 'https://github.com/chrisnorman7/crossbow.git',
  );
  final openGitHub = await menuItemsDao.createMenuItem(
    menu: menu,
    name: 'Open GitHub',
  );
  await db.callCommandsDao.createCallCommand(
    command: openGitHubCommand,
    callingMenuItem: openGitHub,
  );
  final stopGame = await db.stopGamesDao.createStopGame(after: 3000);
  final popLevel = await db.popLevelsDao.createPopLevel(fadeLength: 3.0);
  final quitCommand = await commands.createCommand(
    messageText: 'The game will now close.',
    popLevel: popLevel,
    stopGame: stopGame,
  );
  final quit = await menuItemsDao.createMenuItem(
    menu: menu,
    name: 'Quit Game',
  );
  await db.callCommandsDao.createCallCommand(
    command: quitCommand,
    callingMenuItem: quit,
  );
  final pushMenu = await db.pushMenusDao.createPushMenu(
    menu: menu,
    after: 2000,
  );
  final initialCommand = await projectContext.initialCommand;
  await commands.setMessageText(
    command: initialCommand,
    text: 'Welcome to the crossbow example.',
  );
  await commands.setPushMenuId(
    command: initialCommand,
    pushMenu: pushMenu,
  );
  await projectContext.run();
}
