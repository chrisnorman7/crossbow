import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/pinned_commands.dart';

part 'pinned_commands_dao.g.dart';

/// The pinned commands DAO.
@DriftAccessor(tables: [PinnedCommands])
class PinnedCommandsDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$PinnedCommandsDaoMixin {
  /// Create an instance.
  PinnedCommandsDao(super.db);
}
