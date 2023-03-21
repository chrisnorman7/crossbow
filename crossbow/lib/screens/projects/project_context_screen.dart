import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../../hotkeys.dart';
import '../../messages.dart';
import '../../src/providers.dart';
import '../../util.dart';
import '../../widgets/asset_reference_play_sound_semantics.dart';
import '../../widgets/command_list_tile.dart';
import '../../widgets/common_shortcuts.dart';
import '../../widgets/directory_list_tile.dart';
import '../../widgets/play_sound_semantics.dart';
import '../command_triggers/edit_command_trigger_screen.dart';
import '../commands/edit_command_screen.dart';
import '../commands/edit_dart_function_screen.dart';
import '../custom_levels/edit_custom_level_screen.dart';
import 'assets_page.dart';
import 'menus/edit_menu_screen.dart';

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
              title: Intl.message('Custom Levels'),
              icon: Text(Intl.message('Blank levels which can be programmed')),
              builder: getCustomLevelsPage,
              floatingActionButton: FloatingActionButton(
                onPressed: newCustomLevel,
                tooltip: Intl.message('New Custom Level'),
                child: intlNewIcon,
              ),
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
            ),
            TabbedScaffoldTab(
              title: Intl.message('Command Triggers'),
              icon: Text(
                Intl.message(
                  'Triggers which can be bound to actions in levels',
                ),
              ),
              builder: getCommandTriggersPage,
              floatingActionButton: FloatingActionButton(
                onPressed: newCommandTrigger,
                tooltip: Intl.message('New Command Trigger'),
                child: intlNewIcon,
              ),
            ),
            TabbedScaffoldTab(
              title: Intl.message('Dart Functions'),
              icon: Text(Intl.message('Functions that can be coded in Dart.')),
              builder: getDartFunctionsPage,
              floatingActionButton: FloatingActionButton(
                onPressed: newDartFunction,
                tooltip: Intl.message('New Dart Function'),
                child: intlNewIcon,
              ),
            ),
            TabbedScaffoldTab(
              title: Intl.message('Pinned Commands'),
              icon: Text(
                Intl.message(
                  'Commands which can be used in multiple places',
                ),
              ),
              builder: getPinnedCommandsPage,
            ),
            TabbedScaffoldTab(
              title: Intl.message('Assets'),
              icon: Text(Intl.message('Existing assets on disk')),
              builder: (final context) => const AssetsPage(),
            )
          ],
        ),
      );

  /// The main settings page.
  Widget getSettingsPage(final BuildContext context) {
    final projectContext = ref.watch(projectContextNotifierProvider);
    if (projectContext == null) {
      return const CenterText(text: 'If you are seeing this, there is a bug.');
    }
    final project = projectContext.project;
    final assetsDirectory = projectContext.assetsDirectory;
    if (assetsDirectory.existsSync() == false) {
      assetsDirectory.createSync(recursive: true);
    }
    return CallbackShortcuts(
      bindings: {
        SingleActivator(
          LogicalKeyboardKey.keyP,
          control: useControlKey,
          shift: true,
        ): () => launchUrl(Uri.directory(projectContext.projectDirectory.path)),
        SingleActivator(
          LogicalKeyboardKey.keyA,
          control: useControlKey,
          shift: true,
        ): () => launchUrl(Uri.directory(assetsDirectory.path))
      },
      child: ListView(
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
      ),
    );
  }

  /// Get a list view of the menus in the project.
  Widget getMenusPage(final BuildContext context) {
    final value = ref.watch(menusProvider);
    return CommonShortcuts(
      newCallback: newMenu,
      child: value.when(
        data: (final data) {
          final projectContext = data.projectContext;
          final menus = data.value;
          if (menus.isEmpty) {
            return CenterText(
              text: nothingToShowMessage,
              autofocus: true,
            );
          }
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
                    builder: (final context) => CommonShortcuts(
                      deleteCallback: () async {
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
                                await projectContext.db.utilsDao
                                    .deleteMenu(menu);
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
                      },
                      copyText: menu.id.toString(),
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

  /// Get the command triggers page.
  Widget getCommandTriggersPage(final BuildContext context) {
    final value = ref.watch(commandTriggersProvider);
    return CommonShortcuts(
      newCallback: newCommandTrigger,
      child: value.when(
        data: (final commandTriggers) {
          if (commandTriggers.isEmpty) {
            return CenterText(
              text: nothingToShowMessage,
              autofocus: true,
            );
          }
          return BuiltSearchableListView(
            items: commandTriggers,
            builder: (final context, final index) {
              final valueContext = commandTriggers[index];
              final commandTrigger = valueContext.value;
              final button = commandTrigger.gameControllerButton;
              final buttonName = button?.name ?? unsetMessage;
              final keyboardKey = valueContext.commandTriggerKeyboardKey;
              final keyboardKeyString = keyboardKey == null
                  ? unsetMessage
                  : commandTriggerKeyboardKeyToString(keyboardKey);
              final db = valueContext.projectContext.db;
              final utilsDao = db.utilsDao;
              return SearchableListTile(
                searchString: commandTrigger.description,
                child: CommonShortcuts(
                  deleteCallback: () => intlConfirm(
                    context: context,
                    message: Intl.message(
                      'Are you sure you want to delete this command '
                      'trigger?',
                    ),
                    title: confirmDeleteTitle,
                    yesCallback: () async {
                      Navigator.pop(context);
                      await utilsDao.deleteCommandTrigger(commandTrigger);
                      ref.invalidate(commandTriggersProvider);
                    },
                  ),
                  copyText: commandTrigger.id.toString(),
                  child: ListTile(
                    autofocus: index == 0,
                    title: Text(commandTrigger.description),
                    subtitle: Text('$keyboardKeyString ($buttonName)'),
                    onTap: () async {
                      await pushWidget(
                        context: context,
                        builder: (final context) => EditCommandTriggerScreen(
                          commandTriggerId: commandTrigger.id,
                        ),
                      );
                      ref.invalidate(commandTriggersProvider);
                    },
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

  /// Get the dart functions page.
  Widget getDartFunctionsPage(final BuildContext context) {
    final value = ref.watch(dartFunctionsProvider);
    return CommonShortcuts(
      newCallback: newDartFunction,
      child: value.when(
        data: (final data) {
          if (data.isEmpty) {
            return CenterText(
              text: nothingToShowMessage,
              autofocus: true,
            );
          }
          return BuiltSearchableListView(
            items: data,
            builder: (final context, final index) {
              final f = data[index];
              return SearchableListTile(
                searchString: f.description,
                child: CommonShortcuts(
                  copyText: f.id.toString(),
                  deleteCallback: () => intlConfirm(
                    context: context,
                    message: Intl.message(
                      'Are you sure you want to delete this dart function?',
                    ),
                    title: confirmDeleteTitle,
                    yesCallback: () async {
                      Navigator.pop(context);
                      final projectContext = ref.watch(
                        projectContextNotifierProvider,
                      )!;
                      await projectContext.db.dartFunctionsDao
                          .deleteDartFunction(
                        id: f.id,
                      );
                      ref.invalidate(dartFunctionsProvider);
                    },
                  ),
                  child: ListTile(
                    autofocus: index == 0,
                    title: Text(f.description),
                    onTap: () async {
                      await pushWidget(
                        context: context,
                        builder: (final context) =>
                            EditDartFunctionScreen(dartFunctionId: f.id),
                      );
                      ref.invalidate(dartFunctionsProvider);
                    },
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

  /// Get the pinned commands page.
  Widget getPinnedCommandsPage(final BuildContext context) {
    final value = ref.watch(pinnedCommandsProvider);
    return value.when(
      data: (final data) {
        final pinnedCommands = data.value;
        if (pinnedCommands.isEmpty) {
          return CenterText(
            text: nothingToShowMessage,
            autofocus: true,
          );
        }
        return BuiltSearchableListView(
          items: pinnedCommands,
          builder: (final context, final index) {
            final pinnedCommand = pinnedCommands[index];
            return SearchableListTile(
              searchString: pinnedCommand.name,
              child: CommonShortcuts(
                copyText: pinnedCommand.commandId.toString(),
                child: ListTile(
                  autofocus: index == 0,
                  title: Text(pinnedCommand.name),
                  subtitle: Text('#${pinnedCommand.commandId}'),
                  onTap: () async {
                    await pushWidget(
                      context: context,
                      builder: (final context) => EditCommandScreen(
                        commandId: pinnedCommand.commandId,
                        onChanged: (final value) {},
                      ),
                    );
                    ref.invalidate(pinnedCommandsProvider);
                  },
                ),
              ),
            );
          },
        );
      },
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Get the custom levels page.
  Widget getCustomLevelsPage(final BuildContext context) {
    final value = ref.watch(customLevelsProvider);
    return CommonShortcuts(
      newCallback: newCustomLevel,
      child: value.when(
        data: (final data) {
          final projectContext = data.projectContext;
          final levels = data.value;
          if (levels.isEmpty) {
            return CenterText(
              text: nothingToShowMessage,
              autofocus: true,
            );
          }
          return BuiltSearchableListView(
            items: levels,
            builder: (final context, final index) {
              final level = levels[index];
              return SearchableListTile(
                searchString: level.name,
                child: CommonShortcuts(
                  deleteCallback: () async {
                    final commands = await projectContext.db.customLevelsDao
                        .getCustomLevelCommands(customLevelId: level.id);
                    if (commands.isNotEmpty) {
                      if (mounted) {
                        await intlShowMessage(
                          context: context,
                          message: levelWithCommandsMessage,
                          title: errorTitle,
                        );
                      }
                      return;
                    }
                    if (mounted) {
                      return intlConfirm(
                        context: context,
                        message: Intl.message(
                          'Are you sure you want to delete this level?',
                        ),
                        title: confirmDeleteTitle,
                        yesCallback: () async {
                          await projectContext.db.utilsDao
                              .deleteCustomLevel(level);
                          ref.invalidate(customLevelsProvider);
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                      );
                    }
                  },
                  copyText: level.id.toString(),
                  child: AssetReferencePlaySoundSemantics(
                    assetReferenceId: level.musicId,
                    child: Builder(
                      builder: (final context) => ListTile(
                        autofocus: index == 0,
                        title: Text(level.name),
                        onTap: () async {
                          PlaySoundSemantics.of(context)?.stop();
                          await pushWidget(
                            context: context,
                            builder: (final context) => EditCustomLevelScreen(
                              customLevelId: level.id,
                            ),
                          );
                          ref.invalidate(customLevelsProvider);
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

  /// Create a new command trigger.
  Future<void> newCommandTrigger() async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final commandTrigger =
        await projectContext.db.commandTriggersDao.createCommandTrigger(
      description: 'An empty command trigger',
    );
    if (mounted) {
      await pushWidget(
        context: context,
        builder: (final context) =>
            EditCommandTriggerScreen(commandTriggerId: commandTrigger.id),
      );
    }
    ref.invalidate(commandTriggersProvider);
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

  /// Create a new custom level.
  Future<void> newCustomLevel() async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final level = await projectContext.db.customLevelsDao.createCustomLevel(
      name: 'Untitled Level',
    );
    if (mounted) {
      await pushWidget(
        context: context,
        builder: (final context) =>
            EditCustomLevelScreen(customLevelId: level.id),
      );
    }
    ref.invalidate(customLevelsProvider);
  }

  /// Create a new dart function.
  Future<void> newDartFunction() async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final dartFunction =
        await projectContext.db.dartFunctionsDao.createDartFunction(
      description: 'A function with no description.',
    );
    if (mounted) {
      await pushWidget(
        context: context,
        builder: (final context) =>
            EditDartFunctionScreen(dartFunctionId: dartFunction.id),
      );
    }
    ref.invalidate(dartFunctionsProvider);
  }
}
