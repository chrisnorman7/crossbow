import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets/center_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants.dart';
import 'shortcuts.dart';

void main() => runApp(const MyApp());

/// The top-level app class.
class MyApp extends StatelessWidget {
  /// Create an instance.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) => ProviderScope(
        child: MaterialApp(
          title: 'Crossbow',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          shortcuts: {
            ...WidgetsApp.defaultShortcuts,
            presetsShortcut: const PresetsIntent()
          },
          actions: {
            ...WidgetsApp.defaultActions,
            PresetsIntent: PresetsAction()
          },
          home: const SimpleScaffold(
            title: 'Crossbow',
            body: CenterText(text: 'Works.', autofocus: true),
          ),
        ),
      );
}
