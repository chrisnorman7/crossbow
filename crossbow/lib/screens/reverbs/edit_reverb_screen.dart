import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ziggurat/sound.dart';

import '../../hotkeys.dart';
import '../../messages.dart';
import '../../src/providers.dart';
import '../../widgets/asset_reference_list_tile.dart';
import '../../widgets/variable_name_list_tile.dart';
import 'reverb_setting.dart';
import 'reverb_setting_list_tile.dart';

final _synthizerReverbUrl = Uri.parse(
  'https://synthizer.github.io/object_reference/global_fdn_reverb.html',
);
final _meanFreePathSetting = ReverbSetting(
  name: Intl.message('The mean free path of the simulated environment'),
  defaultValue: 0.1,
  min: 0.0,
  max: 0.5,
  modify: 0.01,
);
final _t60Setting = ReverbSetting(
  name: Intl.message('T60'),
  defaultValue: 0.3,
  min: 0.0,
  max: 100.0,
  modify: 1.0,
);
final _lateReflectionsLfRolloffSetting = ReverbSetting(
  name: Intl.message('Multiplicative factor on T60 for the low frequency band'),
  defaultValue: 1.0,
  min: 0.0,
  max: 2.0,
);
final _lateReflectionsLfReferenceSetting = ReverbSetting(
  name: Intl.message('Where the low band of the feedback equalizer ends'),
  defaultValue: 200.0,
  min: 0.0,
  max: 22050.0,
  modify: 1000.0,
);
final _lateReflectionsHfRolloffSetting = ReverbSetting(
  name: Intl.message(
    'Multiplicative factor on T60 for the high frequency band',
  ),
  defaultValue: 0.5,
  min: 0.0,
  max: 2.0,
);
final _lateReflectionsHfReferenceSetting = ReverbSetting(
  name: Intl.message('Where the high band of the equalizer starts'),
  defaultValue: 500.0,
  min: 0.0,
  max: 22050.0,
  modify: 1000.0,
);
final _lateReflectionsDiffusionSetting = ReverbSetting(
  name: Intl.message(
    'Controls the diffusion of the late reflections as a percent',
  ),
  defaultValue: 1.0,
  min: 0.0,
  max: 1.0,
);
final _lateReflectionsModulationDepthSetting = ReverbSetting(
  name: Intl.message(
      'Depth of the modulation of the delay lines on the feedback path in '
      'seconds'),
  defaultValue: 0.01,
  min: 0.0,
  max: 0.3,
);
final _lateReflectionsModulationFrequencySetting = ReverbSetting(
  name: Intl.message(
    'Frequency of the modulation of the delay lines int he feedback paths',
  ),
  defaultValue: 0.5,
  min: 0.01,
  max: 100.0,
  modify: 5.0,
);
final _lateReflectionsDelaySetting = ReverbSetting(
  name: Intl.message(
    'The delay of the late reflections relative to the input in seconds',
  ),
  defaultValue: 0.03,
  min: 0.0,
  max: 0.5,
  modify: 0.001,
);
final _gainSetting = ReverbSetting(
  name: Intl.message('Gain'),
  defaultValue: 0.7,
  min: 0.0,
  max: 5.0,
  modify: 0.25,
);

/// A screen for editing a [reverbId].
class EditReverbScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const EditReverbScreen({
    required this.reverbId,
    super.key,
  });

  /// The ID of the reverb to edit.
  final int reverbId;

  /// Create state for this widget.
  @override
  EditReverbScreenState createState() => EditReverbScreenState();
}

/// State for [EditReverbScreen].
class EditReverbScreenState extends ConsumerState<EditReverbScreen> {
  /// The test sound.
  Sound? sound;

  /// The reverb to use.
  BackendReverb? _reverb;

