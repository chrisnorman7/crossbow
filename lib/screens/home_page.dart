import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../src/contexts/project_context.dart';
import '../src/providers/providers.dart';
import 'create_open_project_screen.dart';
import 'project_screen.dart';

/// The home page for the application.
class HomePage extends ConsumerWidget {
  /// Create an instance.
  const HomePage({
    super.key,
  });

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final provider = ref.watch(recentProjectPathProvider);
    return provider.when(
      data: (final data) => getBody(
        context: context,
        projectFile: data == null ? null : File(data),
      ),
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final File? projectFile,
  }) {
    if (projectFile == null || projectFile.existsSync() == false) {
      return const CreateOpenProjectScreen();
    }
    try {
      final projectContext = ProjectContext.fromFile(projectFile: projectFile);
      return ProjectScreen(projectContext: projectContext);
    } on Exception catch (e, s) {
      return ErrorScreen(
        error: e,
        stackTrace: s,
      );
    }
  }
}
