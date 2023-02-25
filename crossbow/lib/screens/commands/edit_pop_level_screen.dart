import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/contexts/value_context.dart';
import '../../src/providers.dart';

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
  final ValueChanged<int?> onChanged;

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
    final popLevels = popLevelContext.projectContext.db.popLevelsDao;
    final popLevel = popLevelContext.value;
    final fadeLength = popLevel.fadeLength;
    return SimpleScaffold(
      title: Intl.message('Edit Pop Level'),
      body: ListView(
        children: [
          DoubleListTile(
            value: fadeLength ?? 0.0,
            onChanged: (final value) async {
              await popLevels.setFadeLength(
                id: popLevel.id,
                fadeLength: value == 0 ? null : value,
              );
              ref.invalidate(popLevelProvider.call(popLevelId));
            },
            title: Intl.message('Fade Length'),
            autofocus: true,
            min: 0,
            subtitle: fadeLength == null
                ? unsetMessage
                : '$fadeLength $secondsMessage',
          )
        ],
      ),
    );
  }
}
