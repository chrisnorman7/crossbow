import 'package:drift/drift.dart';

import 'asset_references.dart';
import 'mixins.dart';

/// A reverb setting.
class Reverbs extends Table with WithPrimaryKey, WithName, WithVariableName {
  /// The ID of a sound to test this reverb with.
  IntColumn get testSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.setDefault)
      .nullable()();

  /// Gain.
  RealColumn get gain => real().withDefault(const Constant(0.7))();

  /// Late reflections delay.
  RealColumn get lateReflectionsDelay =>
      real().withDefault(const Constant(0.03))();

  /// Late reflections diffusion.
  RealColumn get lateReflectionsDiffusion =>
      real().withDefault(const Constant(1.0))();

  /// Late reflections hf reference.
  RealColumn get lateReflectionsHfReference =>
      real().withDefault(const Constant(500.0))();

  /// Late reflections hf rolloff.
  RealColumn get lateReflectionsHfRolloff =>
      real().withDefault(const Constant(0.5))();

  /// Late reflections lf reference.
  RealColumn get lateReflectionsLfReference =>
      real().withDefault(const Constant(200.0))();

  /// Late reflections lf rolloff.
  RealColumn get lateReflectionsLfRolloff =>
      real().withDefault(const Constant(1.0))();

  /// Late reflections modulation depth.
  RealColumn get lateReflectionsModulationDepth =>
      real().withDefault(const Constant(0.01))();

  /// Late reflections modulation frequency.
  RealColumn get lateReflectionsModulationFrequency =>
      real().withDefault(const Constant(0.5))();

  /// Mean free path.
  RealColumn get meanFreePath => real().withDefault(const Constant(0.1))();

  /// T60.
  RealColumn get t60 => real().withDefault(const Constant(0.3))();
}
