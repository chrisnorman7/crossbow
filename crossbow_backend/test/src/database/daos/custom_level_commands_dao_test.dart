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
            customLevelId: level.id,
            commandTriggerId: commandTrigger.id,
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
            customLevelId: level.id,
            commandTriggerId: commandTrigger.id,
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
            customLevelId: level.id,
            commandTriggerId: commandTrigger.id,
          );
          var updatedCommand = await customLevelCommandsDao.setCommandTriggerId(
            customLevelCommandId: command.id,
            commandTriggerId: commandTrigger2.id,
          );
          expect(updatedCommand.commandTriggerId, commandTrigger2.id);
          expect(updatedCommand.customLevelId, level.id);
          expect(updatedCommand.id, command.id);
          updatedCommand = await customLevelCommandsDao.setCommandTriggerId(
            customLevelCommandId: command.id,
            commandTriggerId: commandTrigger.id,
          );
          expect(updatedCommand.commandTriggerId, commandTrigger.id);
          expect(updatedCommand.customLevelId, level.id);
          expect(updatedCommand.id, command.id);
        },
      );
    },
  );
}
