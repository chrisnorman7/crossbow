import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../messages.dart';
import '../../src/providers.dart';
import '../../widgets/variable_name_list_tile.dart';
import 'reverb_setting.dart';
import 'reverb_setting_list_tile.dart';

final _synthizerReverbUrl = Uri.parse(
  'https://synthizer.github.io/object_reference/global_fdn_reverb.html',
);
const _meanFreePathSetting = ReverbSetting(
  name: 'The mean free path of the simulated environment',
  defaultValue: 0.1,
  min: 0.0,
  max: 0.5,
  modify: 0.01,
);
const _t60Setting = ReverbSetting(
  name: 'T60',
  defaultValue: 0.3,
  min: 0.0,
  max: 100.0,
  modify: 1.0,
);
const _lateReflectionsLfRolloffSetting = ReverbSetting(
  name: 'Multiplicative factor on T60 for the low frequency band',
  defaultValue: 1.0,
  min: 0.0,
  max: 2.0,
);
const _lateReflectionsLfReferenceSetting = ReverbSetting(
  name: 'Where the low band of the feedback equalizer ends',
  defaultValue: 200.0,
  min: 0.0,
  max: 22050.0,
  modify: 1000.0,
);
const _lateReflectionsHfRolloffSetting = ReverbSetting(
  name: 'Multiplicative factor on T60 for the high frequency band',
  defaultValue: 0.5,
  min: 0.0,
  max: 2.0,
);
const _lateReflectionsHfReferenceSetting = ReverbSetting(
  name: 'Where the high band of the equalizer starts',
  defaultValue: 500.0,
  min: 0.0,
  max: 22050.0,
  modify: 1000.0,
);
const _lateReflectionsDiffusionSetting = ReverbSetting(
  name: 'Controls the diffusion of the late reflections as a percent',
  defaultValue: 1.0,
  min: 0.0,
  max: 1.0,
);
const _lateReflectionsModulationDepthSetting = ReverbSetting(
  name: 'Depth of the modulation of the delay lines on the feedback path in '
      'seconds',
  defaultValue: 0.01,
  min: 0.0,
  max: 0.3,
);
const _lateReflectionsModulationFrequencySetting = ReverbSetting(
  name: 'Frequency of the modulation of the delay lines int he feedback paths',
  defaultValue: 0.5,
  min: 0.01,
  max: 100.0,
  modify: 5.0,
);
const _lateReflectionsDelaySetting = ReverbSetting(
  name: 'The delay of the late reflections relative to the input in seconds',
  defaultValue: 0.03,
  min: 0.0,
  max: 0.5,
  modify: 0.001,
);
const _gainSetting = ReverbSetting(
  name: 'Gain',
  defaultValue: 0.7,
  min: 0.0,
  max: 5.0,
  modify: 0.25,
);

/// A screen for editing a [reverbId].
class EditRoomReverbScreen extends ConsumerWidget {
  /// Create an instance.
  const EditRoomReverbScreen({
    required this.reverbId,
    super.key,
  });

  /// The reverb to edit.
  final int reverbId;

  /// Build a widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(reverbProvider.call(reverbId));
    return Cancel(
      child: SimpleScaffold(
        title: Intl.message('Edit Reverb'),
        actions: [
          TextButton(
            onPressed: () => launchUrl(_synthizerReverbUrl),
            child: Text(Intl.message('Synthizer Reverb Docs')),
          )
        ],
        body: value.when(
          data: (final data) {
            final reverb = data.value;
            final reverbsDao = data.projectContext.db.reverbsDao;
            return ListView(
              children: [
                TextListTile(
                  value: reverb.name,
                  onChanged: (final value) async {
                    await reverbsDao.updateReverb(reverb: reverb, name: value);
                    invalidateReverbProvider(ref);
                  },
                  header: 'Name',
                  autofocus: true,
                ),
                ReverbSettingListTile(
                  reverbId: reverbId,
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
                  reverbId: reverbId,
                  setting: _t60Setting,
                  onChanged: (final value) async {
                    await reverbsDao.updateReverb(reverb: reverb, t60: value);
                    invalidateReverbProvider(ref);
                  },
                  value: reverb.t60,
                ),
                ReverbSettingListTile(
                  reverbId: reverbId,
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
                  reverbId: reverbId,
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
                  reverbId: reverbId,
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
                  reverbId: reverbId,
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
                  reverbId: reverbId,
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
                  reverbId: reverbId,
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
                  reverbId: reverbId,
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
                  reverbId: reverbId,
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
                  reverbId: reverbId,
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
                  reverbId: reverbId,
                  setting: _gainSetting,
                  onChanged: (final value) async {
                    await reverbsDao.updateReverb(reverb: reverb, gain: value);
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
            );
          },
          error: ErrorListView.withPositional,
          loading: LoadingWidget.new,
        ),
      ),
    );
  }

  /// Invalidate the [reverbProvider].
  void invalidateReverbProvider(final WidgetRef ref) => ref
    ..invalidate(reverbsProvider)
    ..invalidate(reverbProvider.call(reverbId));
}
