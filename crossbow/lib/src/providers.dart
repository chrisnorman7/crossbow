import 'dart:convert';
import 'dart:math';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziggurat/sound.dart';
import 'package:ziggurat/ziggurat.dart' as ziggurat;

import '../constants.dart';
import 'contexts/app_preferences_context.dart';
import 'contexts/asset_context.dart';
import 'contexts/call_command_context.dart';
import 'contexts/call_commands_context.dart';
import 'contexts/call_commands_target.dart';
import 'contexts/command_context.dart';
import 'contexts/command_trigger_context.dart';
import 'contexts/custom_level_command_context.dart';
import 'contexts/menu_context.dart';
import 'contexts/menu_item_context.dart';
import 'contexts/push_custom_level_context.dart';
import 'contexts/push_menu_context.dart';
import 'contexts/value_context.dart';
import 'json/app_preferences.dart';

/// Project context state.
class ProjectContextStateNotifier extends StateNotifier<ProjectContext?> {
  /// Create an instance.
  ProjectContextStateNotifier() : super(null);

  /// Get the project context.
  ProjectContext? get maybeProjectContext => state;

  /// Clear the project context.
  Future<void> clearProjectContext() async {
    final projectContext = state;
    state = null;
    if (projectContext != null) {
      await projectContext.db.close();
    }
  }

  /// Set the project context.
  void setProjectContext(final ProjectContext value) {
    if (state != null) {
      throw StateError('You must clear the project context first.');
    }
    state = value;
  }

  /// Replace the project.
  ///
  /// This method will save the [projectContext].
  void replaceProjectContext(final Project project) {
    final oldProjectContext = state!;
    final newProjectContext = ProjectContext(
      file: oldProjectContext.file,
      project: project,
      db: oldProjectContext.db,
    )..save();
    state = newProjectContext;
  }

  /// Get the attached project context, and throw [StateError] if it is `null`.
  ProjectContext get projectContext {
    final projectContext = state;
    if (projectContext == null) {
      throw StateError('Project context is `null`.');
    }
    return projectContext;
  }
}

/// Provide a project context.
final projectContextNotifierProvider =
    StateNotifierProvider<ProjectContextStateNotifier, ProjectContext?>(
  (final ref) => ProjectContextStateNotifier(),
);

/// Provide shared preferences.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (final ref) => SharedPreferences.getInstance(),
);

/// Provide the app preferences.
final appPreferencesProvider = FutureProvider<AppPreferencesContext>(
  (final ref) async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final data = prefs.getString(appPreferencesKey);
    final AppPreferences preferences;
    if (data == null) {
      preferences = AppPreferences();
    } else {
      final json = jsonDecode(data);
      preferences = AppPreferences.fromJson(json);
    }
    return AppPreferencesContext(appPreferences: preferences);
  },
);

/// Provide a synthizer instance.
final synthizerProvider = Provider((final ref) => Synthizer()..initialize());

/// Provide a synthizer context.
final synthizerContextProvider = Provider((final ref) {
  final synthizer = ref.watch(synthizerProvider);
  return synthizer.createContext();
});

/// Provide a single command.
final commandProvider = FutureProvider.family<CommandContext, int>(
  (final ref, final id) async {
    final projectContext = ref.watch(projectContextNotifierProvider);
    if (projectContext == null) {
      throw StateError('Cannot get command with `null` project context.');
    }
    final commandsDao = projectContext.db.commandsDao;
    final command = await commandsDao.getCommand(id: id);
    final pinnedCommand = await commandsDao.getPinnedCommand(command: command);
    return CommandContext(
      projectContext: projectContext,
      value: command,
      pinnedCommand: pinnedCommand,
    );
  },
);

/// Provide an asset reference.
final assetReferenceProvider =
    FutureProvider.family<ValueContext<AssetReference>, int>(
  (final ref, final id) async {
    final projectContext = ref.watch(projectContextNotifierProvider);
    if (projectContext == null) {
      throw StateError(
        'Cannot get asset reference with `null` project context.',
      );
    }
    final assetReference =
        await projectContext.db.assetReferencesDao.getAssetReference(
      id: id,
    );
    return ValueContext(projectContext: projectContext, value: assetReference);
  },
);

/// Provide a SDL instance.
final sdlProvider = Provider<Sdl>(
  (final ref) => Sdl(),
);

