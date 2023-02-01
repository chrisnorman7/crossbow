import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../hotkeys.dart';
import '../src/contexts/app_context.dart';
import '../src/contexts/project_context.dart';
import '../src/json/crossbow_project.dart';
import '../src/providers/providers.dart';
import '../util.dart';
import 'project_screen.dart';

/// The screen for creating and opening projects.
class CreateOpenProjectScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const CreateOpenProjectScreen({
    super.key,
  });

  /// Create state for this widget.
  @override
  CreateOpenProjectScreenState createState() => CreateOpenProjectScreenState();
}

/// State for [CreateOpenProjectScreen].
class CreateOpenProjectScreenState
    extends ConsumerState<CreateOpenProjectScreen> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final result = ref.watch(appContextProvider);
    return result.when(
      data: (final data) => getBody(appContext: data),
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }

  /// Get the main widget for this screen.
  Widget getBody({
    required final AppContext appContext,
  }) =>
      CallbackShortcuts(
        bindings: {
          newProjectHotkey: () => newProject(appContext),
          openProjectHotkey: () => openProject(appContext)
        },
        child: SimpleScaffold(
          title: Intl.message('Load Project'),
          body: ListView(
            children: [
              ListTile(
                title: Text(
                  Intl.message(
                    'New Project',
                  ),
                ),
                subtitle: Text(singleActivatorToString(newProjectHotkey)),
                onTap: () => newProject(appContext),
              ),
              ListTile(
                autofocus: true,
                title: Text(Intl.message('Open Project')),
                subtitle: Text(singleActivatorToString(openProjectHotkey)),
                onTap: () => openProject(appContext),
              )
            ],
          ),
        ),
      );

  /// Create a new project.
  Future<void> newProject(final AppContext appContext) async {
    final projectPath = await FilePicker.platform.saveFile(
      allowedExtensions: ['json'],
      dialogTitle: Intl.message('New Project'),
      fileName: defaultProjectFilename,
      initialDirectory: appContext.crossbowDirectory.path,
    );
    if (projectPath == null || !mounted) {
      return;
    }
    final file = File(projectPath);
    if (file.existsSync()) {
      return showMessage(
        context: context,
        message: Intl.message('That file already exists.'),
      );
    }
    final project = CrossbowProject();
    final projectContext = ProjectContext(projectFile: file, project: project)
      ..save();
    await pushWidget(
      context: context,
      builder: (final context) => ProjectScreen(projectContext: projectContext),
    );
  }

  /// Open an existing project.
  Future<void> openProject(final AppContext appContext) async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['json'],
      dialogTitle: Intl.message('Open Project'),
      initialDirectory: appContext.crossbowDirectory.path,
    );
    final projectPath = result?.files.single.path;
    if (projectPath == null || !mounted) {
      return;
    }
    final file = File(projectPath);
    try {
      final projectContext = ProjectContext.fromFile(projectFile: file);
      await pushWidget(
        context: context,
        builder: (final context) => ProjectScreen(
          projectContext: projectContext,
        ),
      );
    } on Exception catch (e) {
      await showMessage(
        context: context,
        message: Intl.message(
          'Failed to open project: $e',
          args: [e],
          desc: 'A message to show when loading a project failed',
          examples: {'e': '<Any Dart exception>'},
        ),
      );
    }
  }
}
