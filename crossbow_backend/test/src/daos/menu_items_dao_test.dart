import 'package:crossbow_backend/database.dart';
import 'package:test/test.dart';

import '../../custom_database.dart';

void main() {
  group(
    'MenuItemsDao',
    () {
      final db = getDatabase();
      final menusDao = db.menusDao;
      final menuItemsDao = db.menuItemsDao;

      test(
        '.createMenuItem',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final menuItem1 = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Menu Item 1',
          );
          expect(menuItem1.id, isNonZero);
          expect(menuItem1.name, 'Menu Item 1');
          expect(menuItem1.menuId, menu.id);
          expect(menuItem1.position, 0);
          final menuItem2 = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Menu Item 2',
            position: 1,
          );
          expect(menuItem2.id, menuItem1.id + 1);
          expect(menuItem2.name, 'Menu Item 2');
          expect(menuItem2.menuId, menu.id);
          expect(menuItem2.position, 1);
        },
      );

      test(
        '.getMenuItem',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final playMenuItem =
              await menuItemsDao.createMenuItem(menuId: menu.id, name: 'Play');
          expect(
            await menuItemsDao.getMenuItem(id: playMenuItem.id),
            predicate<MenuItem>(
              (final menuItem) =>
                  menuItem.activateSoundId == playMenuItem.activateSoundId &&
                  menuItem.id == playMenuItem.id &&
                  menuItem.menuId == menu.id &&
                  menuItem.name == playMenuItem.name &&
                  menuItem.position == playMenuItem.position &&
                  menuItem.selectSoundId == null,
            ),
          );
          final quitMenuItem = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Quit',
            position: 1,
          );
          expect(
            await menuItemsDao.getMenuItem(id: quitMenuItem.id),
            predicate<MenuItem>(
              (final menuItem) =>
                  menuItem.activateSoundId == null &&
                  menuItem.id == quitMenuItem.id &&
                  menuItem.menuId == menu.id &&
                  menuItem.name == quitMenuItem.name &&
                  menuItem.position == quitMenuItem.position &&
                  menuItem.selectSoundId == null,
            ),
          );
        },
      );

      test(
        '.getMenuItems',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final menuItem1 = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Menu Item 1',
          );
          final menuItem2 = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Menu Item 2',
          );
          final menuItem3 = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Menu Item 3',
          );
          final menuItems = [
            menuItem1,
            menuItem2,
            menuItem3,
          ];
          final discoveredMenuItems =
              await menuItemsDao.getMenuItems(menuId: menu.id);
          expect(discoveredMenuItems.length, menuItems.length);
          for (var i = 0; i < discoveredMenuItems.length; i++) {
            final realMenuItem = menuItems[i];
            final discoveredMenuItem = discoveredMenuItems[i];
            expect(realMenuItem.id, discoveredMenuItem.id);
            expect(realMenuItem.name, discoveredMenuItem.name);
          }
          await menuItemsDao.moveMenuItem(
            menuItemId: menuItem1.id,
            position: 2,
          );
          await menuItemsDao.moveMenuItem(
            menuItemId: menuItem2.id,
            position: 0,
          );
          await menuItemsDao.moveMenuItem(
            menuItemId: menuItem3.id,
            position: 1,
          );
          expect(
            Stream<int>.fromIterable(
              (await menuItemsDao.getMenuItems(menuId: menu.id))
                  .map<int>((final e) => e.id),
            ),
            emitsInOrder([
              menuItem2.id,
              menuItem3.id,
              menuItem1.id,
              emitsDone,
            ]),
          );
        },
      );

      test(
        '.moveMenuItem',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final quitMenuItem = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Quit',
          );
          await menuItemsDao.createMenuItem(menuId: menu.id, name: 'Play Game');
          var menuItem = await menuItemsDao.moveMenuItem(
            menuItemId: quitMenuItem.id,
            position: 1,
          );
          expect(menuItem.id, quitMenuItem.id);
          expect(menuItem.name, quitMenuItem.name);
          expect(menuItem.position, 1);
          menuItem = (await menuItemsDao.getMenuItems(menuId: menu.id)).last;
          expect(menuItem.id, quitMenuItem.id);
        },
      );

      test(
        '.deleteMenuItem',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final playMenuItem = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Play',
          );
          final quitMenuItem = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Quit',
            position: 1,
          );
          expect(await menuItemsDao.deleteMenuItem(id: playMenuItem.id), 1);
          final query = db.select(db.menuItems)
            ..where((final table) => table.id.equals(playMenuItem.id));
          expect(await query.getSingleOrNull(), null);
          expect(
            (await menuItemsDao.getMenuItem(id: quitMenuItem.id)).id,
            quitMenuItem.id,
          );
        },
      );

      test(
        '.setCallCommand',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final menuItem = await menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Call Command',
          );
          expect(menuItem.callCommandId, null);
          final command = await db.commandsDao.createCommand();
          final callCommand =
              await db.callCommandsDao.createCallCommand(commandId: command.id);
          final updatedMenuItem = await menuItemsDao.setCallCommand(
            menuItemId: menuItem.id,
            callCommandId: callCommand.id,
          );
          expect(updatedMenuItem.id, menuItem.id);
          expect(updatedMenuItem.callCommandId, callCommand.id);
        },
      );

      test(
        '.setName',
        () async {
          final menu = await menusDao.createMenu(name: 'Main Menu');
          final playMenuItem =
              await menuItemsDao.createMenuItem(menuId: menu.id, name: 'Play');
          final startMenuItem = await menuItemsDao.setName(
            menuItemId: playMenuItem.id,
            name: 'Start Game',
          );
          expect(startMenuItem.id, playMenuItem.id);
          expect(startMenuItem.name, 'Start Game');
        },
      );
    },
  );
}