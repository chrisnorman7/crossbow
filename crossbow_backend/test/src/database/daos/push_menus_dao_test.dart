import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'PushMenusDao',
    () {
      final db = getDatabase();
      final menusDao = db.menusDao;
      final pushMenusDao = db.pushMenusDao;
      final commands = db.commandsDao;

      test(
        '.createPushMenu',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenusDao.createPushMenu(menu: menu);
          expect(pushMenu.after, null);
          expect(pushMenu.fadeLength, null);
          expect(pushMenu.id, isNonZero);
          expect(pushMenu.menuId, menu.id);
        },
      );

      test(
        '.getPushMenu',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenusDao.createPushMenu(menu: menu);
          expect(
            (await pushMenusDao.getPushMenu(id: pushMenu.id)).id,
            pushMenu.id,
          );
        },
      );

      test(
        '.deletePushMenu',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          var pushMenu = await pushMenusDao.createPushMenu(menu: menu);
          expect(await pushMenusDao.deletePushMenu(pushMenu: pushMenu), 1);
          pushMenu = await pushMenusDao.createPushMenu(menu: menu);
          final command = await commands.setPushMenuId(
            command: await commands.createCommand(),
            pushMenu: pushMenu,
          );
          expect(command.pushMenuId, pushMenu.id);
          await pushMenusDao.deletePushMenu(pushMenu: pushMenu);
          expect((await commands.getCommand(id: command.id)).pushMenuId, null);
        },
      );

      test(
        '.setMenuId',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenusDao.createPushMenu(menu: menu);
          expect(pushMenu.menuId, menu.id);
          final menu2 = await menusDao.createMenu(name: 'Other Menu');
          var updatedPushMenu = await pushMenusDao.setMenu(
            pushMenu: pushMenu,
            menu: menu2,
          );
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.menuId, menu2.id);
          updatedPushMenu = await pushMenusDao.setMenu(
            pushMenu: pushMenu,
            menu: menu,
          );
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.menuId, menu.id);
        },
      );

      test(
        '.setAfter',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final pushMenu =
              await pushMenusDao.createPushMenu(menu: menu, after: 1234);
          expect(pushMenu.menuId, menu.id);
          expect(pushMenu.after, 1234);
          var updatedPushMenu = await pushMenusDao.setAfter(pushMenu: pushMenu);
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.after, null);
          updatedPushMenu =
              await pushMenusDao.setAfter(pushMenu: pushMenu, after: 4321);
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.after, 4321);
        },
      );

      test(
        '.setFadeLength',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenusDao.createPushMenu(
            menu: menu,
            fadeLength: 5.0,
          );
          expect(pushMenu.menuId, menu.id);
          expect(pushMenu.fadeLength, 5.0);
          var updatedPushMenu = await pushMenusDao.setFadeLength(
            pushMenu: pushMenu,
          );
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.fadeLength, null);
          updatedPushMenu = await pushMenusDao.setFadeLength(
            pushMenu: pushMenu,
            fadeLength: 2.0,
          );
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.fadeLength, 2.0);
        },
      );

      test(
        '.setVariableName',
        () async {
          final menu = await menusDao.createMenu(name: 'Something');
          final pushMenu = await pushMenusDao.createPushMenu(menu: menu);
          expect(pushMenu.variableName, null);
          final updatedPushMenu = await pushMenusDao.setVariableName(
            pushMenu: pushMenu,
            variableName: 'pushMenu',
          );
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.variableName, 'pushMenu');
        },
      );

      test(
        '.getPushMenus',
        () async {
          await db.delete(db.pushMenus).go();
          final menu = await menusDao.createMenu(name: 'Test Menu');
          expect(await pushMenusDao.getPushMenus(), isEmpty);
          final pushMenus = [
            for (var i = 0; i < 10; i++)
              await pushMenusDao.createPushMenu(menu: menu)
          ];
          expect(await pushMenusDao.getPushMenus(), pushMenus);
        },
      );
    },
  );
}
