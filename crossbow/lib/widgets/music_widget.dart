import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziggurat/sound.dart';

import '../src/providers.dart';

/// A widget which will loop music from the given [musicId].
class MusicWidget extends ConsumerStatefulWidget {
  /// Create an instance.
  const MusicWidget({
    required this.musicId,
    required this.child,
    super.key,
  });

  /// The ID of the asset reference to play.
  final int? musicId;

  /// The widget below this one in the tree.
  final Widget child;

  /// Create state for this widget.
  @override
  MusicWidgetState createState() => MusicWidgetState();
}

/// State for [MusicWidget].
class MusicWidgetState extends ConsumerState<MusicWidget> {
  /// The sound that is playing.
  Sound? _sound;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => FutureBuilder(
        builder: (final context, final snapshot) => widget.child,
        future: play(),
      );

  /// Play the music.
  Future<void> play() async {
    final id = widget.musicId;
    if (id != null) {
      final projectRunner = await ref.watch(projectRunnerProvider.future);
      final game = projectRunner!.game;
      final assetReference = await projectRunner.getAssetReferenceFromId(id);
      _sound = game.musicSounds.playSound(
        assetReference: assetReference,
        keepAlive: true,
        looping: true,
      );
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _sound?.destroy();
    _sound = null;
  }
}
