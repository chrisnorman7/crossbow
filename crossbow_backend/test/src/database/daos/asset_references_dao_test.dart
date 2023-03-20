import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

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
          expect(assetReference.gain, 0.7);
          expect(assetReference.detached, false);
        },
      );

      test(
        '.getAssetReference',
        () async {
          final assetReference = await assetReferences.createAssetReference(
            folderName: 'folder',
            name: 'filename',
            gain: 1.0,
          );
          expect(
            await assetReferences.getAssetReference(id: assetReference.id),
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
            await assetReferences.getDetachedAssetReference(
              folderName: folderName,
              name: name,
            ),
            isNull,
          );
          final assetReference = await assetReferences.createAssetReference(
            folderName: folderName,
            name: name,
            gain: 1.5,
            detached: true,
          );
          final retrievedAssetReference =
              await assetReferences.getDetachedAssetReference(
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

      test(
        '.setGain',
        () async {
          final assetReference = await assetReferences.createAssetReference(
            folderName: 'test',
            name: 'test',
            gain: 1.0,
          );
          expect(assetReference.gain, 1.0);
          final updatedAssetReference = await assetReferences.setGain(
            assetReferenceId: assetReference.id,
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
          final assetReference = await assetReferences.createAssetReference(
            folderName: 'folder',
            name: 'name',
          );
          expect(
            await assetReferences.deleteAssetReference(id: assetReference.id),
            1,
          );
          await expectLater(
            assetReferences.getAssetReference(id: assetReference.id),
            throwsStateError,
          );
        },
      );
    },
  );
}
