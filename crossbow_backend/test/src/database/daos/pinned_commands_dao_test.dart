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
            commandId: command.id,
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
            commandId: command.id,
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
            commandId: command.id,
            name: 'Test',
          );
          var updatedPinnedCommand = await pinnedCommandsDao.setName(
            pinnedCommandId: pinnedCommand.id,
            name: 'Test 2',
          );
          expect(updatedPinnedCommand.id, pinnedCommand.id);
          expect(updatedPinnedCommand.name, 'Test 2');
          updatedPinnedCommand = await pinnedCommandsDao.setName(
            pinnedCommandId: pinnedCommand.id,
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
            commandId: command.id,
            name: 'Test',
          );
          expect(
            commandsDao.deleteCommand(id: command.id),
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
              pinnedCommandId: pinnedCommand.id,
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
    },
  );
}
