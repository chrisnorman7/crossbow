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
          final menuItem1 =
              await menus.createMenuItem(menuId: menu.id, name: 'Menu Item 1');
          expect(menuItem1.id, isNonZero);
          expect(menuItem1.name, 'Menu Item 1');
          expect(menuItem1.menuId, menu.id);
          final menuItem2 =
              await menus.createMenuItem(menuId: menu.id, name: 'Menu Item 2');
          expect(menuItem2.id, menuItem1.id + 1);
          expect(menuItem2.name, 'Menu Item 2');
          expect(menuItem2.menuId, menu.id);
        },
      );

      test(
        '.getMenuItems',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final realMenuItems = [
            await menus.createMenuItem(menuId: menu.id, name: 'Menu Item 1'),
            await menus.createMenuItem(menuId: menu.id, name: 'Menu Item 2'),
            await menus.createMenuItem(menuId: menu.id, name: 'Menu Item 3'),
          ];
          final discoveredMenuItems = await menus.getMenuItems(menuId: menu.id);
          expect(discoveredMenuItems.length, realMenuItems.length);
          for (var i = 0; i < discoveredMenuItems.length; i++) {
            final realMenuItem = realMenuItems[i];
            final discoveredMenuItem = discoveredMenuItems[i];
            expect(realMenuItem.id, discoveredMenuItem.id);
            expect(realMenuItem.name, discoveredMenuItem.name);
          }
        },
      );
    },
  );
}
