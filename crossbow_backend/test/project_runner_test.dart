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
  final assetReferencesDao = db.assetReferencesDao;
  final commandsDao = db.commandsDao;
  final callCommandsDao = db.callCommandsDao;
  final clink = await assetReferencesDao.createAssetReference(
    folderName: 'interface',
    name: 'clink.wav',
    gain: 1.0,
  );
  final boots = await assetReferencesDao.createAssetReference(
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
  final projectContext = ProjectContext(
    file: File('project.json'),
    project: project,
    db: db,
    assetReferenceEncryptionKeys: {
      boots.id: 'asdf123',
    },
  );
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
          expect(assetReference.encryptionKey, 'asdf123');
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

      test(
        '.callCommandShouldRun',
        () async {
          final command = await commandsDao.createCommand();
          var callCommand = await callCommandsDao.createCallCommand(
            commandId: command.id,
            callingCommandId: command.id,
          );
          expect(await projectRunner.callCommandShouldRun(callCommand), true);
          callCommand = await callCommandsDao.setRandomNumberBase(
            callCommandId: callCommand.id,
            randomNumberBase: 1,
          );
          // Now the random number generator will always return `0`, so the
          // command should always run.
          expect(await projectRunner.callCommandShouldRun(callCommand), true);
        },
      );
    },
  );
}
