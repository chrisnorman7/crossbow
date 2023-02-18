import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../hotkeys.dart';
import '../../messages.dart';
import '../../util.dart';
import 'project_context_screen.dart';

/// A widget for opening and creating projects.
class CreateOpenProjectScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const CreateOpenProjectScreen({
    super.key,
  });

  /// Create state for this widget.
  @override
  CreateOpenProjectState createState() => CreateOpenProjectState();
}

/// State for [CreateOpenProjectScreen].
class CreateOpenProjectState extends ConsumerState<CreateOpenProjectScreen> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) => CallbackShortcuts(
        bindings: {
          newProjectHotkey: newProject,
          openProjectHotkey: openProject
        },
        child: SimpleScaffold(
          title: Intl.message('Load Project'),
          body: ListView(
            children: [
              ListTile(
                title: const Text('Debug'),
                subtitle: Text(kDebugMode.toString()),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Script Directory'),
                subtitle: Text(
                  Platform.packageConfig ?? 'Nothing',
                ),
                onTap: () {},
              ),
              ListTile(
                autofocus: true,
                title: Text(Intl.message('Create New Project')),
                subtitle: Text(
                  singleActivatorToString(singleActivator: newProjectHotkey),
                ),
                onTap: newProject,
              ),
              ListTile(
                title: Text(Intl.message('Open Existing Project')),
                subtitle: Text(
                  singleActivatorToString(singleActivator: openProjectHotkey),
                ),
                onTap: openProject,
              )
            ],
          ),
        ),
      );

  /// Create a new project.
  Future<void> newProject() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = await FilePicker.platform.saveFile(
      allowedExtensions: ['.json'],
      dialogTitle: newProjectDialogTitle,
      fileName: 'project.json',
      initialDirectory: documentsDirectory.path,
    );
    if (path == null) {
      return;
    }
    final file = File(path);
    final projectContext = await ProjectContext.blank(projectFile: file);
    if (mounted) {
      await pushWidget(
        context: context,
        builder: (final context) => ProjectContextScreen(
          projectContext: projectContext,
        ),
      );
    }
  }

  /// Open an existing project.
  Future<void> openProject() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['.json'],
      dialogTitle: openProjectDialogTitle,
      initialDirectory: documentsDirectory.path,
    );
    if (result == null) {
      return;
    }
    final path = result.files.single.path;
    if (path == null) {
      if (mounted) {
        return showMessage(context: context, message: emptyPathMessage);
      } else {
        return;
      }
    }
    final file = File(path);
    final ProjectContext projectContext;
    try {
      projectContext = ProjectContext.fromFile(file);
      // ignore: avoid_catches_without_on_clauses
    } catch (e, s) {
      if (mounted) {
        await pushWidget(
          context: context,
          builder: (final context) =>
              Cancel(child: ErrorScreen(error: e, stackTrace: s)),
        );
      }
      return;
    }
    if (mounted) {
      await pushWidget(
        context: context,
        builder: (final context) => ProjectContextScreen(
          projectContext: projectContext,
        ),
      );
    }
  }
}
