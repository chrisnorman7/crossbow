import 'package:drift/drift.dart';

import '../../../crossbow_backend.dart';

part 'reverbs_dao.g.dart';

/// The reverbs DAO.
@DriftAccessor(tables: [Reverbs])
class ReverbsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$ReverbsDaoMixin {
  /// Create an instance.
  ReverbsDao(super.db);

  /// Create a reverb.
  Future<Reverb> createReverb(final String name) =>
      into(reverbs).insertReturning(ReverbsCompanion(name: Value(name)));

  /// Get the reverb with the given [id].
  Future<Reverb> getReverb(final int id) async =>
      (select(reverbs)..where((final table) => table.id.equals(id)))
          .getSingle();

  /// Get an [update] query that matches [reverb].
  UpdateStatement<$ReverbsTable, Reverb> getUpdateQuery(final Reverb reverb) =>
      update(reverbs)..where((final table) => table.id.equals(reverb.id));

  /// Update [reverb].
  Future<Reverb> updateReverb({
    required final Reverb reverb,
    final double? gain,
    final double? lateReflectionsDelay,
    final double? lateReflectionsDiffusion,
    final double? lateReflectionsHfReference,
    final double? lateReflectionsHfRolloff,
    final double? lateReflectionsLfReference,
    final double? lateReflectionsLfRolloff,
    final double? lateReflectionsModulationDepth,
    final double? lateReflectionsModulationFrequency,
    final double? meanFreePath,
    final String? name,
    final double? t60,
  }) async =>
      (await getUpdateQuery(reverb).writeReturning(
        ReverbsCompanion(
          gain: Value(gain ?? reverb.gain),
          lateReflectionsDelay:
              Value(lateReflectionsDelay ?? reverb.lateReflectionsDelay),
          lateReflectionsDiffusion: Value(
            lateReflectionsDiffusion ?? reverb.lateReflectionsDiffusion,
          ),
          lateReflectionsHfReference: Value(
            lateReflectionsHfReference ?? reverb.lateReflectionsHfReference,
          ),
          lateReflectionsHfRolloff: Value(
            lateReflectionsHfRolloff ?? reverb.lateReflectionsHfRolloff,
          ),
          lateReflectionsLfReference: Value(
            lateReflectionsLfReference ?? reverb.lateReflectionsLfReference,
          ),
          lateReflectionsLfRolloff: Value(
            lateReflectionsLfRolloff ?? reverb.lateReflectionsLfRolloff,
          ),
          lateReflectionsModulationDepth: Value(
            lateReflectionsModulationDepth ??
                reverb.lateReflectionsModulationDepth,
          ),
          lateReflectionsModulationFrequency: Value(
            lateReflectionsModulationFrequency ??
                reverb.lateReflectionsModulationFrequency,
          ),
          meanFreePath: Value(meanFreePath ?? reverb.meanFreePath),
          name: Value(name ?? reverb.name),
          t60: Value(t60 ?? reverb.t60),
        ),
      ))
          .single;

  /// Delete [reverb].
  Future<int> deleteReverb(final Reverb reverb) async =>
      (delete(reverbs)..where((final table) => table.id.equals(reverb.id)))
          .go();

  /// Get all reverbs in the database.
  Future<List<Reverb>> getReverbs() => select(reverbs).get();

  /// Set [testSound] for [reverb].
  Future<Reverb> setTestSound({
    required final Reverb reverb,
    final AssetReference? testSound,
  }) async =>
      (await getUpdateQuery(reverb).writeReturning(
        ReverbsCompanion(testSoundId: Value(testSound?.id)),
      ))
          .single;

  /// Set the [variableName] for [reverb].
  Future<Reverb> setVariableName({
    required final Reverb reverb,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(reverb).writeReturning(
        ReverbsCompanion(variableName: Value(variableName)),
      ))
          .single;
}
