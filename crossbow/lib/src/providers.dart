import 'dart:convert';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'contexts/app_preferences_context.dart';
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
    if (projectContext != null) {
      await projectContext.db.close();
    }
    state = null;
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

/// Always provide a project context.
final projectContextProvider = Provider<ProjectContext>(
  (final ref) => ref.watch(projectContextNotifierProvider)!,
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
    final projectContext = ref.watch(projectContextProvider);
    final command = await projectContext.db.commandsDao.getCommand(id: id);
    return ValueContext(projectContext: projectContext, value: command);
  },
);
