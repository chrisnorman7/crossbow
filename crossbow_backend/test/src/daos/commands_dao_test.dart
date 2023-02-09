import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:drift/drift.dart';
import 'package:test/test.dart';

import '../../custom_database.dart';

void main() {
  group(
    'CommandsDao',
    () {
      final db = getDatabase();
      final commands = db.commandsDao;
      final menus = db.menusDao;

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
        '.clearPushMenu',
        () async {
          final command = await commands.createCommand();
          final menu = await menus.createMenu(name: 'Test Menu');
          final pushMenu = await db
              .into(db.pushMenus)
              .insertReturning(PushMenusCompanion(menuId: Value(menu.id)));
          final query = db.update(db.commands)
            ..where((final table) => table.id.equals(command.id));
          var updatedCommand = (await query.writeReturning(
            CommandsCompanion(pushMenuId: Value(pushMenu.id)),
          ))
              .single;
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.pushMenuId, pushMenu.id);
          updatedCommand = await commands.clearPushMenu(commandId: command.id);
          expect(updatedCommand.pushMenuId, null);
        },
      );
    },
  );
}
