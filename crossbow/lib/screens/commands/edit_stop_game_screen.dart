import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/contexts/value_context.dart';
import '../../src/providers.dart';
import '../../widgets/after_list_tile.dart';
import '../../widgets/variable_name_list_tile.dart';

/// A widget for editing the stop game with the given [stopGameId].
class EditStopGameScreen extends ConsumerWidget {
  /// Create an instance.
  const EditStopGameScreen({
    required this.stopGameId,
    super.key,
  });

  /// The ID of the stop game to edit.
  final int stopGameId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(stopGameProvider.call(stopGameId));
    return Cancel(
      child: SimpleScaffold(
        title: Intl.message('Edit Stop Game'),
        body: value.when(
          data: (final data) => getBody(ref: ref, valueContext: data),
          error: ErrorListView.withPositional,
          loading: LoadingWidget.new,
        ),
      ),
    );
  }

  /// Return the body for this widget.
  Widget getBody({
    required final WidgetRef ref,
    required final ValueContext<StopGame> valueContext,
  }) {
    final projectContext = valueContext.projectContext;
    final db = projectContext.db;
    final stopGamesDao = db.stopGamesDao;
    final stopGame = valueContext.value;
    return ListView(
      children: [
        TextListTile(
          value: stopGame.description,
          onChanged: (final value) async {
            await stopGamesDao.setDescription(
              stopGameId: stopGame.id,
              description: value,
            );
            invalidateStopGameProvider(ref);
          },
          header: descriptionMessage,
          autofocus: true,
        ),
        AfterListTile(
          after: stopGame.after,
          onChanged: (final value) async {
            await stopGamesDao.setAfter(
              stopGameId: stopGame.id,
              after: value,
            );
            invalidateStopGameProvider(ref);
          },
          title: Intl.message('Stop After'),
        ),
        VariableNameListTile(
          variableName: stopGame.variableName,
          getOtherVariableNames: () async {
            final stopGames = await db.select(db.stopGames).get();
            return stopGames
                .map((final e) => e.variableName ?? unsetMessage)
                .toList();
          },
          onChanged: (final value) async {
            await stopGamesDao.setVariableName(
              stopGameId: stopGame.id,
              variableName: value,
            );
            invalidateStopGameProvider(ref);
          },
        )
      ],
    );
  }

  /// Invalidate the stop game provider.
  void invalidateStopGameProvider(final WidgetRef ref) =>
      ref.invalidate(stopGameProvider.call(stopGameId));
}
