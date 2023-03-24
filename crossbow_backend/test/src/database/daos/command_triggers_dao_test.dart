import 'package:crossbow_backend/crossbow_backend.dart';
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

      test(
        '.getCommandTriggers',
        () async {
          await db.delete(db.commandTriggers).go();
          final play = await commandTriggersDao.createCommandTrigger(
            description: 'Play',
          );
          final quit = await commandTriggersDao.createCommandTrigger(
            description: 'Quit',
          );
          final advance = await commandTriggersDao.createCommandTrigger(
            description: 'Advance',
          );
          final expected = [advance, play, quit];
          final triggers = await commandTriggersDao.getCommandTriggers();
          expect(triggers.length, expected.length);
          for (var i = 0; i < triggers.length; i++) {
            final actualTrigger = expected[i];
            final retrievedTrigger = triggers[i];
            expect(retrievedTrigger.description, actualTrigger.description);
            expect(retrievedTrigger.id, actualTrigger.id);
          }
        },
      );

      test(
        '.deleteCommandTrigger',
        () async {
          final keyboardKey = await db.commandTriggerKeyboardKeysDao
              .createCommandTriggerKeyboardKey(
            scanCode: ScanCode.t,
          );
          final trigger = await commandTriggersDao.createCommandTrigger(
            description: 'Test trigger',
            keyboardKeyId: keyboardKey.id,
          );
          expect(
            await commandTriggersDao.deleteCommandTrigger(
              commandTriggerId: trigger.id,
            ),
            1,
          );
          expect(
            await db.commandTriggerKeyboardKeysDao
                .getCommandTriggerKeyboardKey(id: keyboardKey.id),
            predicate<CommandTriggerKeyboardKey>(
              (final value) =>
                  value.id == keyboardKey.id &&
                  value.scanCode == keyboardKey.scanCode,
            ),
          );
          expect(
            commandTriggersDao.getCommandTrigger(id: trigger.id),
            throwsStateError,
          );
        },
      );

      test(
        '.getCommandTriggerName',
        () async {
          final trigger1 = await commandTriggersDao.createCommandTrigger(
            description: 'Test command trigger.',
          );
          expect(
            await commandTriggersDao.getCommandTriggerName(
              commandTriggerId: trigger1.id,
            ),
            'trigger${trigger1.id}',
          );
          final trigger2 = await commandTriggersDao.createCommandTrigger(
            description: 'Another test command trigger.',
          );
          expect(
            await commandTriggersDao.getCommandTriggerName(
              commandTriggerId: trigger2.id,
            ),
            'trigger${trigger2.id}',
          );
        },
      );
    },
  );
}
