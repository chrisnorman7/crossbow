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
import 'contexts/call_commands_context.dart';
import 'contexts/command_trigger_context.dart';
import 'contexts/menu_context.dart';
import 'contexts/menu_item_context.dart';
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
final commandProvider = FutureProvider.family<ValueContext<Command>, int>(
  (final ref, final id) async {
    final projectContext = ref.watch(projectContextNotifierProvider);
    if (projectContext == null) {
      throw StateError('Cannot get command with `null` project context.');
    }
    final command = await projectContext.db.commandsDao.getCommand(id: id);
    return ValueContext(projectContext: projectContext, value: command);
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
final gameProvider = Provider(
  (final ref) {
    final sdl = ref.watch(sdlProvider);
    final soundBackend = ref.watch(soundBackendProvider);
    return ziggurat.Game(
      sdl: sdl,
      title: 'Game Provider',
      soundBackend: soundBackend,
    );
  },
);

/// Provide a project runner.
final projectRunnerProvider = Provider((final ref) {
  final projectContext = ref.watch(projectContextNotifierProvider);
  if (projectContext == null) {
    return null;
  }
  final sdl = ref.watch(sdlProvider);
  final synthizerContext = ref.watch(synthizerContextProvider);
  final random = ref.watch(randomProvider);
  final soundBackend = ref.watch(soundBackendProvider);
  return ProjectRunner(
    projectContext: projectContext,
    sdl: sdl,
    synthizerContext: synthizerContext,
    random: random,
    soundBackend: soundBackend,
  );
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
    final menuItems = await projectContext.db.menuItemsDao.getMenuItems(
      menuId: arg,
    );
    return MenuContext(
      projectContext: projectContext,
      menu: menu,
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
      menuItem: menuItem,
    );
  },
);

/// Provide a list of call commands.
final callCommandsProvider =
    FutureProvider.family<ValueContext<List<CallCommand>>, CallCommandsContext>(
  (final ref, final arg) async {
    final id = arg.id;
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final db = projectContext.db;
    final List<CallCommand> callCommands;
    switch (arg.target) {
      case CallCommandsTarget.command:
        callCommands = await db.commandsDao.getCallCommands(commandId: id);
        break;
      case CallCommandsTarget.menuItem:
        callCommands = await db.menuItemsDao.getCallCommands(menuItemId: id);
        break;
      case CallCommandsTarget.menuOnCancel:
        callCommands = await db.menusDao.getOnCancelCallCommands(menuId: id);
        break;
    }
    return ValueContext(projectContext: projectContext, value: callCommands);
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
      pushMenu: pushMenu,
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
      commandTrigger: commandTrigger,
      commandTriggerKeyboardKey: keyboardKey,
    );
  },
);

/// Provide all command triggers.
final commandTriggersProvider =
    FutureProvider<ValueContext<List<CommandTrigger>>>(
  (final ref) async {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
    final commandTriggers =
        await projectContext.db.commandTriggersDao.getCommandTriggers();
    return ValueContext(projectContext: projectContext, value: commandTriggers);
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
