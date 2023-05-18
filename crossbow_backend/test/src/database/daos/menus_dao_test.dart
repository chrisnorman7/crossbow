import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  final db = getDatabase();
  group(
    'MenusDao',
    () {
      final menusDao = db.menusDao;
      final menuItemsDao = db.menuItemsDao;

      test(
        'createMenu',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          expect(menu.id, isNonZero);
          expect(menu.name, 'Test Menu');
        },
      );

      test(
        '.getMenu',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          expect(
            await menusDao.getMenu(id: menu.id),
            predicate<Menu>(
              (final value) => value.id == menu.id && value.name == menu.name,
            ),
          );
        },
      );

      test(
        '.deleteMenu',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final menuItems0 = [
            await menuItemsDao.createMenuItem(menu: menu, name: 'Play'),
            await menuItemsDao.createMenuItem(
              menu: menu,
              name: 'Quit',
              position: 1,
            ),
          ];
          await menusDao.deleteMenu(menu: menu);
          for (final menuItem in menuItems0) {
            final query = db.select(db.menuItems)
              ..where((final table) => table.id.equals(menuItem.id));
            expect(await query.getSingleOrNull(), null);
          }
        },
      );

      test(
        '.setMenuName',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          final renamedMenu =
              await menusDao.setName(menu: menu, name: 'Main Menu');
          expect(renamedMenu.id, menu.id);
          expect(renamedMenu.name, 'Main Menu');
        },
      );

      test(
        '.setActivateItemSoundId',
        () async {
          final assetReference =
              await db.assetReferencesDao.createAssetReference(
            folderName: 'menus',
            name: 'activate_sound.mp3',
          );
          final menu = await menusDao.createMenu(
            name: 'Test Menu',
            activateItemSound: assetReference,
          );
          expect(menu.activateItemSoundId, assetReference.id);
          var updatedMenu = await menusDao.setActivateItemSoundId(menu: menu);
          expect(updatedMenu.id, menu.id);
          expect(updatedMenu.activateItemSoundId, null);
          updatedMenu = await menusDao.setActivateItemSoundId(
            menu: menu,
            activateItemSound: assetReference,
          );
          expect(updatedMenu.id, menu.id);
          expect(updatedMenu.activateItemSoundId, assetReference.id);
        },
      );

      test(
        '.setSelectItemSoundId',
        () async {
          final assetReference =
              await db.assetReferencesDao.createAssetReference(
            folderName: 'menus',
            name: 'activate_sound.mp3',
          );
          final menu = await menusDao.createMenu(
            name: 'Test Menu',
            selectItemSound: assetReference,
          );
          expect(menu.selectItemSoundId, assetReference.id);
          var updatedMenu = await menusDao.setSelectItemSoundId(menu: menu);
          expect(updatedMenu.id, menu.id);
          expect(updatedMenu.selectItemSoundId, null);
          updatedMenu = await menusDao.setSelectItemSoundId(
            menu: menu,
            selectItemSound: assetReference,
          );
          expect(updatedMenu.id, menu.id);
          expect(updatedMenu.selectItemSoundId, assetReference.id);
        },
      );

      test(
        '.getOnCancelCallCommands',
        () async {
          final menu = await menusDao.createMenu(name: 'Test');
          final command = await db.commandsDao.createCommand();
          final createdCallCommands = [
            await db.callCommandsDao.createCallCommand(
              command: command,
              onCancelMenu: menu,
            ),
            await db.callCommandsDao.createCallCommand(
              command: command,
              onCancelMenu: menu,
            ),
          ];
          final queryCallCommands =
              await menusDao.getOnCancelCallCommands(menu: menu);
          expect(queryCallCommands.length, createdCallCommands.length);
          for (var i = 0; i < createdCallCommands.length; i++) {
            expect(createdCallCommands[i].id, queryCallCommands[i].id);
          }
        },
      );

      test(
        '.getMenus',
        () async {
          await menusDao.delete(menusDao.menus).go();
          final playMenu = await menusDao.createMenu(name: 'Play Menu');
          final pauseMenu = await menusDao.createMenu(name: 'Pause Menu');
          final assetsMenu = await menusDao.createMenu(name: 'Assets Menu');
          final menus = await menusDao.getMenus();
          expect(menus.length, 3);
          final orderedMenus = [assetsMenu, pauseMenu, playMenu];
          for (var i = 0; i < menus.length; i++) {
            final originalMenu = orderedMenus[i];
            final retrievedMenu = menus[i];
            expect(originalMenu.name, retrievedMenu.name);
            expect(originalMenu.id, retrievedMenu.id);
          }
        },
      );

      test(
        '.setVariableName',
        () async {
          final menu = await menusDao.createMenu(name: 'Test Menu');
          expect(menu.variableName, null);
          final updatedMenu = await menusDao.setVariableName(
            menu: menu,
            variableName: 'testMenu',
          );
          expect(updatedMenu.id, menu.id);
          expect(updatedMenu.variableName, 'testMenu');
        },
      );
    },
  );
}
