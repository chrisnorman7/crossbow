import 'package:test/test.dart';
import 'package:ziggurat/sound.dart';

import '../../../common.dart';
import '../../../custom_database.dart';

void main() {
  group(
    'ReverbsDao',
    () {
      final db = getDatabase();
      final reverbsDao = db.reverbsDao;
      final assetReferencesDao = db.assetReferencesDao;

      test(
        '.createReverb',
        () async {
          final reverb = await reverbsDao.createReverb('Test Reverb');
          expect(reverb.name, 'Test Reverb');
          expect(reverb.testSoundId, null);
        },
      );

      test(
        '.getReverb',
        () async {
          final reverb = await reverbsDao.createReverb(newId());
          expect(await reverbsDao.getReverb(reverb.id), reverb);
          await expectLater(
            reverbsDao.getReverb(reverb.id + 1),
            throwsStateError,
          );
        },
      );

      test(
        '.updateReverb',
        () async {
          final reverb = await reverbsDao.createReverb(newId());
          for (var i = 0; i < 10; i++) {
            final reverbPreset = ReverbPreset(
              gain: random.nextDouble(),
              lateReflectionsDelay: random.nextDouble(),
              lateReflectionsDiffusion: random.nextDouble(),
              lateReflectionsHfReference: random.nextDouble(),
              lateReflectionsHfRolloff: random.nextDouble(),
              lateReflectionsLfReference: random.nextDouble(),
              lateReflectionsLfRolloff: random.nextDouble(),
              lateReflectionsModulationDepth: random.nextDouble(),
              lateReflectionsModulationFrequency: random.nextDouble(),
              meanFreePath: random.nextDouble(),
              name: newId(),
              t60: random.nextDouble(),
            );
            final updatedReverb = await reverbsDao.updateReverb(
              reverb: reverb,
              gain: reverbPreset.gain,
              lateReflectionsDelay: reverbPreset.lateReflectionsDelay,
              lateReflectionsDiffusion: reverbPreset.lateReflectionsDiffusion,
              lateReflectionsHfReference:
                  reverbPreset.lateReflectionsHfReference,
              lateReflectionsHfRolloff: reverbPreset.lateReflectionsHfRolloff,
              lateReflectionsLfReference:
                  reverbPreset.lateReflectionsLfReference,
              lateReflectionsLfRolloff: reverbPreset.lateReflectionsLfRolloff,
              lateReflectionsModulationDepth:
                  reverbPreset.lateReflectionsModulationDepth,
              lateReflectionsModulationFrequency:
                  reverbPreset.lateReflectionsModulationFrequency,
              meanFreePath: reverbPreset.meanFreePath,
              name: reverbPreset.name,
              t60: reverbPreset.t60,
            );
            expect(updatedReverb.gain, reverbPreset.gain);
            expect(updatedReverb.id, reverb.id);
            expect(
              updatedReverb.lateReflectionsDelay,
              reverbPreset.lateReflectionsDelay,
            );
            expect(
              updatedReverb.lateReflectionsDiffusion,
              reverbPreset.lateReflectionsDiffusion,
            );
            expect(
              updatedReverb.lateReflectionsHfReference,
              reverbPreset.lateReflectionsHfReference,
            );
            expect(
              updatedReverb.lateReflectionsHfRolloff,
              reverbPreset.lateReflectionsHfRolloff,
            );
            expect(
              updatedReverb.lateReflectionsLfReference,
              reverbPreset.lateReflectionsLfReference,
            );
            expect(
              updatedReverb.lateReflectionsLfRolloff,
              reverbPreset.lateReflectionsLfRolloff,
            );
            expect(
              updatedReverb.lateReflectionsModulationDepth,
              reverbPreset.lateReflectionsModulationDepth,
            );
            expect(
              updatedReverb.lateReflectionsModulationFrequency,
              reverbPreset.lateReflectionsModulationFrequency,
            );
            expect(updatedReverb.meanFreePath, reverbPreset.meanFreePath);
            expect(updatedReverb.name, reverbPreset.name);
            expect(updatedReverb.t60, reverbPreset.t60);
          }
        },
      );

      test(
        '.deleteReverb',
        () async {
          final reverb = await reverbsDao.createReverb(newId());
          expect(await reverbsDao.deleteReverb(reverb), 1);
          await expectLater(reverbsDao.getReverb(reverb.id), throwsStateError);
          expect(await reverbsDao.deleteReverb(reverb), 0);
        },
      );

      test(
        '.getReverbs',
        () async {
          await db.delete(db.reverbs).go();
          final reverbs = [
            for (var i = 0; i < 10; i++) await reverbsDao.createReverb(newId())
          ];
          expect(await reverbsDao.getReverbs(), reverbs);
        },
      );

      test(
        '.setTestSound',
        () async {
          final reverb = await reverbsDao.createReverb(newId());
          for (var i = 0; i < 10; i++) {
            final hasSound = random.nextBool();
            final testSound = hasSound
                ? await assetReferencesDao.createAssetReference(
                    folderName: newId(),
                    name: newId(),
                    gain: random.nextDouble(),
                  )
                : null;
            final updatedReverb = await reverbsDao.setTestSound(
              reverb: reverb,
              testSound: testSound,
            );
            expect(updatedReverb.id, reverb.id);
            expect(updatedReverb.testSoundId, testSound?.id);
          }
        },
      );

      test(
        '.setVariableName',
        () async {
          final reverb = await reverbsDao.createReverb(newId());
          expect(reverb.variableName, null);
          for (var i = 0; i < 10; i++) {
            final variableName = random.nextBool() ? newId() : null;
            final updatedReverb = await reverbsDao.setVariableName(
              reverb: reverb,
              variableName: variableName,
            );
            expect(updatedReverb.id, reverb.id);
            expect(updatedReverb.variableName, variableName);
          }
        },
      );
    },
  );
}
