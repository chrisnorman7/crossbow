import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../messages.dart';
import '../../src/providers.dart';
import '../../util.dart';
import '../../widgets/asset_reference_list_tile.dart';
import '../../widgets/new_callback_shortcuts.dart';
import '../command_triggers/select_command_trigger_screen.dart';
import 'edit_custom_level_command_screen.dart';

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
              floatingActionButton: FloatingActionButton(
                onPressed: newCommand,
                tooltip: Intl.message('New Command'),
                child: intlNewIcon,
              ),
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
    final value = ref.watch(
      customLevelCommandsProvider.call(widget.customLevelId),
    );
    return value.when(
      data: (final commands) {
        final Widget child;
        if (commands.isEmpty) {
          child = CenterText(
            text: nothingToShowMessage,
            autofocus: true,
          );
        } else {
          child = BuiltSearchableListView(
            items: commands,
            builder: (final context, final index) {
              final commandContext = commands[index];
              final projectContext = commandContext.projectContext;
              final commandTrigger = commandContext.commandTrigger;
              final command = commandContext.value;
              return SearchableListTile(
                searchString: commandTrigger.description,
                child: CallbackShortcuts(
                  bindings: {
                    deleteShortcut: () {
                      final customLevelCommandsDao =
                          projectContext.db.customLevelCommandsDao;
                      intlConfirm(
                        context: context,
                        message: Intl.message(
                          'Are you sure you want to delete this command?',
                        ),
                        title: confirmDeleteTitle,
                        yesCallback: () async {
                          await customLevelCommandsDao.deleteCustomLevelCommand(
                            id: commandContext.value.id,
                          );
                          ref.invalidate(
                            customLevelCommandsProvider
                                .call(widget.customLevelId),
                          );
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                      );
                    }
                  },
                  child: ListTile(
                    autofocus: index == 0,
                    title: Text(commandTrigger.description),
                    onTap: () async {
                      await pushWidget(
                        context: context,
                        builder: (final context) =>
                            EditCustomLevelCommandScreen(
                          customLevelCommandId: command.id,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
        return NewCallbackShortcuts(newCallback: newCommand, child: child);
      },
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Create a new command.
  Future<void> newCommand() async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final db = projectContext.db;
    await pushWidget(
      context: context,
      builder: (final context) => SelectCommandTriggerScreen(
        onChanged: (final value) async {
          final command =
              await db.customLevelCommandsDao.createCustomLevelCommand(
            customLevelId: widget.customLevelId,
            commandTriggerId: value,
          );
          if (mounted) {
            await pushWidget(
              context: context,
              builder: (final context) => EditCustomLevelCommandScreen(
                customLevelCommandId: command.id,
              ),
            );
          }
          ref.invalidate(
            customLevelCommandsProvider.call(widget.customLevelId),
          );
        },
      ),
    );
  }
}
