import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../custom_database.dart';

void main() {
  group(
    'CommandsDao',
    () {
      final db = getDatabase();
      final commands = db.commandsDao;
      final menus = db.menusDao;
      final pushMenus = db.pushMenusDao;

      test(
        '.createCommand',
        () async {
          final command = await commands.createCommand();
          expect(command.callCommandId, null);
          expect(command.id, isNonZero);
          expect(command.messageSoundId, null);
          expect(command.messageText, null);
          expect(command.popLevelId, null);
          expect(command.pushMenuId, null);
        },
      );

      test(
        '.getCommand',
        () async {
          final command1 = await commands.createCommand();
          expect(
            (await commands.getCommand(id: command1.id)).id,
            command1.id,
          );
          final command2 = await commands.createCommand();
          expect(
            await commands.getCommand(id: command2.id),
            predicate<Command>(
              (final value) =>
                  value.id == command2.id && value.id != command1.id,
            ),
          );
        },
      );

      test(
        '.setPushMenu',
        () async {
          final menu = await menus.createMenu(name: 'Test Menu');
          final pushMenu = await pushMenus.createPushMenu(menuId: menu.id);
          final initialCommand = await commands.createCommand();
          final command = await commands.setPushMenu(
            commandId: initialCommand.id,
            pushMenuId: pushMenu.id,
          );
          expect(command.id, initialCommand.id);
          expect(command.pushMenuId, pushMenu.id);
        },
      );
    },
  );
}
