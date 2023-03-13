import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/providers.dart';
import '../../widgets/asset_reference_list_tile.dart';

/// A widget for editing the custom level with the given [customLevelId].
class EditCustomLevelScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const EditCustomLevelScreen({
    required this.customLevelId,
    super.key,
  });

  /// The ID of the custom level to edit.
  final int customLevelId;

  /// Create state for this widget.
  @override
  EditCustomLevelScreenState createState() => EditCustomLevelScreenState();
}

/// State for [EditCustomLevelScreen].
class EditCustomLevelScreenState extends ConsumerState<EditCustomLevelScreen> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Cancel(
        child: TabbedScaffold(
          tabs: [
            TabbedScaffoldTab(
              title: Intl.message('Level Settings'),
              icon: settingsIcon,
              builder: getSettingsPage,
            ),
            TabbedScaffoldTab(
              title: Intl.message('Commands'),
              icon: Text(
                Intl.message(
                  'Commands which can be used from within the level',
                ),
              ),
              builder: getCustomLevelCommandsPage,
            )
          ],
        ),
      );

  /// Invalidate the [customLevelProvider].
  void invalidateCustomLevelProvider() =>
      ref.invalidate(customLevelProvider.call(widget.customLevelId));

  /// Get the settings page.
  Widget getSettingsPage(final BuildContext context) {
    final value = ref.watch(customLevelProvider.call(widget.customLevelId));
    return value.when(
      data: (final data) {
        final level = data.value;
        final customLevelsDao = data.projectContext.db.customLevelsDao;
        return ListView(
          children: [
            TextListTile(
              value: level.name,
              onChanged: (final value) async {
                await customLevelsDao.setName(
                  customLevelId: level.id,
                  name: value,
                );
                invalidateCustomLevelProvider();
              },
              header: Intl.message('Level Name'),
              autofocus: true,
            ),
            AssetReferenceListTile(
              assetReferenceId: level.musicId,
              onChanged: (final value) async {
                await customLevelsDao.setMusicId(
                  customLevelId: level.id,
                  musicId: value,
                );
                invalidateCustomLevelProvider();
              },
              nullable: true,
              title: Intl.message('Music'),
              looping: true,
            )
          ],
        );
      },
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Get the custom level commands page.
  Widget getCustomLevelCommandsPage(final BuildContext context) {
    final value =
        ref.watch(customLevelCommandsProvider.call(widget.customLevelId));
    return value.when(
      data: (final commands) {
        if (commands.isEmpty) {
          return CenterText(
            text: nothingToShowMessage,
            autofocus: true,
          );
        }
        return BuiltSearchableListView(
          items: commands,
          builder: (final context, final index) {
            final commandContext = commands[index];
            final commandTrigger = commandContext.commandTrigger;
            return SearchableListTile(
              searchString: commandTrigger.description,
              child: ListTile(
                autofocus: index == 0,
                title: Text(commandTrigger.description),
                onTap: () async {},
              ),
            );
          },
        );
      },
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }
}
