import 'dart:io';
import 'dart:math';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:ziggurat/sound.dart' as ziggurat_sound;
import 'package:ziggurat/ziggurat.dart' as ziggurat;

import 'custom_database.dart';

void main() async {
  final db = getDatabase();
  final clink = await db.assetReferencesDao.createAssetReference(
    folderName: 'interface',
    name: 'clink.wav',
    gain: 1.0,
  );
  final boots = await db.assetReferencesDao.createAssetReference(
    folderName: 'footsteps',
    name: 'boots',
    gain: 0.5,
  );
  final command = await db.commandsDao.createCommand(messageSoundId: clink.id);
  final project = Project(
    projectName: 'Test Project',
    initialCommandId: command.id,
    assetsDirectory: 'test_assets',
  );
  final projectContext =
      ProjectContext(file: File('project.json'), project: project, db: db);
  group(
    'ProjectRunner',
    () {
      final synthizer = Synthizer()..initialize();
      final context = synthizer.createContext();
      final random = Random();
      final bufferCache = ziggurat_sound.BufferCache(
        maxSize: 1.gb,
        random: random,
        synthizer: synthizer,
      );
      final soundBackend = ziggurat_sound.SynthizerSoundBackend(
        context: context,
        bufferCache: bufferCache,
      );
      final sdl = Sdl();
      final projectRunner = ProjectRunner(
        projectContext: projectContext,
        sdl: sdl,
        synthizerContext: context,
        random: random,
        soundBackend: soundBackend,
      );

      tearDownAll(() {
        bufferCache.destroy();
        context.destroy();
        synthizer.shutdown();
      });

      test(
        '.getAssetReference',
        () async {
          var assetReference = projectRunner.getAssetReference(clink);
          expect(assetReference.encryptionKey, null);
          expect(assetReference.gain, clink.gain);
          expect(
            assetReference.name,
            path.join(
              projectContext.assetsDirectory.path,
              clink.folderName,
              clink.name,
            ),
          );
          expect(assetReference.type, ziggurat.AssetType.file);
          expect(assetReference.getFile(random).existsSync(), true);
          assetReference = projectRunner.getAssetReference(boots);
          expect(
            assetReference.name,
            path.join(
              projectContext.assetsDirectory.path,
              boots.folderName,
              boots.name,
            ),
          );
          expect(assetReference.gain, boots.gain);
          expect(assetReference.type, ziggurat.AssetType.collection);
          expect(
            assetReference.getFile(random).path,
            path.join(
              projectContext.assetsDirectory.path,
              boots.folderName,
              boots.name,
              'readme.txt',
            ),
          );
        },
      );
    },
  );
}
