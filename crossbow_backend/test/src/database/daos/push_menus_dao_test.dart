import 'package:test/test.dart';

import '../../custom_database.dart';

void main() {
  group(
    'PushMenusDao',
    () {
      final db = getDatabase();
      final menus = db.menusDao;
      final pushMenus = db.pushMenusDao;
      final commands = db.commandsDao;

      test(
        '.createPushMenu',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenus.createPushMenu(menuId: menu.id);
          expect(pushMenu.after, null);
          expect(pushMenu.fadeLength, null);
          expect(pushMenu.id, isNonZero);
          expect(pushMenu.menuId, menu.id);
        },
      );

      test(
        '.getPushMenu',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenus.createPushMenu(menuId: menu.id);
          expect(
            (await pushMenus.getPushMenu(id: pushMenu.id)).id,
            pushMenu.id,
          );
        },
      );

      test(
        '.deletePushMenu',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          var pushMenu = await pushMenus.createPushMenu(menuId: menu.id);
          expect(await pushMenus.deletePushMenu(id: pushMenu.id), 1);
          pushMenu = await pushMenus.createPushMenu(menuId: menu.id);
          final command = await commands.setPushMenu(
            commandId: (await commands.createCommand()).id,
            pushMenuId: pushMenu.id,
          );
          expect(command.pushMenuId, pushMenu.id);
          await pushMenus.deletePushMenu(id: pushMenu.id);
          expect((await commands.getCommand(id: command.id)).pushMenuId, null);
        },
      );
    },
  );
}
