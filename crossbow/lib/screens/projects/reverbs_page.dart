import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/providers.dart';
import '../../util.dart';
import '../../widgets/common_shortcuts.dart';
import '../reverbs/edit_reverb_screen.dart';

/// A page to show all reverbs.
class ReverbsPage extends ConsumerStatefulWidget {
  /// Create an instance.
  const ReverbsPage({
    super.key,
  });

  /// Create state for this widget.
  @override
  ReverbsPageState createState() => ReverbsPageState();
}

/// State for [ReverbsPage].
class ReverbsPageState extends ConsumerState<ReverbsPage> {
  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final value = ref.watch(reverbsProvider);
    return value.when(
      data: (final data) {
        if (data.isEmpty) {
          return CenterText(
            text: nothingToShowMessage,
            autofocus: true,
          );
        }
        return BuiltSearchableListView(
          items: data,
          builder: (final context, final index) {
            final reverb = data[index];
            return SearchableListTile(
              searchString: reverb.name,
              child: CommonShortcuts(
                deleteCallback: () => intlConfirm(
                  context: context,
                  message: Intl.message('Do you want to delete this reverb?'),
                  title: confirmDeleteTitle,
                  yesCallback: () async {
                    Navigator.pop(context);
                    final projectContext =
                        ref.watch(projectContextNotifierProvider)!;
                    await projectContext.db.reverbsDao.deleteReverb(reverb);
                    ref
                      ..invalidate(reverbsProvider)
                      ..invalidate(reverbProvider.call(reverb.id));
                  },
                ),
                child: ListTile(
                  autofocus: index == 0,
                  title: Text(reverb.name),
                  subtitle: Text(reverb.variableName ?? unsetMessage),
                  onTap: () => pushWidget(
                    context: context,
                    builder: (final context) => EditRoomReverbScreen(
                      reverbId: reverb.id,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }
}
