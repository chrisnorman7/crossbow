import 'package:backstreets_widgets/widgets.dart';
import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../src/contexts/value_context.dart';
import '../src/providers.dart';
import 'play_sound_semantics.dart';

/// A widget that builds a [PlaySoundSemantics] instance from the given
/// [assetReferenceId].
class AssetReferencePlaySoundSemantics extends ConsumerWidget {
  /// Create an instance.
  const AssetReferencePlaySoundSemantics({
    required this.assetReferenceId,
    required this.child,
    this.looping = false,
    super.key,
  });

  /// The ID of the asset reference.
  final int? assetReferenceId;

  /// The widget below this one in the tree.
  final Widget child;

  /// Whether or not the asset reference should loop.
  final bool looping;

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final id = assetReferenceId;
    if (id == null) {
      final projectContext = ref.watch(projectContextNotifierProvider)!;
      return getBody(ValueContext(projectContext: projectContext, value: null));
    }
    final value = ref.watch(assetReferenceProvider.call(id));
    return value.when(
      data: getBody,
      error: ErrorListView.withPositional,
      loading: LoadingWidget.new,
    );
  }

  /// Get the body for this widget.
  Widget getBody(final ValueContext<AssetReference?> data) {
    final assetReference = data.value;
    if (assetReference == null) {
      return child;
    }
    return PlaySoundSemantics(
      assetReference: assetReference,
      looping: looping,
      child: Builder(
        builder: (final context) => child,
      ),
    );
  }
}
