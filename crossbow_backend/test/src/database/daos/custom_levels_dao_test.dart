import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'CustomLevelsDao',
    () {
      final db = getDatabase();
      final customLevelsDao = db.customLevelsDao;
      final assetReferencesDao = db.assetReferencesDao;

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
    },
  );
}
