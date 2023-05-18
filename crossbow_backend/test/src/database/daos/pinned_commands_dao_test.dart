import 'package:crossbow_backend/src/database/database.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'PinnedCommandsDao',
    () {
      final db = getDatabase();
      final commandsDao = db.commandsDao;
      final pinnedCommandsDao = db.pinnedCommandsDao;

      test(
        '.createPinnedCommand',
        () async {
          final command = await commandsDao.createCommand();
          final pinnedCommand = await pinnedCommandsDao.createPinnedCommand(
            command: command,
            name: 'Test',
          );
          expect(pinnedCommand.commandId, command.id);
          expect(pinnedCommand.id, isNonZero);
          expect(pinnedCommand.name, 'Test');
        },
      );

      test(
        '.getPinnedCommand',
        () async {
          final command = await commandsDao.createCommand();
          final pinnedCommand = await pinnedCommandsDao.createPinnedCommand(
            command: command,
            name: 'Test',
          );
          final retrievedPinnedCommand =
              await pinnedCommandsDao.getPinnedCommand(id: pinnedCommand.id);
          expect(retrievedPinnedCommand.commandId, command.id);
          expect(retrievedPinnedCommand.id, pinnedCommand.id);
          expect(retrievedPinnedCommand.name, pinnedCommand.name);
        },
      );

      test(
        '.setName',
        () async {
          final command = await commandsDao.createCommand();
          final pinnedCommand = await pinnedCommandsDao.createPinnedCommand(
            command: command,
            name: 'Test',
          );
          var updatedPinnedCommand = await pinnedCommandsDao.setName(
            pinnedCommand: pinnedCommand,
            name: 'Test 2',
          );
          expect(updatedPinnedCommand.id, pinnedCommand.id);
          expect(updatedPinnedCommand.name, 'Test 2');
          updatedPinnedCommand = await pinnedCommandsDao.setName(
            pinnedCommand: pinnedCommand,
            name: pinnedCommand.name,
          );
          expect(updatedPinnedCommand.name, pinnedCommand.name);
        },
      );

      test(
        '.deletePinnedCommand',
        () async {
          final command = await commandsDao.createCommand();
          final pinnedCommand = await pinnedCommandsDao.createPinnedCommand(
            command: command,
            name: 'Test',
          );
          expect(
            commandsDao.deleteCommand(command: command),
            throwsA(isA<SqliteException>()),
          );
          expect(
            await pinnedCommandsDao.getPinnedCommand(id: pinnedCommand.id),
            predicate<PinnedCommand>(
              (final value) =>
                  value.commandId == pinnedCommand.commandId &&
                  value.id == pinnedCommand.id &&
                  value.name == pinnedCommand.name,
            ),
          );
          expect(
            await pinnedCommandsDao.deletePinnedCommand(
              pinnedCommand: pinnedCommand,
            ),
            1,
          );
          expect(
            pinnedCommandsDao.getPinnedCommand(id: pinnedCommand.id),
            throwsStateError,
          );
          expect((await commandsDao.getCommand(id: command.id)).id, command.id);
        },
      );

      test(
        '.getPinnedCommands',
        () async {
          final deleteQuery = db.delete(db.pinnedCommands);
          await deleteQuery.go();
          final command = await commandsDao.createCommand();
          final pc1 = await pinnedCommandsDao.createPinnedCommand(
            command: command,
            name: '1',
          );
          final pc3 = await pinnedCommandsDao.createPinnedCommand(
            command: command,
            name: '3',
          );
          final pc2 = await pinnedCommandsDao.createPinnedCommand(
            command: command,
            name: '2',
          );
          final expected = [pc1, pc2, pc3];
          final actual = await pinnedCommandsDao.getPinnedCommands();
          expect(actual.length, expected.length);
          for (var i = 0; i < actual.length; i++) {
            final expectedPinnedCommand = expected[i];
            final actualPinnedCommand = actual[i];
            expect(
              actualPinnedCommand.commandId,
              expectedPinnedCommand.commandId,
            );
            expect(actualPinnedCommand.id, expectedPinnedCommand.id);
            expect(actualPinnedCommand.name, expectedPinnedCommand.name);
          }
        },
      );
    },
  );
}
