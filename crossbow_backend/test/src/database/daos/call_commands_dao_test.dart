import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'CallCommandsDao',
    () {
      final db = getDatabase();
      final commands = db.commandsDao;
      final callCommands = db.callCommandsDao;

      test(
        '.createCallCommand',
        () async {
          final command = await commands.createCommand();
          await expectLater(
            () => callCommands.createCallCommand(commandId: command.id),
            throwsStateError,
          );
          final menu = await db.menusDao.createMenu(name: 'Test Menu');
          final menuItem = await db.menuItemsDao.createMenuItem(
            menuId: menu.id,
            name: 'Test',
          );
          var callCommand = await callCommands.createCallCommand(
            commandId: command.id,
            callingCommandId: command.id,
            onCancelMenuId: menu.id,
            callingMenuItemId: menuItem.id,
          );
          expect(callCommand.after, null);
          expect(callCommand.commandId, command.id);
          expect(callCommand.callingCommandId, command.id);
          expect(callCommand.callingMenuItemId, menuItem.id);
          expect(callCommand.onCancelMenuId, menu.id);
          callCommand = await callCommands.createCallCommand(
            commandId: command.id,
            after: 1234,
            callingCommandId: command.id,
            callingMenuItemId: menuItem.id,
            onCancelMenuId: menu.id,
          );
          expect(callCommand.after, 1234);
          expect(callCommand.commandId, command.id);
          expect(callCommand.callingCommandId, command.id);
          expect(callCommand.callingMenuItemId, menuItem.id);
          expect(callCommand.onCancelMenuId, menu.id);
        },
      );

      test(
        '.getCallCommand',
        () async {
          final command = await commands.createCommand();
          final callCommand = await callCommands.createCallCommand(
            commandId: command.id,
            callingCommandId: command.id,
          );
          expect(
            await callCommands.getCallCommand(id: callCommand.id),
            predicate<CallCommand>(
              (final value) => value.id == callCommand.id,
            ),
          );
        },
      );

      test(
        '.setRandomNumberBase',
        () async {
          final command = await commands.createCommand();
          final callCommand = await callCommands.createCallCommand(
            commandId: command.id,
            callingCommandId: command.id,
            randomNumberBase: 5,
          );
          expect(callCommand.randomNumberBase, 5);
          var updatedCallCommand = await callCommands.setRandomNumberBase(
            callCommandId: callCommand.id,
          );
          expect(updatedCallCommand.id, callCommand.id);
          expect(updatedCallCommand.randomNumberBase, null);
          updatedCallCommand = await callCommands.setRandomNumberBase(
            callCommandId: callCommand.id,
            randomNumberBase: 2,
          );
          expect(updatedCallCommand.id, callCommand.id);
          expect(updatedCallCommand.randomNumberBase, 2);
        },
      );

      test(
        '.setAfter',
        () async {
          final command = await commands.createCommand();
          final callCommand = await callCommands.createCallCommand(
            commandId: command.id,
            callingCommandId: command.id,
            after: 5,
          );
          expect(callCommand.after, 5);
          var updatedCallCommand = await callCommands.setAfter(
            callCommandId: callCommand.id,
          );
          expect(updatedCallCommand.id, callCommand.id);
          expect(updatedCallCommand.after, null);
          updatedCallCommand = await callCommands.setAfter(
            callCommandId: callCommand.id,
            after: 2,
          );
          expect(updatedCallCommand.id, callCommand.id);
          expect(updatedCallCommand.after, 2);
        },
      );
    },
  );
}
