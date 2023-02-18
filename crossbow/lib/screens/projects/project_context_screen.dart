import 'dart:convert';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';

import '../../widgets/bases/project_stateful_widget.dart';

/// The main project screen.
class ProjectContextScreen extends ProjectStatefulWidget {
  /// Create an instance.
  const ProjectContextScreen({required super.projectContext, super.key});

  @override
  ProjectScreenState createState() => ProjectScreenState();
}

/// State for [ProjectContextScreen].
class ProjectScreenState extends State<ProjectContextScreen> {
  /// The project context to edit.
  late ProjectContext projectContext;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    projectContext = widget.projectContext;
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => SimpleScaffold(
        title: projectContext.project.projectName,
        body: CenterText(
          text: jsonEncode(projectContext.project),
        ),
      );
}