/// Provide a random instance.
final randomProvider = Provider((final ref) => Random());

/// Provide a buffer cache.
final bufferCacheProvider = Provider((final ref) {
  final synthizer = ref.watch(synthizerProvider);
  return BufferCache(
    synthizer: synthizer,
    maxSize: 1.gb,
    random: ref.watch(randomProvider),
  );
});

/// Provide a sound backend.
final soundBackendProvider = Provider(
  (final ref) {
    final context = ref.watch(synthizerContextProvider);
    final bufferCache = ref.watch(bufferCacheProvider);
    return SynthizerSoundBackend(
      context: context,
      bufferCache: bufferCache,
    );
  },
);

/// Provide a ziggurat game.
final gameProvider = FutureProvider(
  (final ref) async {
    final projectRunner = await ref.watch(projectRunnerProvider.future);
    return projectRunner!.game;
  },
);

/// Provide a project runner.
final projectRunnerProvider = FutureProvider((final ref) async {
  final projectContext = ref.watch(projectContextNotifierProvider);
  if (projectContext == null) {
    return null;
  }
  final sdl = ref.watch(sdlProvider);
  final synthizerContext = ref.watch(synthizerContextProvider);
  final random = ref.watch(randomProvider);
  final soundBackend = ref.watch(soundBackendProvider);
  final projectRunner = ProjectRunner(
    projectContext: projectContext,
    sdl: sdl,
    synthizerContext: synthizerContext,
    random: random,
    soundBackend: soundBackend,
  );
  await projectRunner.setupGame();
  return projectRunner;
});

/// Provide a single pop level.
final popLevelProvider = FutureProvider.family<ValueContext<PopLevel>, int>(
  (final ref, final id) async {
    final projectContext = ref.watch(projectContextNotifierProvider);
    if (projectContext == null) {
      throw StateError('Cannot get pop level with `null` project context.');
    }
    final popLevel = await projectContext.db.popLevelsDao.getPopLevel(id: id);
    return ValueContext(projectContext: projectContext, value: popLevel);
  },
);

/// Get the context for a menu.
final menuProvider = FutureProvider.family<MenuContext, int>(
  (final ref, final arg) async {
    final projectContext = ref.watch(projectContextNotifierProvider);
    if (projectContext == null) {
      throw StateError('Cannot get menu with `null` project context.');
    }
    final menu = await projectContext.db.menusDao.getMenu(id: arg);
    final db = projectContext.db;
    final menuItemsDao2 = db.menuItemsDao;
    final menusDao = db.menusDao;
    final menuItems = await menuItemsDao2.getMenuItems(
      menu: await menusDao.getMenu(id: arg),
    );
    return MenuContext(
      projectContext: projectContext,
      value: menu,
      menuItems: menuItems,
    );
  },
);

/// Provide a single menu item.
final menuItemProvider = FutureProvider.family<MenuItemContext, int>(
  (final ref, final arg) async {
    final projectContext = ref.watch(projectContextNotifierProvider);
    if (projectContext == null) {
      throw StateError('Cannot get menu item with `null` project context.');
    }
    final db = projectContext.db;
    final menuItem = await db.menuItemsDao.getMenuItem(id: arg);
    final menu = await db.menusDao.getMenu(id: menuItem.menuId);
    return MenuItemContext(
      projectContext: projectContext,
      menu: menu,
      value: menuItem,
    );
  },
);

