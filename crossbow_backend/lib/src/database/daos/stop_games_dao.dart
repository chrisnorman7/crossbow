import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/stop_games.dart';

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

  /// Set the [after] value for the stop game with the given [stopGameId].
  Future<StopGame> setAfter({
    required final int stopGameId,
    final int? after,
  }) async {
    final query = update(stopGames)
      ..where((final table) => table.id.equals(stopGameId));
    return (await query.writeReturning(StopGamesCompanion(after: Value(after))))
        .single;
  }

  /// Delete the stop game with the given [stopGameId].
  Future<int> deleteStopGame({required final int stopGameId}) async {
    final query = delete(stopGames)
      ..where((final table) => table.id.equals(stopGameId));
    return query.go();
  }
}
