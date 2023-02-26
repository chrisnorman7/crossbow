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
            await menuItemsDao.createMenuItem(menuId: menu.id, name: 'Play'),
            await menuItemsDao.createMenuItem(
              menuId: menu.id,
              name: 'Quit',
              position: 1,
            ),
          ];
          await menusDao.deleteMenu(id: menu.id);
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
              await menusDao.setName(menuId: menu.id, name: 'Main Menu');
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
            activateItemSoundId: assetReference.id,
          );
          expect(menu.activateItemSoundId, assetReference.id);
          var updatedMenu =
              await menusDao.setActivateItemSoundId(menuId: menu.id);
          expect(updatedMenu.id, menu.id);
          expect(updatedMenu.activateItemSoundId, null);
          updatedMenu = await menusDao.setActivateItemSoundId(
            menuId: menu.id,
            activateItemSoundId: assetReference.id,
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
            selectItemSoundId: assetReference.id,
          );
          expect(menu.selectItemSoundId, assetReference.id);
          var updatedMenu =
              await menusDao.setSelectItemSoundId(menuId: menu.id);
          expect(updatedMenu.id, menu.id);
          expect(updatedMenu.selectItemSoundId, null);
          updatedMenu = await menusDao.setSelectItemSoundId(
            menuId: menu.id,
            selectItemSoundId: assetReference.id,
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
              commandId: command.id,
              onCancelMenuId: menu.id,
            ),
            await db.callCommandsDao.createCallCommand(
              commandId: command.id,
              onCancelMenuId: menu.id,
            ),
          ];
          final queryCallCommands =
              await menusDao.getOnCancelCallCommands(menuId: menu.id);
          expect(queryCallCommands.length, createdCallCommands.length);
          for (var i = 0; i < createdCallCommands.length; i++) {
            expect(createdCallCommands[i].id, queryCallCommands[i].id);
          }
        },
      );
    },
  );
}
