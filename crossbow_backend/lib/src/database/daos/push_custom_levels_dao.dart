import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/push_custom_levels.dart';

part 'push_custom_levels_dao.g.dart';

/// The push custom levels DAO.
@DriftAccessor(tables: [PushCustomLevels])
class PushCustomLevelsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$PushCustomLevelsDaoMixin {
  /// Create an instance.
  PushCustomLevelsDao(super.db);

  /// Create a new push custom level.
  Future<PushCustomLevel> createPushCustomLevel({
    required final int customLevelId,
    final int? after,
    final double? fadeTime,
  }) =>
      into(pushCustomLevels).insertReturning(
        PushCustomLevelsCompanion(
          after: Value(after),
          customLevelId: Value(customLevelId),
          fadeLength: Value(fadeTime),
        ),
      );
}
