import 'package:test/test.dart';

import '../../../custom_database.dart';

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

      test(
        '.setMenuId',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenus.createPushMenu(menuId: menu.id);
          expect(pushMenu.menuId, menu.id);
          final menu2 = await menus.createMenu(name: 'Other Menu');
          var updatedPushMenu = await pushMenus.setMenuId(
            pushMenuId: pushMenu.id,
            menuId: menu2.id,
          );
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.menuId, menu2.id);
          updatedPushMenu = await pushMenus.setMenuId(
            pushMenuId: pushMenu.id,
            menuId: menu.id,
          );
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.menuId, menu.id);
        },
      );

      test(
        '.setAfter',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final pushMenu =
              await pushMenus.createPushMenu(menuId: menu.id, after: 1234);
          expect(pushMenu.menuId, menu.id);
          expect(pushMenu.after, 1234);
          var updatedPushMenu =
              await pushMenus.setAfter(pushMenuId: pushMenu.id);
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.after, null);
          updatedPushMenu =
              await pushMenus.setAfter(pushMenuId: pushMenu.id, after: 4321);
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.after, 4321);
        },
      );

      test(
        '.setFadeLength',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenus.createPushMenu(
            menuId: menu.id,
            fadeLength: 5.0,
          );
          expect(pushMenu.menuId, menu.id);
          expect(pushMenu.fadeLength, 5.0);
          var updatedPushMenu = await pushMenus.setFadeLength(
            pushMenuId: pushMenu.id,
          );
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.fadeLength, null);
          updatedPushMenu = await pushMenus.setFadeLength(
            pushMenuId: pushMenu.id,
            fadeLength: 2.0,
          );
          expect(updatedPushMenu.id, pushMenu.id);
          expect(updatedPushMenu.fadeLength, 2.0);
        },
      );
    },
  );
}
