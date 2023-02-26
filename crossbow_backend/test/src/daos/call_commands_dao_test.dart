import 'package:crossbow_backend/database.dart';
import 'package:test/test.dart';

import '../../custom_database.dart';

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
          var callCommand =
              await callCommands.createCallCommand(commandId: command.id);
          expect(callCommand.after, null);
          expect(callCommand.commandId, command.id);
          callCommand = await callCommands.createCallCommand(
            commandId: command.id,
            after: 1234,
          );
          expect(callCommand.after, 1234);
          expect(callCommand.commandId, command.id);
        },
      );

      test(
        '.getCallCommand',
        () async {
          final command = await commands.createCommand();
          final callCommand =
              await callCommands.createCallCommand(commandId: command.id);
          expect(
            await callCommands.getCallCommand(id: callCommand.id),
            predicate<CallCommand>(
              (final value) => value.id == callCommand.id,
            ),
          );
        },
      );

      test(
        '.deleteCallCommand',
        () async {
          final command2 = await commands.createCommand();
          final callCommand =
              await callCommands.createCallCommand(commandId: command2.id);
          final command1 = await commands.createCommand(
            callCommandId: callCommand.id,
          );
          expect(command1.callCommandId, callCommand.id);
          expect(
            await callCommands.deleteCallCommand(
              callCommandId: callCommand.id,
            ),
            1,
          );
          await expectLater(
            callCommands.getCallCommand(id: callCommand.id),
            throwsStateError,
          );
          expect(commands.getCommand(id: command2.id), throwsStateError);
          final updatedCommand = await commands.getCommand(id: command1.id);
          expect(
            updatedCommand.id,
            command1.id,
          );
          expect(updatedCommand.callCommandId, null);
        },
      );
    },
  );
}
