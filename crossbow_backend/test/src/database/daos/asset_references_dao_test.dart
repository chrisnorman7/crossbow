import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

Future<void> main() async {
  final db = getDatabase();

  group(
    'AssetReferencesDao',
    () {
      final assetReferencesDao = db.assetReferencesDao;

      test(
        '.createAssetReference',
        () async {
          final assetReference = await assetReferencesDao.createAssetReference(
            folderName: 'music',
            name: 'main_theme.mp3',
          );
          expect(assetReference.folderName, 'music');
          expect(assetReference.id, isNonZero);
          expect(assetReference.name, 'main_theme.mp3');
          expect(assetReference.gain, 0.7);
          expect(assetReference.detached, false);
        },
      );

      test(
        '.getAssetReference',
        () async {
          final assetReference = await assetReferencesDao.createAssetReference(
            folderName: 'folder',
            name: 'filename',
            gain: 1.0,
          );
          expect(
            await assetReferencesDao.getAssetReference(id: assetReference.id),
            predicate<AssetReference>(
              (final value) =>
                  value.folderName == assetReference.folderName &&
                  value.gain == assetReference.gain &&
                  value.id == assetReference.id &&
                  value.name == assetReference.name,
            ),
          );
        },
      );

      test(
        '.getDetachedAssetReference',
        () async {
          const name = 'testing.mp3';
          const folderName = 'test_folder';
          expect(
            await assetReferencesDao.getDetachedAssetReference(
              folderName: folderName,
              name: name,
            ),
            isNull,
          );
          final assetReference = await assetReferencesDao.createAssetReference(
            folderName: folderName,
            name: name,
            gain: 1.5,
            detached: true,
          );
          final retrievedAssetReference =
              await assetReferencesDao.getDetachedAssetReference(
            folderName: folderName,
            name: name,
          );
          expect(retrievedAssetReference!.detached, true);
          expect(retrievedAssetReference.folderName, folderName);
          expect(retrievedAssetReference.gain, assetReference.gain);
          expect(retrievedAssetReference.id, assetReference.id);
          expect(retrievedAssetReference.name, assetReference.name);
        },
      );

      test(
        '.editAssetReference',
        () async {
          final assetReference = await assetReferencesDao.createAssetReference(
            folderName: 'music',
            name: 'theme.mp3',
          );
          final music = await assetReferencesDao.editAssetReference(
            assetReference: assetReference,
            folderName: 'themes',
            name: 'john_theme.mp3',
          );
          expect(music.folderName, 'themes');
          expect(music.id, assetReference.id);
          expect(music.name, 'john_theme.mp3');
        },
      );

      test(
        '.setGain',
        () async {
          final assetReference = await assetReferencesDao.createAssetReference(
            folderName: 'test',
            name: 'test',
            gain: 1.0,
          );
          expect(assetReference.gain, 1.0);
          final updatedAssetReference = await assetReferencesDao.setGain(
            assetReference: assetReference,
            gain: 0.5,
          );
          expect(updatedAssetReference.folderName, assetReference.folderName);
          expect(updatedAssetReference.gain, 0.5);
          expect(updatedAssetReference.name, assetReference.name);
        },
      );

      test(
        '.deleteAssetReference',
        () async {
          final assetReference = await assetReferencesDao.createAssetReference(
            folderName: 'folder',
            name: 'name',
          );
          expect(
            await assetReferencesDao.deleteAssetReference(
              assetReference: assetReference,
            ),
            1,
          );
          await expectLater(
            assetReferencesDao.getAssetReference(id: assetReference.id),
            throwsStateError,
          );
        },
      );

      test(
        '.getAssetReferencesInFolder',
        () async {
          const folderName = 'lovely_folder_with_a_hopefully_random_name';
          final assets = [
            for (var i = 0; i < 10; i++)
              await assetReferencesDao.createAssetReference(
                folderName: folderName,
                name: '$i.mp3',
              )
          ];
          final retrievedAssets =
              await assetReferencesDao.getAssetReferencesInFolder(folderName);
          expect(retrievedAssets.length, assets.length);
          for (var i = 0; i < assets.length; i++) {
            expect(assets[i], retrievedAssets[i]);
          }
        },
      );

      test(
        '.setVariableName',
        () async {
          final assetReference = await assetReferencesDao.createAssetReference(
            folderName: 'folder',
            name: 'file',
          );
          expect(assetReference.variableName, null);
          final updatedAssetReference =
              await assetReferencesDao.setVariableName(
            assetReference: assetReference,
            variableName: 'asset',
          );
          expect(updatedAssetReference.id, assetReference.id);
          expect(updatedAssetReference.variableName, 'asset');
        },
      );
    },
  );
}
