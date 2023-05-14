import 'dart:math';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  final db = getDatabase();
  final popLevelsDao = db.popLevelsDao;

  group(
    'PopLevelsDao',
    () {
      test(
        '.createPopLevel',
        () async {
          var popLevel = await popLevelsDao.createPopLevel();
          expect(popLevel.fadeLength, null);
          popLevel = await popLevelsDao.createPopLevel(fadeLength: pi);
          expect(popLevel.fadeLength, pi);
        },
      );

      test(
        '.getPopLevel',
        () async {
          final popLevel = await popLevelsDao.createPopLevel(fadeLength: pi);
          expect(
            await popLevelsDao.getPopLevel(id: popLevel.id),
            predicate<PopLevel>(
              (final value) =>
                  value.id == popLevel.id &&
                  value.fadeLength == popLevel.fadeLength,
            ),
          );
        },
      );

      test(
        '.setFadeLength',
        () async {
          final popLevel = await popLevelsDao.createPopLevel();
          expect(popLevel.fadeLength, null);
          var updatedPopLevel =
              await popLevelsDao.setFadeLength(id: popLevel.id, fadeLength: pi);
          expect(updatedPopLevel.id, popLevel.id);
          expect(updatedPopLevel.fadeLength, pi);
          updatedPopLevel = await popLevelsDao.setFadeLength(id: popLevel.id);
          expect(updatedPopLevel.id, popLevel.id);
          expect(updatedPopLevel.fadeLength, null);
        },
      );

      test(
        '.deletePopLevel',
        () async {
          var popLevel = await popLevelsDao.createPopLevel();
          await popLevelsDao.deletePopLevel(id: popLevel.id);
          await expectLater(
            popLevelsDao.getPopLevel(id: popLevel.id),
            throwsStateError,
          );
          popLevel = await popLevelsDao.createPopLevel(fadeLength: 5.2);
          final command = await db.commandsDao.createCommand(
            popLevelId: popLevel.id,
          );
          expect(command.popLevelId, popLevel.id);
          await popLevelsDao.deletePopLevel(id: popLevel.id);
          await expectLater(
            popLevelsDao.getPopLevel(id: popLevel.id),
            throwsStateError,
          );
          expect(
            (await db.commandsDao.getCommand(id: command.id)).popLevelId,
            null,
          );
        },
      );

      test(
        '.setDescription',
        () async {
          final popLevel = await popLevelsDao.createPopLevel();
          expect(popLevel.description, 'Pop a level.');
          final updatedPopLevel = await popLevelsDao.setDescription(
            popLevelId: popLevel.id,
            description: 'Pop',
          );
          expect(updatedPopLevel.id, popLevel.id);
          expect(updatedPopLevel.description, 'Pop');
        },
      );
    },
  );
}