/// Provide a list of call commands.
final callCommandsProvider =
    FutureProvider.family<List<CallCommandContext>, CallCommandsContext>(
  (final ref, final arg) async {
    final id = arg.id;
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final db = projectContext.db;
    final List<CallCommand> callCommands;
    final commandsDao = db.commandsDao;
    final customLevelCommandsDao = db.customLevelCommandsDao;
    switch (arg.target) {
      case CallCommandsTarget.command:
        callCommands = await commandsDao.getCallCommands(
          command: await commandsDao.getCommand(
            id: id,
          ),
        );
        break;
      case CallCommandsTarget.menuItem:
        callCommands = await db.menuItemsDao.getCallCommands(
          menuItem: await db.menuItemsDao.getMenuItem(id: id),
        );
        break;
      case CallCommandsTarget.menuOnCancel:
        final menusDao = db.menusDao;
        callCommands = await menusDao.getOnCancelCallCommands(
          menu: await menusDao.getMenu(id: id),
        );
        break;
      case CallCommandsTarget.activatingCustomLevelCommand:
        callCommands = await customLevelCommandsDao.getCallCommands(
          customLevelCommand:
              await customLevelCommandsDao.getCustomLevelCommand(
            id: id,
          ),
        );
        break;
      case CallCommandsTarget.releaseCustomLevelCommand:
        callCommands = await customLevelCommandsDao.getReleaseCommands(
          customLevelCommand:
              await customLevelCommandsDao.getCustomLevelCommand(
            id: id,
          ),
        );
        break;
    }
    final futures = callCommands.map<Future<CallCommandContext>>(
      (final e) async {
        final pinnedCommand = await commandsDao.getPinnedCommand(
          command: await commandsDao.getCommand(id: e.commandId),
        );
        return CallCommandContext(
          projectContext: projectContext,
          value: e,
          pinnedCommand: pinnedCommand,
        );
      },
    );
    return Future.wait(futures);
  },
);

/// Provide all menus.
final menusProvider =
    FutureProvider<ValueContext<List<Menu>>>((final ref) async {
  final projectContext = ref.watch(projectContextNotifierProvider)!;
  final menus = await projectContext.db.menusDao.getMenus();
  return ValueContext(projectContext: projectContext, value: menus);
});

/// Provide a push menu.
final pushMenuProvider = FutureProvider.family<PushMenuContext, int>(
  (final ref, final arg) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final db = projectContext.db;
    final pushMenu = await db.pushMenusDao.getPushMenu(id: arg);
    final menu = await db.menusDao.getMenu(id: pushMenu.menuId);
    return PushMenuContext(
      projectContext: projectContext,
      value: pushMenu,
      menu: menu,
    );
  },
);

/// Provide a single stop game instance.
final stopGameProvider = FutureProvider.family<ValueContext<StopGame>, int>(
  (final ref, final arg) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final stopGame = await projectContext.db.stopGamesDao.getStopGame(id: arg);
    return ValueContext(projectContext: projectContext, value: stopGame);
  },
);

/// Provide a single command trigger.
final commandTriggerProvider =
    FutureProvider.family<CommandTriggerContext, int>(
  (final ref, final arg) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final db = projectContext.db;
    final commandTrigger = await db.commandTriggersDao.getCommandTrigger(
      id: arg,
    );
    final keyboardKeyId = commandTrigger.keyboardKeyId;
    final keyboardKey = keyboardKeyId == null
        ? null
        : (await ref.watch(
            commandTriggerKeyboardKeyProvider.call(keyboardKeyId).future,
          ))
            .value;
    return CommandTriggerContext(
      projectContext: projectContext,
      value: commandTrigger,
      commandTriggerKeyboardKey: keyboardKey,
    );
  },
);

/// Provide all command triggers.
final commandTriggersProvider = FutureProvider<List<CommandTriggerContext>>(
  (final ref) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final commandTriggers =
        await projectContext.db.commandTriggersDao.getCommandTriggers();
    final list = <CommandTriggerContext>[];
    for (final commandTrigger in commandTriggers) {
      final keyboardKeyId = commandTrigger.keyboardKeyId;
      if (keyboardKeyId != null) {
        final keyboardKey = await ref.watch(
          commandTriggerKeyboardKeyProvider.call(keyboardKeyId).future,
        );
        list.add(
          CommandTriggerContext(
            projectContext: projectContext,
            value: commandTrigger,
            commandTriggerKeyboardKey: keyboardKey.value,
          ),
        );
      } else {
        list.add(
          CommandTriggerContext(
            projectContext: projectContext,
            value: commandTrigger,
            commandTriggerKeyboardKey: null,
          ),
        );
      }
    }
    return list;
  },
);

/// Provide a single command trigger keyboard key.
final commandTriggerKeyboardKeyProvider =
    FutureProvider.family<ValueContext<CommandTriggerKeyboardKey>, int>(
  (final ref, final arg) async {
    final project = ref.watch(projectContextNotifierProvider)!;
    final key = await project.db.commandTriggerKeyboardKeysDao
        .getCommandTriggerKeyboardKey(
      id: arg,
    );
    return ValueContext(projectContext: project, value: key);
  },
);

