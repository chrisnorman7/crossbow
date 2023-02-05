import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../hotkeys.dart';
import '../src/contexts/project_context.dart';
import '../util.dart';

/// The main project settings tab.
class ProjectSettingsTab extends StatefulWidget {
  /// Create an instance.
  const ProjectSettingsTab({
    required this.projectContext,
    required this.closeProjectFunction,
    super.key,
  });

  /// The project context to work with.
  final ProjectContext projectContext;

  /// The function to call to close the given [projectContext].
  final VoidCallback closeProjectFunction;

  /// Create state for this widget.
  @override
  ProjectSettingsTabState createState() => ProjectSettingsTabState();
}

/// State for [ProjectSettingsTab].
class ProjectSettingsTabState extends State<ProjectSettingsTab> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final project = widget.projectContext.project;
    return ListView(
      children: [
        TextListTile(
          value: project.projectName,
          onChanged: (final value) => setState(() {
            project.projectName = value;
            widget.projectContext.touch();
          }),
          header: Intl.message('Project Name'),
          autofocus: true,
        ),
        TextListTile(
          value: project.appName,
          onChanged: (final value) => setState(() {
            project.appName = value;
            widget.projectContext.touch();
          }),
          header: Intl.message('App Name'),
        ),
        TextListTile(
          value: project.orgName,
          onChanged: (final value) => setState(() {
            project.orgName = value;
            widget.projectContext.touch();
          }),
          header: Intl.message('Org name'),
        ),
        ListTile(
          title: Text(Intl.message('Asset Directory')),
          subtitle: Text(widget.projectContext.assetDirectory.path),
          onTap: () {
            widget.projectContext.maybeCreateAssetDirectory();
            final uri = Uri.directory(
              widget.projectContext.assetDirectory.path,
            );
            launchUrl(uri);
          },
        ),
        ListTile(
          title: Text(Intl.message('Save Project')),
          subtitle: Text(singleActivatorToString(saveProjectHotkey)),
          onTap: widget.projectContext.save,
        ),
        ListTile(
          title: Text(Intl.message('Close Project')),
          subtitle: Text(singleActivatorToString(closeProjectHotkey)),
          onTap: widget.closeProjectFunction,
        )
      ],
    );
  }
}
