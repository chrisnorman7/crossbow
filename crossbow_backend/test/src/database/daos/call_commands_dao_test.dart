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
            () => callCommands.createCallCommand(command: command),
            throwsStateError,
          );
          final menu = await db.menusDao.createMenu(name: 'Test Menu');
          final menuItem = await db.menuItemsDao.createMenuItem(
            menu: menu,
            name: 'Test',
          );
          var callCommand = await callCommands.createCallCommand(
            command: command,
            callingCommand: command,
            onCancelMenu: menu,
            callingMenuItem: menuItem,
          );
          expect(callCommand.after, null);
          expect(callCommand.commandId, command.id);
          expect(callCommand.callingCommandId, command.id);
          expect(callCommand.callingMenuItemId, menuItem.id);
          expect(callCommand.onCancelMenuId, menu.id);
          callCommand = await callCommands.createCallCommand(
            command: command,
            after: 1234,
            callingCommand: command,
            callingMenuItem: menuItem,
            onCancelMenu: menu,
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
            command: command,
            callingCommand: command,
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
            command: command,
            callingCommand: command,
            randomNumberBase: 5,
          );
          expect(callCommand.randomNumberBase, 5);
          var updatedCallCommand = await callCommands.setRandomNumberBase(
            callCommand: callCommand,
          );
          expect(updatedCallCommand.id, callCommand.id);
          expect(updatedCallCommand.randomNumberBase, null);
          updatedCallCommand = await callCommands.setRandomNumberBase(
            callCommand: callCommand,
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
            command: command,
            callingCommand: command,
            after: 5,
          );
          expect(callCommand.after, 5);
          var updatedCallCommand = await callCommands.setAfter(
            callCommand: callCommand,
          );
          expect(updatedCallCommand.id, callCommand.id);
          expect(updatedCallCommand.after, null);
          updatedCallCommand = await callCommands.setAfter(
            callCommand: callCommand,
            after: 2,
          );
          expect(updatedCallCommand.id, callCommand.id);
          expect(updatedCallCommand.after, 2);
        },
      );

      test(
        '.setCommandId',
        () async {
          final callingCommand = await commands.createCommand();
          final command1 = await commands.createCommand();
          final command2 = await commands.createCommand();
          final callCommand = await callCommands.createCallCommand(
            command: command1,
            callingCommand: callingCommand,
          );
          var updatedCallCommand = await callCommands.setCommandId(
            callCommand: callCommand,
            commandId: command2.id,
          );
          expect(updatedCallCommand.id, callCommand.id);
          expect(updatedCallCommand.commandId, command2.id);
          updatedCallCommand = await callCommands.setCommandId(
            callCommand: updatedCallCommand,
            commandId: command1.id,
          );
          expect(updatedCallCommand.id, callCommand.id);
          expect(updatedCallCommand.commandId, command1.id);
        },
      );

      test(
        '.deleteCallCommand',
        () async {
          final callingCommand = await commands.createCommand();
          final command = await commands.createCommand();
          final callCommand = await callCommands.createCallCommand(
            command: command,
            callingCommand: callingCommand,
          );
          expect(
            await callCommands.deleteCallCommand(
              callCommand: callCommand,
            ),
            1,
          );
          expect(
            callCommands.getCallCommand(id: callCommand.id),
            throwsStateError,
          );
          expect((await commands.getCommand(id: command.id)).id, command.id);
          expect(
            (await commands.getCommand(id: callingCommand.id)).id,
            callingCommand.id,
          );
        },
      );
    },
  );
}
