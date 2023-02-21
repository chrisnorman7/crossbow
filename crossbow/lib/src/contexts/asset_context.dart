import 'package:crossbow_backend/database.dart';

/// A context which holds a [folderName] and a [name], and can be used for
/// creating and editing [AssetReference]s.
class AssetContext {
  /// Create an instance.
  const AssetContext({
    required this.folderName,
    required this.name,
  });

  /// The folder name.
  final String folderName;

  /// The name of the entity inside [folderName].
  final String name;
}
