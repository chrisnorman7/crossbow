import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';
import 'package:ziggurat/sound.dart';

/// Check that the given [Music] is using the asset reference with the given
/// [assetReferenceId].
Future<void> testMusic({
  required final ProjectRunner projectRunner,
  required final int assetReferenceId,
  required final Music music,
}) async {
  final assetReference = await projectRunner.db.assetReferencesDao
      .getAssetReference(id: assetReferenceId);
  final sound = projectRunner.getAssetReference(assetReference);
  expect(music.gain, sound.gain);
  expect(music.sound.encryptionKey, sound.encryptionKey);
  expect(music.sound.gain, sound.gain);
  expect(music.sound.name, sound.name);
  expect(music.sound.type, sound.type);
}
