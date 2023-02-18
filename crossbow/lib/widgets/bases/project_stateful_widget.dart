import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';

/// A stateful widget which has an attached [projectContext].
abstract class ProjectStatefulWidget extends StatefulWidget {
  /// Create an instance.
  const ProjectStatefulWidget({required this.projectContext, super.key});

  /// The initial project context to use.
  final ProjectContext projectContext;
}