/// Provide all pinned commands.
final pinnedCommandsProvider =
    FutureProvider<ValueContext<List<PinnedCommand>>>(
  (final ref) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final pinnedCommands =
        await projectContext.db.pinnedCommandsDao.getPinnedCommands();
    return ValueContext(projectContext: projectContext, value: pinnedCommands);
  },
);

/// Provide all custom levels.
final customLevelsProvider = FutureProvider<ValueContext<List<CustomLevel>>>(
  (final ref) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final levels = await projectContext.db.customLevelsDao.getCustomLevels();
    return ValueContext(projectContext: projectContext, value: levels);
  },
);

/// Provide a single custom level.
final customLevelProvider =
    FutureProvider.family<ValueContext<CustomLevel>, int>(
  (final ref, final arg) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final level =
        await projectContext.db.customLevelsDao.getCustomLevel(id: arg);
    return ValueContext(projectContext: projectContext, value: level);
  },
);

/// Get the custom level commands for a particular level.
final customLevelCommandsProvider =
    FutureProvider.family<List<CustomLevelCommandContext>, int>(
  (final ref, final arg) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final customLevelsDao = projectContext.db.customLevelsDao;
    final commands = await customLevelsDao.getCustomLevelCommands(
      customLevel: await customLevelsDao.getCustomLevel(id: arg),
    );
    final futures = commands.map<Future<CustomLevelCommandContext>>(
      (final e) async {
        final commandTrigger = await projectContext.db.commandTriggersDao
            .getCommandTrigger(id: e.commandTriggerId);
        return CustomLevelCommandContext(
          projectContext: projectContext,
          value: e,
          commandTrigger: commandTrigger,
        );
      },
    );
    return Future.wait(futures);
  },
);

/// Provide a single custom level command.
final customLevelCommandProvider =
    FutureProvider.family<CustomLevelCommandContext, int>(
  (final ref, final arg) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final db = projectContext.db;
    final command =
        await db.customLevelCommandsDao.getCustomLevelCommand(id: arg);
    final commandTrigger = await db.commandTriggersDao
        .getCommandTrigger(id: command.commandTriggerId);
    return CustomLevelCommandContext(
      projectContext: projectContext,
      value: command,
      commandTrigger: commandTrigger,
    );
  },
);

/// Provide a single push custom level.
final pushCustomLevelProvider =
    FutureProvider.family<PushCustomLevelContext, int>(
  (final ref, final arg) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final db = projectContext.db;
    final pushCustomLevel =
        await db.pushCustomLevelsDao.getPushCustomLevel(id: arg);
    final customLevel = await db.customLevelsDao
        .getCustomLevel(id: pushCustomLevel.customLevelId);
    return PushCustomLevelContext(
      projectContext: projectContext,
      value: pushCustomLevel,
      customLevel: customLevel,
    );
  },
);

/// Provide all dart functions.
final dartFunctionsProvider = FutureProvider((final ref) async {
  final projectContext = ref.watch(projectContextNotifierProvider)!;
  return projectContext.db.dartFunctionsDao.getDartFunctions();
});

/// Provide a single dart function.
final dartFunctionProvider =
    FutureProvider.family<ValueContext<DartFunction>, int>(
  (final ref, final arg) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final f = await projectContext.db.dartFunctionsDao.getDartFunction(id: arg);
    return ValueContext(projectContext: projectContext, value: f);
  },
);

/// Possibly provide a single detached asset reference.
final detachedAssetReferenceProvider =
    FutureProvider.family<ValueContext<AssetReference?>, AssetContext>(
  (final ref, final arg) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final assetReference = await projectContext.db.assetReferencesDao
        .getDetachedAssetReference(folderName: arg.folderName, name: arg.name);
    return ValueContext(projectContext: projectContext, value: assetReference);
  },
);

/// Provide all reverbs.
final reverbsProvider = FutureProvider((final ref) async {
  final projectContext = ref.watch(projectContextNotifierProvider)!;
  return projectContext.db.reverbsDao.getReverbs();
});

/// Get a single reverb.
final reverbProvider = FutureProvider.family<ValueContext<Reverb>, int>(
    (final ref, final arg) async {
  final projectContext = ref.watch(projectContextNotifierProvider)!;
  final reverb = await projectContext.db.reverbsDao.getReverb(arg);
  return ValueContext(projectContext: projectContext, value: reverb);
});
