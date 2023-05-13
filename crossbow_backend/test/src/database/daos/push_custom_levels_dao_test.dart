import 'dart:math';

import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'PushCustomLevelsDao',
    () {
      final db = getDatabase();
      final pushCustomLevelsDao = db.pushCustomLevelsDao;
      final customLevelsDao = db.customLevelsDao;

      test(
        '.createPushCustomLevel',
        () async {
          final level =
              await customLevelsDao.createCustomLevel(name: 'Test Level');
          final pushLevel = await pushCustomLevelsDao.createPushCustomLevel(
            customLevelId: level.id,
          );
          expect(pushLevel.after, null);
          expect(pushLevel.customLevelId, level.id);
          expect(pushLevel.fadeLength, null);
          expect(pushLevel.id, isNonZero);
        },
      );

      test(
        '.getPushCustomLevel',
        () async {
          final level = await customLevelsDao.createCustomLevel(
            name: 'Test Level',
          );
          final pushLevel = await pushCustomLevelsDao.createPushCustomLevel(
            customLevelId: level.id,
            after: 1234,
            fadeTime: pi,
          );
          final retrievedPushCustomLevel =
              await pushCustomLevelsDao.getPushCustomLevel(
            id: pushLevel.id,
          );
          expect(retrievedPushCustomLevel.after, pushLevel.after);
          expect(retrievedPushCustomLevel.customLevelId, level.id);
          expect(retrievedPushCustomLevel.fadeLength, pi);
          expect(retrievedPushCustomLevel.id, pushLevel.id);
        },
      );

      test(
        '.deletePushCustomLevel',
        () async {
          final level = await customLevelsDao.createCustomLevel(
            name: 'Test Level',
          );
          final pushLevel = await pushCustomLevelsDao.createPushCustomLevel(
            customLevelId: level.id,
          );
          expect(
            await pushCustomLevelsDao.deletePushCustomLevel(id: pushLevel.id),
            1,
          );
          await expectLater(
            pushCustomLevelsDao.getPushCustomLevel(id: pushLevel.id),
            throwsStateError,
          );
          expect(
            (await customLevelsDao.getCustomLevel(id: level.id)).id,
            level.id,
          );
        },
      );

      test(
        '.setAfter',
        () async {
          final level = await customLevelsDao.createCustomLevel(
            name: 'Test Level',
          );
          final pushLevel = await pushCustomLevelsDao.createPushCustomLevel(
            customLevelId: level.id,
            after: 1234,
          );
          expect(pushLevel.after, 1234);
          var updatedPushLevel = await pushCustomLevelsDao.setAfter(
            pushCustomLevelId: pushLevel.id,
          );
          expect(updatedPushLevel.id, pushLevel.id);
          expect(updatedPushLevel.after, null);
          updatedPushLevel = await pushCustomLevelsDao.setAfter(
            pushCustomLevelId: pushLevel.id,
            after: 4321,
          );
          expect(updatedPushLevel.id, pushLevel.id);
          expect(updatedPushLevel.after, 4321);
        },
      );

      test(
        '.setFadeLength',
        () async {
          final level = await customLevelsDao.createCustomLevel(
            name: 'Test Level',
          );
          final pushLevel = await pushCustomLevelsDao.createPushCustomLevel(
            customLevelId: level.id,
            fadeTime: pi,
          );
          expect(pushLevel.fadeLength, pi);
          var updatedPushLevel = await pushCustomLevelsDao.setFadeLength(
            pushCustomLevelId: pushLevel.id,
          );
          expect(updatedPushLevel.id, pushLevel.id);
          expect(updatedPushLevel.fadeLength, null);
          updatedPushLevel = await pushCustomLevelsDao.setFadeLength(
            pushCustomLevelId: pushLevel.id,
            fadeLength: 1234.5,
          );
          expect(updatedPushLevel.id, pushLevel.id);
          expect(updatedPushLevel.fadeLength, 1234.5);
        },
      );

      test(
        '.setCustomLevelId',
        () async {
          final level1 =
              await customLevelsDao.createCustomLevel(name: 'Level 1');
          final level2 =
              await customLevelsDao.createCustomLevel(name: 'Level 2');
          final pushCustomLevel = await pushCustomLevelsDao
              .createPushCustomLevel(customLevelId: level1.id);
          expect(pushCustomLevel.customLevelId, level1.id);
          var updatedPushCustomLevel =
              await pushCustomLevelsDao.setCustomLevelId(
            pushCustomLevelId: pushCustomLevel.id,
            customLevelId: level2.id,
          );
          expect(updatedPushCustomLevel.id, pushCustomLevel.id);
          expect(updatedPushCustomLevel.customLevelId, level2.id);
          updatedPushCustomLevel = await pushCustomLevelsDao.setCustomLevelId(
            pushCustomLevelId: pushCustomLevel.id,
            customLevelId: level1.id,
          );
          expect(updatedPushCustomLevel.id, pushCustomLevel.id);
          expect(updatedPushCustomLevel.customLevelId, level1.id);
        },
      );

      test(
        '.setVariableName',
        () async {
          final level = await customLevelsDao.createCustomLevel(name: 'Test');
          final pushCustomLevel = await pushCustomLevelsDao
              .createPushCustomLevel(customLevelId: level.id);
          expect(pushCustomLevel.variableName, null);
          final updatedPushCustomLevel =
              await pushCustomLevelsDao.setVariableName(
            pushCustomLevelId: pushCustomLevel.id,
            variableName: 'push',
          );
          expect(updatedPushCustomLevel.id, pushCustomLevel.id);
          expect(updatedPushCustomLevel.variableName, 'push');
        },
      );

      test(
        '.getPushCustomLevels',
        () async {
          final levels = await pushCustomLevelsDao.getPushCustomLevels();
          expect(levels, await db.select(db.pushCustomLevels).get());
        },
      );
    },
  );
}
