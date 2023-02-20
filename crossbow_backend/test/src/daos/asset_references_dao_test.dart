import 'package:test/test.dart';

import '../../custom_database.dart';

Future<void> main() async {
  final db = getDatabase();

  group(
    'AssetReferencesDao',
    () {
      final assetReferences = db.assetReferencesDao;

      test(
        '.createAssetReference',
        () async {
          final assetReference = await assetReferences.createAssetReference(
            folderName: 'music',
            name: 'main_theme.mp3',
          );
          expect(assetReference.folderName, 'music');
          expect(assetReference.id, isNonZero);
          expect(assetReference.name, 'main_theme.mp3');
        },
      );

      test(
        '.editAssetReference',
        () async {
          final assetReference = await assetReferences.createAssetReference(
            folderName: 'music',
            name: 'theme.mp3',
          );
          final music = await assetReferences.editAssetReference(
            assetReferenceId: assetReference.id,
            folderName: 'themes',
            name: 'john_theme.mp3',
          );
          expect(music.folderName, 'themes');
          expect(music.id, assetReference.id);
          expect(music.name, 'john_theme.mp3');
        },
      );
    },
  );
}