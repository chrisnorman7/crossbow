import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../messages.dart';
import '../../src/contexts/value_context.dart';
import '../../src/providers.dart';

/// A screen to edit the dart function with the given [dartFunctionId].
class EditDartFunctionScreen extends ConsumerWidget {
  /// Create an instance.
  const EditDartFunctionScreen({
    required this.dartFunctionId,
    super.key,
  });

  /// The ID of the dart function to edit.
  final int dartFunctionId;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(dartFunctionProvider.call(dartFunctionId));
    return Cancel(
      child: SimpleScaffold(
        title: Intl.message('Edit Dart Function'),
        body: value.when(
          data: (final data) =>
              getBody(context: context, ref: ref, valueContext: data),
          error: ErrorListView.withPositional,
          loading: LoadingWidget.new,
        ),
      ),
    );
  }

  /// Get the body for this widget.
  Widget getBody({
    required final BuildContext context,
    required final WidgetRef ref,
    required final ValueContext<DartFunction> valueContext,
  }) {
    final f = valueContext.value;
    final projectContext = valueContext.projectContext;
    final dartFunctionsDao = projectContext.db.dartFunctionsDao;
    return ListView(
      children: [
        TextListTile(
          value: f.description,
          onChanged: (final value) async {
            await dartFunctionsDao.setDescription(
              dartFunctionId: f.id,
              description: value,
            );
            invalidateDartFunctionProvider(ref);
          },
          header: descriptionMessage,
          autofocus: true,
        )
      ],
    );
  }

  /// Invalidate the dart function provider.
  void invalidateDartFunctionProvider(final WidgetRef ref) =>
      ref.invalidate(dartFunctionProvider.call(dartFunctionId));
}