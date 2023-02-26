import 'dart:math';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  final db = getDatabase();
  final popLevels = db.popLevelsDao;

  group(
    'PopLevelsDao',
    () {
      test(
        '.createPopLevel',
        () async {
          var popLevel = await popLevels.createPopLevel();
          expect(popLevel.fadeLength, null);
          popLevel = await popLevels.createPopLevel(fadeLength: pi);
          expect(popLevel.fadeLength, pi);
        },
      );

      test(
        '.getPopLevel',
        () async {
          final popLevel = await popLevels.createPopLevel(fadeLength: pi);
          expect(
            await popLevels.getPopLevel(id: popLevel.id),
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
          final popLevel = await popLevels.createPopLevel();
          expect(popLevel.fadeLength, null);
          var updatedPopLevel =
              await popLevels.setFadeLength(id: popLevel.id, fadeLength: pi);
          expect(updatedPopLevel.id, popLevel.id);
          expect(updatedPopLevel.fadeLength, pi);
          updatedPopLevel = await popLevels.setFadeLength(id: popLevel.id);
          expect(updatedPopLevel.id, popLevel.id);
          expect(updatedPopLevel.fadeLength, null);
        },
      );

      test(
        '.deletePopLevel',
        () async {
          var popLevel = await popLevels.createPopLevel();
          await popLevels.deletePopLevel(id: popLevel.id);
          await expectLater(
            popLevels.getPopLevel(id: popLevel.id),
            throwsStateError,
          );
          popLevel = await popLevels.createPopLevel(fadeLength: 5.2);
          final command = await db.commandsDao.createCommand(
            popLevelId: popLevel.id,
          );
          expect(command.popLevelId, popLevel.id);
          await popLevels.deletePopLevel(id: popLevel.id);
          await expectLater(
            popLevels.getPopLevel(id: popLevel.id),
            throwsStateError,
          );
          expect(
            (await db.commandsDao.getCommand(id: command.id)).popLevelId,
            null,
          );
        },
      );
    },
  );
}
