import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../hotkeys.dart';
import '../../messages.dart';
import '../../src/providers.dart';
import '../../widgets/command_list_tile.dart';
import '../../widgets/directory_list_tile.dart';
import 'create_open_project_screen.dart';

/// The main project screen.
class ProjectContextScreen extends ConsumerStatefulWidget {
  /// Create an instance.
  const ProjectContextScreen({
    required this.backButton,
    super.key,
  });

  /// Whether this widget needs a back button.
  final bool backButton;
  @override
  ProjectScreenState createState() => ProjectScreenState();
}

/// State for [ProjectContextScreen].
class ProjectScreenState extends ConsumerState<ProjectContextScreen> {
  /// Dispose of the widget.
  @override
  Future<void> dispose() async {
    super.dispose();
    await ref
        .watch(projectContextNotifierProvider.notifier)
        .clearProjectContext();
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final backButton = widget.backButton
        ? BackButton(
            onPressed: () => goBack(context),
          )
        : null;
    return CallbackShortcuts(
      bindings: {
        closeHotkey: () {
          if (widget.backButton) {
            goBack(context);
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: TabbedScaffold(
        tabs: [
          TabbedScaffoldTab(
            title: Intl.message('Project Settings'),
            icon: const Icon(Icons.settings),
            builder: getSettingsPage,
            leading: backButton,
          ),
          TabbedScaffoldTab(
            title: Intl.message('Menus'),
            icon: Text(Intl.message('Project menus.')),
            builder: (final context) => const Placeholder(),
            leading: backButton,
          )
        ],
      ),
    );
  }

  /// What happens when the back button is clicked.
  Future<void> goBack(final BuildContext context) async {
    await ref
        .watch(projectContextNotifierProvider.notifier)
        .clearProjectContext();
    if (mounted) {
      Navigator.of(context).pop();
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (final context) => const CreateOpenProjectScreen(),
        ),
      );
    }
  }

  /// The main settings page.
  Widget getSettingsPage(final BuildContext context) {
    final projectContext = ref.watch(projectContextNotifierProvider)!;
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
          database: projectContext.db,
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
