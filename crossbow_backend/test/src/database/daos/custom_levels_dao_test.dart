import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'CustomLevelsDao',
    () {
      final db = getDatabase();
      final customLevelsDao = db.customLevelsDao;
      final customLevelCommandsDao = db.customLevelCommandsDao;
      final assetReferencesDao = db.assetReferencesDao;
      final commandTriggersDao = db.commandTriggersDao;

      test(
        '.createCustomLevel',
        () async {
          final level = await customLevelsDao.createCustomLevel(
            name: 'Test Level',
          );
          expect(level.id, isNonZero);
          expect(level.name, 'Test Level');
          expect(level.musicId, null);
        },
      );

      test(
        '.getCustomLevel',
        () async {
          final level = await customLevelsDao.createCustomLevel(
            name: 'Test Level',
          );
          final retrievedLevel =
              await customLevelsDao.getCustomLevel(id: level.id);
          expect(retrievedLevel.id, level.id);
          expect(retrievedLevel.name, level.name);
        },
      );

      test(
        '.setMusicId',
        () async {
          final music = await assetReferencesDao.createAssetReference(
            folderName: 'music',
            name: 'custom_level.mp3',
          );
          final level = await customLevelsDao.createCustomLevel(
            name: 'Test Level',
            musicId: music.id,
          );
          expect(level.musicId, music.id);
          var updatedLevel =
              await customLevelsDao.setMusicId(customLevelId: level.id);
          expect(updatedLevel.id, level.id);
          expect(updatedLevel.musicId, null);
          updatedLevel = await customLevelsDao.setMusicId(
            customLevelId: level.id,
            musicId: music.id,
          );
          expect(updatedLevel.id, level.id);
          expect(updatedLevel.musicId, music.id);
        },
      );

      test(
        '.setName',
        () async {
          final level =
              await customLevelsDao.createCustomLevel(name: 'Level 1');
          var updatedLevel = await customLevelsDao.setName(
            customLevelId: level.id,
            name: 'Level 2',
          );
          expect(updatedLevel.id, level.id);
          expect(updatedLevel.name, 'Level 2');
          updatedLevel = await customLevelsDao.setName(
            customLevelId: level.id,
            name: 'Level 3',
          );
          expect(updatedLevel.id, level.id);
          expect(updatedLevel.name, 'Level 3');
        },
      );

      test(
        '.deleteCustomLevel',
        () async {
          final level = await customLevelsDao.createCustomLevel(
            name: 'Testing Delete',
          );
          expect(await customLevelsDao.deleteCustomLevel(id: level.id), 1);
          await expectLater(
            customLevelsDao.getCustomLevel(id: level.id),
            throwsStateError,
          );
        },
      );

      test(
        '.getCustomLevelCommands',
        () async {
          final commandTrigger = await commandTriggersDao.createCommandTrigger(
            description: 'Test',
          );
          final level = await customLevelsDao.createCustomLevel(name: 'Test');
          final command1 =
              await customLevelCommandsDao.createCustomLevelCommand(
            customLevelId: level.id,
            commandTriggerId: commandTrigger.id,
          );
          final command2 =
              await customLevelCommandsDao.createCustomLevelCommand(
            customLevelId: level.id,
            commandTriggerId: commandTrigger.id,
          );
          final commands = await customLevelsDao.getCustomLevelCommands(
            customLevelId: level.id,
          );
          expect(commands.length, 2);
          expect(commands.first.id, command1.id);
          expect(commands.last.id, command2.id);
        },
      );

      test(
        '.getCustomLevels',
        () async {
          await db.delete(db.customLevels).go();
          final level2 =
              await customLevelsDao.createCustomLevel(name: 'Level 2');
          final level1 =
              await customLevelsDao.createCustomLevel(name: 'Level 1');
          final levels = await customLevelsDao.getCustomLevels();
          expect(levels.length, 2);
          expect(levels.first.id, level1.id);
          expect(levels.last.id, level2.id);
        },
      );
    },
  );
}
