import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/asset_references.dart';

part 'asset_references_dao.g.dart';

/// The asset references DAO.
@DriftAccessor(tables: [AssetReferences])
class AssetReferencesDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$AssetReferencesDaoMixin {
  /// Create an instance.
  AssetReferencesDao(super.db);

  /// Create an asset reference.
  Future<AssetReference> createAssetReference({
    required final String folderName,
    required final String name,
    final double gain = 0.7,
    final bool detached = false,
    final String? variableName,
  }) async =>
      into(assetReferences).insertReturning(
        AssetReferencesCompanion(
          folderName: Value(folderName),
          name: Value(name),
          gain: Value(gain),
          detached: Value(detached),
          variableName: Value(variableName),
        ),
      );

  /// Get the asset reference with the given [id].
  Future<AssetReference> getAssetReference({required final int id}) async {
    final query = select(assetReferences)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }

  /// Get the detached asset reference with the given [folderName], and [name].
  Future<AssetReference?> getDetachedAssetReference({
    required final String folderName,
    required final String name,
  }) =>
      (select(assetReferences)
            ..where(
              (final table) =>
                  table.folderName.equals(folderName) &
                  table.name.equals(name) &
                  table.detached.equals(true),
            ))
          .getSingleOrNull();

  /// Get an [update] query for the given [assetReference].
  UpdateStatement<$AssetReferencesTable, AssetReference> getUpdateQuery(
    final AssetReference assetReference,
  ) =>
      update(assetReferences)
        ..where((final table) => table.id.equals(assetReference.id));

  /// Edit [assetReference].
  Future<AssetReference> editAssetReference({
    required final AssetReference assetReference,
    required final String folderName,
    required final String name,
    final String? comment,
  }) async =>
      (await getUpdateQuery(assetReference).writeReturning(
        AssetReferencesCompanion(
          folderName: Value(folderName),
          name: Value(name),
          comment: Value(comment),
        ),
      ))
          .single;

  /// Set the [gain] for [assetReference].
  Future<AssetReference> setGain({
    required final AssetReference assetReference,
    required final double gain,
  }) async =>
      (await getUpdateQuery(assetReference)
              .writeReturning(AssetReferencesCompanion(gain: Value(gain))))
          .single;

  /// Delete [assetReference].
  Future<int> deleteAssetReference({
    required final AssetReference assetReference,
  }) async {
    final query = delete(assetReferences)
      ..where((final table) => table.id.equals(assetReference.id));
    return query.go();
  }

  /// Get all the assets in [folderName].
  Future<List<AssetReference>> getAssetReferencesInFolder(
    final String folderName,
  ) {
    final query = select(assetReferences)
      ..where((final table) => table.folderName.equals(folderName));
    return query.get();
  }

  /// Set the [variableName] for [assetReference].
  Future<AssetReference> setVariableName({
    required final AssetReference assetReference,
    final String? variableName,
  }) async =>
      (await getUpdateQuery(assetReference).writeReturning(
        AssetReferencesCompanion(variableName: Value(variableName)),
      ))
          .single;
}
