import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../messages.dart';
import '../../src/providers.dart';

/// A screen for building a [projectContext].
class BuildProjectScreen extends ConsumerWidget {
  /// Create an instance.
  const BuildProjectScreen({
    required this.projectContext,
    super.key,
  });

  /// The project context to build.
  final ProjectContext projectContext;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final file = projectContext.file;
    final stopWatch = Stopwatch()..start();
    return FutureBuilder(
      future: compute(
        buildProjectFromFilename,
        projectContext.file.path,
      ),
      builder: (final context, final snapshot) {
        if (snapshot.hasError) {
          stopWatch.stop();
          return Cancel(
            child: SimpleScaffold(
              title: errorTitle,
              body: ErrorListView(
                error: snapshot.error!,
                stackTrace: snapshot.stackTrace,
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          stopWatch.stop();
          Future(
            () => ref
                .watch(projectContextNotifierProvider.notifier)
                .setProjectContext(ProjectContext.fromFile(file)),
          );
          return Cancel(
            child: SimpleScaffold(
              title: Intl.message('Project Built'),
              body: ListView(
                children: [
                  CopyListTile(
                    title: Intl.message('Build Complete'),
                    subtitle: stopWatch.elapsed.toString(),
                    autofocus: true,
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                tooltip: Intl.message('Close'),
                child: closeIcon,
              ),
            ),
          );
        } else {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: SimpleScaffold(
              title: Intl.message('Building Project'),
              body: const Focus(autofocus: true, child: LoadingWidget()),
            ),
          );
        }
      },
    );
  }
}
