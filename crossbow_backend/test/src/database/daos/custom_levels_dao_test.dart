import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'CustomLevelsDao',
    () {
      final db = getDatabase();
      final customLevelsDao = db.customLevelsDao;

      test(
        '.createCustomLevel',
        () async {
          final level = await customLevelsDao.createCustomLevel(
            name: 'Test Level',
          );
          expect(level.id, isNonZero);
          expect(level.name, 'Test Level');
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
    },
  );
}
