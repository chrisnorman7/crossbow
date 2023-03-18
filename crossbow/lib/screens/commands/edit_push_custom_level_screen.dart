import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../src/contexts/push_custom_level_context.dart';
import '../../src/providers.dart';
import '../../widgets/after_list_tile.dart';
import '../../widgets/custom_level_list_tile.dart';
import '../../widgets/error_list_tile.dart';
import '../../widgets/fade_length_list_tile.dart';

/// A screen for editing a push menu with the given [pushCustomLevelId].
class EditPushCustomLevelScreen extends ConsumerWidget {
  /// Create an instance.
  const EditPushCustomLevelScreen({
    required this.pushCustomLevelId,
    super.key,
  });

  /// The ID of the push custom level to edit.
  final int pushCustomLevelId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(pushCustomLevelProvider.call(pushCustomLevelId));
    return Cancel(
      child: SimpleScaffold(
        title: Intl.message('Edit Push Menu'),
        body: value.when(
          data: (final data) => getBody(
            context: context,
            ref: ref,
            pushCustomLevelContext: data,
          ),
          error: ErrorListTile.withPositional,
          loading: LoadingWidget.new,
        ),
      ),
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final WidgetRef ref,
    required final PushCustomLevelContext pushCustomLevelContext,
  }) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final pushCustomLevelsDao = projectContext.db.pushCustomLevelsDao;
    final pushCustomLevel = pushCustomLevelContext.value;
    final level = pushCustomLevelContext.customLevel;
    return ListView(
      children: [
        CustomLevelListTile(
          customLevelId: level.id,
          onChanged: (final value) async {
            await pushCustomLevelsDao.setCustomLevelId(
              pushCustomLevelId: pushCustomLevelId,
              customLevelId: value!,
            );
            invalidatePushCustomLevelProvider(ref);
          },
          autofocus: true,
        ),
        AfterListTile(
          after: pushCustomLevel.after,
          onChanged: (final value) async {
            await pushCustomLevelsDao.setAfter(
              pushCustomLevelId: pushCustomLevelId,
              after: value == 0 ? null : value,
            );
            invalidatePushCustomLevelProvider(ref);
          },
          title: Intl.message('Push Delay'),
        ),
        FadeLengthListTile(
          fadeLength: pushCustomLevel.fadeLength,
          onChanged: (final value) async {
            await pushCustomLevelsDao.setFadeLength(
              pushCustomLevelId: pushCustomLevelId,
              fadeLength: value,
            );
            invalidatePushCustomLevelProvider(ref);
          },
        )
      ],
    );
  }

  /// Invalidate the push custom level provider.
  void invalidatePushCustomLevelProvider(final WidgetRef ref) =>
      ref.invalidate(pushCustomLevelProvider.call(pushCustomLevelId));
}
