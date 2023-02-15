import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../custom_database.dart';

void main() {
  final db = getDatabase();
  group(
    'MenusDao',
    () {
      final menus = db.menusDao;

      test(
        'createMenu',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          expect(menu.id, isNonZero);
          expect(menu.name, 'Test Menu');
        },
      );

      test(
        '.createMenuItem',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final menuItem1 = await menus.createMenuItem(
            menuId: menu.id,
            name: 'Menu Item 1',
          );
          expect(menuItem1.id, isNonZero);
          expect(menuItem1.name, 'Menu Item 1');
          expect(menuItem1.menuId, menu.id);
          expect(menuItem1.position, 0);
          final menuItem2 = await menus.createMenuItem(
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
        '.getMenu',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          expect(
            await menus.getMenu(id: menu.id),
            predicate<Menu>(
              (final value) => value.id == menu.id && value.name == menu.name,
            ),
          );
        },
      );

      test(
        '.getMenuItem',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final playMenuItem =
              await menus.createMenuItem(menuId: menu.id, name: 'Play');
          expect(
            await menus.getMenuItem(id: playMenuItem.id),
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
          final quitMenuItem = await menus.createMenuItem(
            menuId: menu.id,
            name: 'Quit',
            position: 1,
          );
          expect(
            await menus.getMenuItem(id: quitMenuItem.id),
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
          final menu = await menus.createMenu(name: 'Test Menu');
          final menuItem1 =
              await menus.createMenuItem(menuId: menu.id, name: 'Menu Item 1');
          final menuItem2 =
              await menus.createMenuItem(menuId: menu.id, name: 'Menu Item 2');
          final menuItem3 =
              await menus.createMenuItem(menuId: menu.id, name: 'Menu Item 3');
          final realMenuItems = [
            menuItem1,
            menuItem2,
            menuItem3,
          ];
          final discoveredMenuItems = await menus.getMenuItems(menuId: menu.id);
          expect(discoveredMenuItems.length, realMenuItems.length);
          for (var i = 0; i < discoveredMenuItems.length; i++) {
            final realMenuItem = realMenuItems[i];
            final discoveredMenuItem = discoveredMenuItems[i];
            expect(realMenuItem.id, discoveredMenuItem.id);
            expect(realMenuItem.name, discoveredMenuItem.name);
          }
          await menus.moveMenuItem(menuItemId: menuItem1.id, position: 2);
          await menus.moveMenuItem(menuItemId: menuItem2.id, position: 0);
          await menus.moveMenuItem(menuItemId: menuItem3.id, position: 1);
          expect(
            Stream<int>.fromIterable(
              (await menus.getMenuItems(menuId: menu.id))
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
          final menu = await menus.createMenu(name: 'Test Menu');
          final quitMenuItem = await menus.createMenuItem(
            menuId: menu.id,
            name: 'Quit',
          );
          await menus.createMenuItem(menuId: menu.id, name: 'Play Game');
          var menuItem = await menus.moveMenuItem(
            menuItemId: quitMenuItem.id,
            position: 1,
          );
          expect(menuItem.id, quitMenuItem.id);
          expect(menuItem.name, quitMenuItem.name);
          expect(menuItem.position, 1);
          menuItem = (await menus.getMenuItems(menuId: menu.id)).last;
          expect(menuItem.id, quitMenuItem.id);
        },
      );

      test(
        '.deleteMenuItem',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final playMenuItem = await menus.createMenuItem(
            menuId: menu.id,
            name: 'Play',
          );
          final quitMenuItem = await menus.createMenuItem(
            menuId: menu.id,
            name: 'Quit',
            position: 1,
          );
          expect(await menus.deleteMenuItem(id: playMenuItem.id), 1);
          final query = db.select(db.menuItems)
            ..where((final table) => table.id.equals(playMenuItem.id));
          expect(await query.getSingleOrNull(), null);
          expect(
            (await menus.getMenuItem(id: quitMenuItem.id)).id,
            quitMenuItem.id,
          );
        },
      );

      test(
        '.deleteMenu',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final menuItems = [
            await menus.createMenuItem(menuId: menu.id, name: 'Play'),
            await menus.createMenuItem(
              menuId: menu.id,
              name: 'Quit',
              position: 1,
            ),
          ];
          await menus.deleteMenu(id: menu.id);
          for (final menuItem in menuItems) {
            final query = db.select(db.menuItems)
              ..where((final table) => table.id.equals(menuItem.id));
            expect(await query.getSingleOrNull(), null);
          }
        },
      );
    },
  );
}
