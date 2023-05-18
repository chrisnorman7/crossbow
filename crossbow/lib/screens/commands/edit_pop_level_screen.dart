import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/contexts/value_context.dart';
import '../../src/providers.dart';
import '../../widgets/fade_length_list_tile.dart';
import '../../widgets/variable_name_list_tile.dart';

/// A screen to edit a pop level with the given [popLevelId].
class EditPopLevelScreen extends ConsumerWidget {
  /// Create an instance.
  const EditPopLevelScreen({
    required this.popLevelId,
    required this.onChanged,
    super.key,
  });

  /// The ID of the pop level to edit.
  final int popLevelId;

  /// The function to call when the pop level changes.
  final ValueChanged<PopLevel?> onChanged;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(popLevelProvider.call(popLevelId));
    return Cancel(
      child: value.when(
        data: (final data) => getBody(
          ref: ref,
          popLevelContext: data,
        ),
        error: ErrorScreen.withPositional,
        loading: LoadingScreen.new,
      ),
    );
  }

  /// Get the body of the widget.
  Widget getBody({
    required final WidgetRef ref,
    required final ValueContext<PopLevel> popLevelContext,
  }) {
    final db = popLevelContext.projectContext.db;
    final popLevelsDao = db.popLevelsDao;
    final popLevel = popLevelContext.value;
    return SimpleScaffold(
      title: Intl.message('Edit Pop Level'),
      body: ListView(
        children: [
          TextListTile(
            value: popLevel.description,
            onChanged: (final value) async {
              await popLevelsDao.setDescription(
                popLevel: popLevel,
                description: value,
              );
              invalidatePopLevelProvider(ref);
            },
            header: descriptionMessage,
            autofocus: true,
          ),
          FadeLengthListTile(
            fadeLength: popLevel.fadeLength,
            onChanged: (final value) async {
              await popLevelsDao.setFadeLength(
                popLevel: popLevel,
                fadeLength: value,
              );
              invalidatePopLevelProvider(ref);
            },
          ),
          VariableNameListTile(
            variableName: popLevel.variableName,
            getOtherVariableNames: () async {
              final popLevels = await db.select(db.popLevels).get();
              return popLevels
                  .map((final e) => e.variableName ?? unsetMessage)
                  .toList();
            },
            onChanged: (final value) async {
              await popLevelsDao.setVariableName(
                popLevel: popLevel,
                variableName: value,
              );
              invalidatePopLevelProvider(ref);
            },
          )
        ],
      ),
    );
  }

  /// Invalidate the pop levels provider.
  void invalidatePopLevelProvider(final WidgetRef ref) =>
      ref.invalidate(popLevelProvider.call(popLevelId));
}
