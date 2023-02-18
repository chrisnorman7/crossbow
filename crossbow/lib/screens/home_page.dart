import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../src/json/app_preferences.dart';
import '../src/providers.dart';
import 'projects/create_open_project_screen.dart';
import 'projects/project_context_screen.dart';

/// The home page for the app.
class HomePage extends ConsumerWidget {
  /// Create an instance.
  const HomePage({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(appPreferencesProvider);
    return value.when(
      data: (final data) => getBody(data.appPreferences),
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody(final AppPreferences preferences) {
    final recentProjectPath = preferences.recentProjectPath;
    final recentProjectFile =
        recentProjectPath == null ? null : File(recentProjectPath);
    if (recentProjectFile == null || recentProjectFile.existsSync() == false) {
      return const CreateOpenProjectScreen();
    }
    final projectContext = ProjectContext.fromFile(recentProjectFile);
    return ProjectContextScreen(projectContext: projectContext);
  }
}
