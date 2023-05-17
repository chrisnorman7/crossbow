import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';
import 'package:ziggurat/ziggurat.dart' as ziggurat;

/// Check that the given [music] is using the asset reference with the given
/// [assetReferenceId].
Future<void> testMusic({
  required final ProjectRunner projectRunner,
  required final int assetReferenceId,
  required final ziggurat.AssetReference music,
}) async {
  final assetReference = await projectRunner.db.assetReferencesDao
      .getAssetReference(id: assetReferenceId);
  final sound = projectRunner.getAssetReference(assetReference);
  expect(music.gain, sound.gain);
  expect(music.encryptionKey, sound.encryptionKey);
  expect(music.gain, sound.gain);
  expect(music.name, sound.name);
  expect(music.type, sound.type);
}
