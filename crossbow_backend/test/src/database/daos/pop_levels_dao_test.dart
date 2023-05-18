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
          var updatedPopLevel = await popLevelsDao.setFadeLength(
            popLevel: popLevel,
            fadeLength: pi,
          );
          expect(updatedPopLevel.id, popLevel.id);
          expect(updatedPopLevel.fadeLength, pi);
          updatedPopLevel =
              await popLevelsDao.setFadeLength(popLevel: popLevel);
          expect(updatedPopLevel.id, popLevel.id);
          expect(updatedPopLevel.fadeLength, null);
        },
      );

      test(
        '.deletePopLevel',
        () async {
          var popLevel = await popLevelsDao.createPopLevel();
          await popLevelsDao.deletePopLevel(popLevel: popLevel);
          await expectLater(
            popLevelsDao.getPopLevel(id: popLevel.id),
            throwsStateError,
          );
          popLevel = await popLevelsDao.createPopLevel(fadeLength: 5.2);
          final command = await db.commandsDao.createCommand(
            popLevel: popLevel,
          );
          expect(command.popLevelId, popLevel.id);
          await popLevelsDao.deletePopLevel(popLevel: popLevel);
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
            popLevel: popLevel,
            description: 'Pop',
          );
          expect(updatedPopLevel.id, popLevel.id);
          expect(updatedPopLevel.description, 'Pop');
        },
      );

      test(
        '.setVariableName',
        () async {
          final popLevel = await popLevelsDao.createPopLevel();
          expect(popLevel.variableName, null);
          final updatedPopLevel = await popLevelsDao.setVariableName(
            popLevel: popLevel,
            variableName: 'popLevel',
          );
          expect(updatedPopLevel.id, popLevel.id);
          expect(updatedPopLevel.variableName, 'popLevel');
        },
      );
    },
  );
}
