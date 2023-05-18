import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'CustomLevelCommandsDao',
    () {
      final db = getDatabase();
      final customLevelCommandsDao = db.customLevelCommandsDao;
      final customLevelsDao = db.customLevelsDao;
      final commandTriggersDao = db.commandTriggersDao;
      final commandsDao = db.commandsDao;
      final callCommandsDao = db.callCommandsDao;
      late final CommandTrigger commandTrigger;

      setUpAll(() async {
        commandTrigger = await commandTriggersDao.createCommandTrigger(
          description: 'Test Command Trigger',
        );
      });

      test(
        '.createCustomLevelCommand',
        () async {
          final level = await customLevelsDao.createCustomLevel(name: 'Level');
          final command = await customLevelCommandsDao.createCustomLevelCommand(
            customLevel: level,
            commandTrigger: commandTrigger,
          );
          expect(command.commandTriggerId, commandTrigger.id);
          expect(command.customLevelId, level.id);
          expect(command.id, isNonZero);
        },
      );

      test(
        '.getCustomLevelCommand',
        () async {
          final level = await customLevelsDao.createCustomLevel(name: 'Test');
          final command = await customLevelCommandsDao.createCustomLevelCommand(
            customLevel: level,
            commandTrigger: commandTrigger,
          );
          final retrievedCommand = await customLevelCommandsDao
              .getCustomLevelCommand(id: command.id);
          expect(retrievedCommand.commandTriggerId, commandTrigger.id);
          expect(retrievedCommand.customLevelId, level.id);
          expect(retrievedCommand.id, command.id);
        },
      );

      test(
        '.setMusicId',
        () async {
          final commandTrigger2 = await commandTriggersDao.createCommandTrigger(
            description: 'Second Command Trigger',
          );
          final level = await customLevelsDao.createCustomLevel(name: 'Test');
          final command = await customLevelCommandsDao.createCustomLevelCommand(
            customLevel: level,
            commandTrigger: commandTrigger,
          );
          var updatedCommand = await customLevelCommandsDao.setCommandTrigger(
            customLevelCommand: command,
            commandTrigger: commandTrigger2,
          );
          expect(updatedCommand.commandTriggerId, commandTrigger2.id);
          expect(updatedCommand.customLevelId, level.id);
          expect(updatedCommand.id, command.id);
          updatedCommand = await customLevelCommandsDao.setCommandTrigger(
            customLevelCommand: command,
            commandTrigger: commandTrigger,
          );
          expect(updatedCommand.commandTriggerId, commandTrigger.id);
          expect(updatedCommand.customLevelId, level.id);
          expect(updatedCommand.id, command.id);
        },
      );

      test(
        '.deleteCustomLevelCommand',
        () async {
          final level = await customLevelsDao.createCustomLevel(name: 'Test');
          final command1 =
              await customLevelCommandsDao.createCustomLevelCommand(
            customLevel: level,
            commandTrigger: commandTrigger,
          );
          final command2 =
              await customLevelCommandsDao.createCustomLevelCommand(
            customLevel: level,
            commandTrigger: commandTrigger,
          );
          expect(
            await customLevelCommandsDao.deleteCustomLevelCommand(
              customLevelCommand: command1,
            ),
            1,
          );
          await expectLater(
            customLevelCommandsDao.getCustomLevelCommand(id: command1.id),
            throwsStateError,
          );
          expect(
            (await customLevelCommandsDao.getCustomLevelCommand(
              id: command2.id,
            ))
                .id,
            command2.id,
          );
        },
      );

      test(
        '.getCallCommands',
        () async {
          final level = await customLevelsDao.createCustomLevel(name: 'Test');
          final customLevelCommand =
              await customLevelCommandsDao.createCustomLevelCommand(
            customLevel: level,
            commandTrigger: commandTrigger,
          );
          final command = await commandsDao.createCommand();
          final callCommand1 = await callCommandsDao.createCallCommand(
            command: command,
            callingCustomLevelCommand: customLevelCommand,
          );
          final callCommand2 = await callCommandsDao.createCallCommand(
            command: command,
            callingCustomLevelCommand: customLevelCommand,
          );
          final callCommands = await customLevelCommandsDao.getCallCommands(
            customLevelCommand: customLevelCommand,
          );
          expect(callCommands.length, 2);
          expect(callCommands.first.id, callCommand1.id);
          expect(callCommands.last.id, callCommand2.id);
        },
      );

      test(
        '.getReleaseCommands',
        () async {
          final level = await customLevelsDao.createCustomLevel(name: 'Test');
          final customLevelCommand =
              await customLevelCommandsDao.createCustomLevelCommand(
            customLevel: level,
            commandTrigger: commandTrigger,
          );
          final command = await commandsDao.createCommand();
          final callCommand1 = await callCommandsDao.createCallCommand(
            command: command,
            releasingCustomLevelCommand: customLevelCommand,
          );
          final callCommand2 = await callCommandsDao.createCallCommand(
            command: command,
            releasingCustomLevelCommand: customLevelCommand,
          );
          final callCommands = await customLevelCommandsDao.getReleaseCommands(
            customLevelCommand: customLevelCommand,
          );
          expect(callCommands.length, 2);
          expect(callCommands.first.id, callCommand1.id);
          expect(callCommands.last.id, callCommand2.id);
        },
      );

      test(
        '.setInterval',
        () async {
          final level =
              await customLevelsDao.createCustomLevel(name: 'Test Level');
          final command = await customLevelCommandsDao.createCustomLevelCommand(
            customLevel: level,
            commandTrigger: commandTrigger,
            interval: 1000,
          );
          expect(command.interval, 1000);
          var updatedCommand = await customLevelCommandsDao.setInterval(
            customLevelCommand: command,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.interval, null);
          updatedCommand = await customLevelCommandsDao.setInterval(
            customLevelCommand: command,
            interval: 5000,
          );
          expect(updatedCommand.id, command.id);
          expect(updatedCommand.interval, 5000);
        },
      );
    },
  );
}
