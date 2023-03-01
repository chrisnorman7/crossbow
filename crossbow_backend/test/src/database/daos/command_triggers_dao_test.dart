import 'package:dart_sdl/dart_sdl.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'CommandTriggersDao',
    () {
      final db = getDatabase();

      final commandTriggersDao = db.commandTriggersDao;

      test(
        '.createCommandTrigger',
        () async {
          final trigger = await commandTriggersDao.createCommandTrigger(
            description: 'Test Command Trigger',
          );
          expect(trigger.description, 'Test Command Trigger');
          expect(trigger.gameControllerButton, null);
          expect(trigger.id, isNonZero);
          expect(trigger.keyboardKeyId, null);
        },
      );

      test(
        '.getCommandTrigger',
        () async {
          final initialCommandTrigger =
              await commandTriggersDao.createCommandTrigger(
            description: 'Test Command Trigger',
            gameControllerButton: GameControllerButton.x,
          );
          final retrievedCommandTrigger = await commandTriggersDao
              .getCommandTrigger(id: initialCommandTrigger.id);
          expect(
            retrievedCommandTrigger.description,
            initialCommandTrigger.description,
          );
          expect(
            retrievedCommandTrigger.gameControllerButton,
            initialCommandTrigger.gameControllerButton,
          );
          expect(retrievedCommandTrigger.id, initialCommandTrigger.id);
          expect(
            retrievedCommandTrigger.keyboardKeyId,
            initialCommandTrigger.keyboardKeyId,
          );
        },
      );

      test(
        '.setDescription',
        () async {
          final trigger =
              await commandTriggersDao.createCommandTrigger(description: '');
          final updatedTrigger = await commandTriggersDao.setDescription(
            commandTriggerId: trigger.id,
            description: 'asdf',
          );
          expect(updatedTrigger.id, trigger.id);
          expect(updatedTrigger.description, 'asdf');
        },
      );

      test(
        '.setKeyboardKeyId',
        () async {
          final keyboardKey = await db.commandTriggerKeyboardKeysDao
              .createCommandTriggerKeyboardKey(scanCode: ScanCode.s);
          final trigger = await commandTriggersDao.createCommandTrigger(
            description: 'Test',
            keyboardKeyId: keyboardKey.id,
          );
          expect(trigger.keyboardKeyId, keyboardKey.id);
          var updatedTrigger = await commandTriggersDao.setKeyboardKeyId(
            commandTriggerId: trigger.id,
          );
          expect(updatedTrigger.id, trigger.id);
          expect(updatedTrigger.keyboardKeyId, null);
          updatedTrigger = await commandTriggersDao.setKeyboardKeyId(
            commandTriggerId: trigger.id,
            keyboardKeyId: keyboardKey.id,
          );
          expect(updatedTrigger.id, trigger.id);
          expect(updatedTrigger.keyboardKeyId, keyboardKey.id);
        },
      );
    },
  );
}