  /// The sound channel to use.
  SoundChannel? _soundChannel;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final gameValue = ref.watch(gameProvider);
    return Cancel(
      child: gameValue.when(
        data: (final game) {
          var soundChannel = _soundChannel;
          var reverbSend = _reverb;
          final soundBackend = game.soundBackend;
          if (soundChannel == null) {
            soundChannel = soundBackend.createSoundChannel();
            _soundChannel = soundChannel;
          }
          if (reverbSend == null) {
            reverbSend = soundBackend.createReverb(
              const ReverbPreset(name: 'Irrelevant'),
            );
            _reverb = reverbSend;
            soundChannel.addReverb(reverb: reverbSend);
          }
          final reverbValue = ref.watch(reverbProvider.call(widget.reverbId));
          return reverbValue.when(
            data: (final data) {
              final reverb = data.value;
              reverbSend!.setPreset(
                ReverbPreset(
                  name: reverb.name,
                  gain: reverb.gain,
                  lateReflectionsDelay: reverb.lateReflectionsDelay,
                  lateReflectionsDiffusion: reverb.lateReflectionsDiffusion,
                  lateReflectionsHfReference: reverb.lateReflectionsHfReference,
                  lateReflectionsHfRolloff: reverb.lateReflectionsHfRolloff,
                  lateReflectionsLfReference: reverb.lateReflectionsLfReference,
                  lateReflectionsLfRolloff: reverb.lateReflectionsLfRolloff,
                  lateReflectionsModulationDepth:
                      reverb.lateReflectionsModulationDepth,
                  lateReflectionsModulationFrequency:
                      reverb.lateReflectionsModulationFrequency,
                  meanFreePath: reverb.meanFreePath,
                  t60: reverb.t60,
                ),
              );
              final reverbsDao = data.projectContext.db.reverbsDao;
              return CallbackShortcuts(
                bindings: {
                  playPauseHotkey: () =>
                      playPause(ref: ref, soundChannel: soundChannel!)
                },
                child: SimpleScaffold(
                  title: Intl.message('Edit Reverb'),
                  actions: [
                    TextButton(
                      onPressed: () => launchUrl(_synthizerReverbUrl),
                      child: Text(Intl.message('Synthizer Reverb Docs')),
                    ),
                    IconButton(
                      onPressed: reverb.testSoundId == null
                          ? null
                          : () => playPause(
                                ref: ref,
                                soundChannel: soundChannel!,
                              ),
                      icon: Icon(
                        sound == null
                            ? Icons.play_circle_rounded
                            : Icons.stop_circle_rounded,
                        semanticLabel:
                            sound == null ? playMessage : stopMessage,
                      ),
                    )
                  ],
                  body: ListView(
                    children: [
                      AssetReferenceListTile(
                        assetReferenceId: reverb.testSoundId,
                        onChanged: (final value) async {
                          await reverbsDao.setTestSound(
                            reverb: reverb,
                            testSound: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        nullable: true,
                        title: Intl.message('Test Sound'),
                      ),
                      TextListTile(
                        value: reverb.name,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            name: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        header: Intl.message('Name'),
                        autofocus: true,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _meanFreePathSetting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            meanFreePath: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.meanFreePath,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _t60Setting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            t60: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.t60,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _lateReflectionsLfRolloffSetting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            lateReflectionsLfRolloff: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.lateReflectionsLfRolloff,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _lateReflectionsLfReferenceSetting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            lateReflectionsLfReference: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.lateReflectionsLfReference,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _lateReflectionsHfRolloffSetting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            lateReflectionsHfRolloff: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.lateReflectionsHfRolloff,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _lateReflectionsHfReferenceSetting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            lateReflectionsHfReference: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.lateReflectionsHfReference,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _lateReflectionsHfRolloffSetting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            lateReflectionsHfRolloff: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.lateReflectionsHfRolloff,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _lateReflectionsDiffusionSetting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            lateReflectionsDiffusion: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.lateReflectionsDiffusion,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _lateReflectionsModulationDepthSetting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            lateReflectionsModulationDepth: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.lateReflectionsModulationDepth,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _lateReflectionsModulationFrequencySetting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            lateReflectionsModulationFrequency: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.lateReflectionsModulationFrequency,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _lateReflectionsDelaySetting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            lateReflectionsDelay: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.lateReflectionsDelay,
                      ),
                      ReverbSettingListTile(
                        reverbId: reverb.id,
                        setting: _gainSetting,
                        onChanged: (final value) async {
                          await reverbsDao.updateReverb(
                            reverb: reverb,
                            gain: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                        value: reverb.gain,
                      ),
                      VariableNameListTile(
                        variableName: reverb.variableName,
                        getOtherVariableNames: () async {
                          final reverbs = await reverbsDao.getReverbs();
                          return reverbs
                              .map((final e) => e.variableName ?? unsetMessage)
                              .toList();
                        },
                        onChanged: (final value) async {
                          await reverbsDao.setVariableName(
                            reverb: reverb,
                            variableName: value,
                          );
                          invalidateReverbProvider(ref);
                        },
                      )
                    ],
                  ),
                ),
              );
            },
            error: ErrorListView.withPositional,
            loading: LoadingWidget.new,
          );
        },
        error: ErrorScreen.withPositional,
        loading: LoadingScreen.new,
      ),
    );
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _soundChannel?.destroy();
    _reverb?.destroy();
    sound?.destroy();
  }

  /// Invalidate the [reverbProvider].
  void invalidateReverbProvider(final WidgetRef ref) => ref
    ..invalidate(reverbsProvider)
    ..invalidate(reverbProvider.call(widget.reverbId));

  /// Play or pause the reverb.
  Future<void> playPause({
    required final WidgetRef ref,
    required final SoundChannel soundChannel,
  }) async {
    if (sound != null) {
      sound?.destroy();
      setState(() {
        sound = null;
      });
      return;
    }
    final reverbContext = await ref.watch(
      reverbProvider.call(widget.reverbId).future,
    );
    final reverb = reverbContext.value;
    final projectContext = reverbContext.projectContext;
    final assetReferencesDao = projectContext.db.assetReferencesDao;
    final testSoundId = reverb.testSoundId;
    if (testSoundId == null) {
      return;
    }
    final testSound = await assetReferencesDao.getAssetReference(
      id: testSoundId,
    );
    final runner = (await ref.watch(projectRunnerProvider.future))!;
    sound = soundChannel.playSound(
      assetReference: runner.getAssetReference(testSound),
      keepAlive: true,
      looping: true,
    );
    setState(() {});
  }
}
