import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:test/test.dart';

import '../../custom_database.dart';

void main() {
  group(
    'StopGamesDao',
    () {
      final db = getDatabase();
      final stopGames = db.stopGamesDao;

      test(
        '.createStopGame',
        () async {
          var stopGame = await stopGames.createStopGame();
          expect(stopGame.after, null);
          stopGame = await stopGames.createStopGame(after: 1234);
          expect(stopGame.after, 1234);
        },
      );

      test(
        '.getStopGame',
        () async {
          final stopGame = await stopGames.createStopGame();
          expect(
            await stopGames.getStopGame(id: stopGame.id),
            predicate<StopGame>((final value) => value.id == stopGame.id),
          );
        },
      );
    },
  );
}
