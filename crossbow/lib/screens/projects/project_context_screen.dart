import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../hotkeys.dart';
import '../../messages.dart';
import '../../src/providers.dart';
import '../../util.dart';
import '../../widgets/asset_reference_play_sound_semantics.dart';
import '../../widgets/command_list_tile.dart';
import '../../widgets/directory_list_tile.dart';
import '../../widgets/play_sound_semantics.dart';
import 'edit_menu_screen.dart';

/// The main project screen.
class ProjectContextScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const ProjectContextScreen({
    super.key,
  });

  @override
  ProjectScreenState createState() => ProjectScreenState();
}

/// State for [ProjectContextScreen].
class ProjectScreenState extends ConsumerState<ProjectContextScreen> {
  /// Build the widget.
  @override
  Widget build(final BuildContext context) => CallbackShortcuts(
        bindings: {
          closeHotkey: () {
            Navigator.of(context).maybePop();
          }
        },
        child: TabbedScaffold(
          tabs: [
            TabbedScaffoldTab(
              title: Intl.message('Project Settings'),
              icon: const Icon(Icons.settings),
              builder: getSettingsPage,
            ),
            TabbedScaffoldTab(
              title: Intl.message('Menus'),
              icon: Text(Intl.message('Project menus.')),
              builder: getMenusPage,
              floatingActionButton: FloatingActionButton(
                onPressed: newMenu,
                tooltip: Intl.message('New Menu'),
                child: intlNewIcon,
              ),
            )
          ],
        ),
      );

  /// The main settings page.
  Widget getSettingsPage(final BuildContext context) {
    final projectContext = ref.watch(projectContextNotifierProvider);
    if (projectContext == null) {
      return const Placeholder();
    }
    final project = projectContext.project;
    final assetsDirectory = projectContext.assetsDirectory;
    if (assetsDirectory.existsSync() == false) {
      assetsDirectory.createSync(recursive: true);
    }
    return ListView(
      children: [
        DirectoryListTile(
          directory: projectContext.projectDirectory,
          title: Intl.message('Project Directory'),
        ),
        DirectoryListTile(
          directory: projectContext.assetsDirectory,
          title: Intl.message('Assets Directory'),
        ),
        TextListTile(
          autofocus: true,
          value: project.projectName,
          onChanged: (final value) {
            editProject(projectName: value);
          },
          header: projectNameMessage,
          labelText: projectNameMessage,
          title: projectNameMessage,
        ),
        CommandListTile(
          commandId: project.initialCommandId,
          title: Intl.message('Initial Command'),
          nullable: false,
          onChanged: (final value) {},
        ),
        TextListTile(
          value: project.appName,
          onChanged: (final value) => editProject(appName: value),
          header: appNameMessage,
          labelText: appNameMessage,
          title: appNameMessage,
        ),
        TextListTile(
          value: project.orgName,
          onChanged: (final value) => editProject(orgName: value),
          header: orgNameMessage,
          labelText: orgNameMessage,
          title: orgNameMessage,
        ),
        IntListTile(
          value: project.framesPerSecond,
          onChanged: (final value) => editProject(framesPerSecond: value),
          title: framesPerSecondMessage,
          labelText: framesPerSecondMessage,
          min: 1,
          max: 256,
          modifier: project.framesPerSecond,
          subtitle: '${project.framesPerSecond} FPS',
        )
      ],
    );
  }

  /// Get a list view of the menus in the project.
  Widget getMenusPage(final BuildContext context) {
    final value = ref.watch(menusProvider);
    return CallbackShortcuts(
      bindings: {newShortcut: newMenu},
      child: value.when(
        data: (final data) {
          final projectContext = data.projectContext;
          final menus = data.value;
          return BuiltSearchableListView(
            items: menus,
            builder: (final context, final index) {
              final menu = menus[index];
              return SearchableListTile(
                searchString: menu.name,
                child: AssetReferencePlaySoundSemantics(
                  assetReferenceId: menu.musicId,
                  looping: true,
                  child: Builder(
                    builder: (final context) => CallbackShortcuts(
                      bindings: {
                        deleteHotkey: () async {
                          PlaySoundSemantics.of(context)?.stop();
                          final menuItems =
                              await projectContext.db.menuItemsDao.getMenuItems(
                            menuId: menu.id,
                          );
                          if (mounted) {
                            if (menuItems.isEmpty) {
                              await intlConfirm(
                                context: context,
                                message: Intl.message(
                                  'Are you sure you want to delete this menu?',
                                ),
                                title: confirmDeleteTitle,
                                yesCallback: () async {
                                  Navigator.of(context).pop();
                                  await projectContext.db.menusDao
                                      .deleteMenu(id: menu.id);
                                  ref.invalidate(menusProvider);
                                },
                              );
                            } else {
                              await intlShowMessage(
                                context: context,
                                message: Intl.message(
                                  'You must delete all menu items first.',
                                ),
                                title: errorTitle,
                              );
                            }
                          }
                        }
                      },
                      child: ListTile(
                        autofocus: index == 0,
                        title: Text(menu.name),
                        onTap: () async {
                          PlaySoundSemantics.of(context)?.stop();
                          await pushWidget(
                            context: context,
                            builder: (final context) =>
                                EditMenuScreen(menuId: menu.id),
                          );
                          ref.invalidate(menusProvider);
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: ErrorListView.withPositional,
        loading: LoadingWidget.new,
      ),
    );
  }

  /// Create a new menu.
  Future<void> newMenu() async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final menu = await projectContext.db.menusDao.createMenu(
      name: 'Untitled Menu',
    );
    if (mounted) {
      await pushWidget(
        context: context,
        builder: (final context) => EditMenuScreen(menuId: menu.id),
      );
    }
    ref.invalidate(menusProvider);
  }

  /// Edit the project.
  void editProject({
    final String? projectName,
    final String? appName,
    final String? orgName,
    final String? databaseFilename,
    final String? assetsDirectory,
    final int? initialCommandId,
    final int? framesPerSecond,
  }) {
    final oldProject = ref.watch(projectContextNotifierProvider)!.project;
    final project = Project(
      projectName: projectName ?? oldProject.projectName,
      initialCommandId: initialCommandId ?? oldProject.initialCommandId,
      appName: appName ?? oldProject.appName,
      assetsDirectory: assetsDirectory ?? oldProject.assetsDirectory,
      databaseFilename: databaseFilename ?? oldProject.databaseFilename,
      framesPerSecond: framesPerSecond ?? oldProject.framesPerSecond,
      orgName: orgName ?? oldProject.orgName,
    );
    ref
        .watch(projectContextNotifierProvider.notifier)
        .replaceProjectContext(project);
    setState(() {});
  }
}
