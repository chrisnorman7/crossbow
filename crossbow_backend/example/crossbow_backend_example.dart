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
  await menus.createMenuItem(menuId: menu.id, name: 'Quit Game');
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
