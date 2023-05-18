import 'package:dart_sdl/dart_sdl.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'CommandTriggerKeyboardKey',
    () {
      final db = getDatabase();
      final keyboardKeysDao = db.commandTriggerKeyboardKeysDao;

      test(
        '.createCommandTriggerKeyboardKey',
        () async {
          final key = await keyboardKeysDao.createCommandTriggerKeyboardKey(
            scanCode: ScanCode.t,
          );
          expect(key.alt, false);
          expect(key.control, false);
          expect(key.id, isNonZero);
          expect(key.scanCode, ScanCode.t);
          expect(key.shift, false);
        },
      );

      test(
        '.setScanCode',
        () async {
          final key = await keyboardKeysDao.createCommandTriggerKeyboardKey(
            scanCode: ScanCode.t,
          );
          final updatedKey = await keyboardKeysDao.setScanCode(
            commandTriggerKeyboardKey: key,
            scanCode: ScanCode.q,
          );
          expect(updatedKey.id, key.id);
          expect(updatedKey.alt, key.alt);
          expect(updatedKey.control, key.control);
          expect(updatedKey.scanCode, ScanCode.q);
          expect(updatedKey.shift, key.shift);
        },
      );

      test(
        '.setModifiers',
        () async {
          final key = await keyboardKeysDao.createCommandTriggerKeyboardKey(
            scanCode: ScanCode.f,
            alt: true,
            control: true,
            shift: true,
          );
          expect(key.scanCode, ScanCode.f);
          expect(key.alt, true);
          expect(key.control, true);
          expect(key.shift, true);
          expect(
            keyboardKeysDao.setModifiers(
              commandTriggerKeyboardKey: key,
            ),
            throwsStateError,
          );
          var updatedKey = await keyboardKeysDao.setModifiers(
            commandTriggerKeyboardKey: key,
            alt: false,
          );
          expect(updatedKey.id, key.id);
          expect(updatedKey.scanCode, ScanCode.f);
          expect(updatedKey.alt, false);
          expect(updatedKey.control, true);
          expect(updatedKey.shift, true);
          updatedKey = await keyboardKeysDao.setModifiers(
            commandTriggerKeyboardKey: updatedKey,
            control: false,
          );
          expect(updatedKey.id, key.id);
          expect(updatedKey.scanCode, ScanCode.f);
          expect(updatedKey.alt, false);
          expect(updatedKey.control, false);
          expect(updatedKey.shift, true);
          updatedKey = await keyboardKeysDao.setModifiers(
            commandTriggerKeyboardKey: updatedKey,
            shift: false,
          );
          expect(updatedKey.id, key.id);
          expect(updatedKey.scanCode, ScanCode.f);
          expect(updatedKey.alt, false);
          expect(updatedKey.control, false);
          expect(updatedKey.shift, false);
          updatedKey = await keyboardKeysDao.setModifiers(
            commandTriggerKeyboardKey: updatedKey,
            alt: true,
            control: true,
            shift: true,
          );
          expect(updatedKey.id, key.id);
          expect(updatedKey.scanCode, ScanCode.f);
          expect(updatedKey.alt, true);
          expect(updatedKey.control, true);
          expect(updatedKey.shift, true);
        },
      );

      test(
        '.deleteCommandTriggerKeyboardKey',
        () async {
          final key = await keyboardKeysDao.createCommandTriggerKeyboardKey(
            scanCode: ScanCode.q,
            shift: true,
          );
          expect(
            await keyboardKeysDao.deleteCommandTriggerKeyboardKey(
              commandTriggerKeyboardKey: key,
            ),
            1,
          );
          expect(
            keyboardKeysDao.getCommandTriggerKeyboardKey(id: key.id),
            throwsStateError,
          );
        },
      );
    },
  );
}
