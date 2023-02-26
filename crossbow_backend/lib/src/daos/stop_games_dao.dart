import 'package:drift/drift.dart';

import '../database/database.dart';
import '../database/tables/stop_games.dart';

part 'stop_games_dao.g.dart';

/// The stop games DAO.
@DriftAccessor(tables: [StopGames])
class StopGamesDao extends DatabaseAccessor<CrossbowBackendDatabase>
    with _$StopGamesDaoMixin {
  /// Create an instance.
  StopGamesDao(super.db);

  /// Create a stop game.
  Future<StopGame> createStopGame({final int? after}) =>
      into(stopGames).insertReturning(StopGamesCompanion(after: Value(after)));

  /// Get a stop game with the given [id].
  Future<StopGame> getStopGame({required final int id}) {
    final query = select(stopGames)
      ..where((final table) => table.id.equals(id));
    return query.getSingle();
  }
}
