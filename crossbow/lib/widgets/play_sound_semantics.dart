import 'package:crossbow_backend/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ziggurat/sound.dart' as ziggurat_sound;

import '../src/providers.dart';

/// A widget that plays a sound when selected, and destroys it when the focus
/// changes.
class PlaySoundSemantics extends ConsumerStatefulWidget {
  /// Create an instance.
  const PlaySoundSemantics({
    required this.assetReference,
    required this.child,
    this.looping = false,
    super.key,
  });

  /// Return the nearest play sound semantics state.
  ///
  /// This is used when pushing another widget over one which is already playing
  /// a sound, so that [PlaySoundSemanticsState.stop] can be called.
  static PlaySoundSemanticsState? of(final BuildContext context) =>
      context.findAncestorStateOfType<PlaySoundSemanticsState>();

  /// The asset reference to play.
  final AssetReference assetReference;

  /// The child widget.
  final Widget child;

  /// Whether or not the sound should loop.
  final bool looping;

  /// Create state for this widget.
  @override
  PlaySoundSemanticsState createState() => PlaySoundSemanticsState();
}

/// State for [PlaySoundSemantics].
class PlaySoundSemanticsState extends ConsumerState<PlaySoundSemantics> {
  ziggurat_sound.Sound? _sound;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Semantics(
        onDidGainAccessibilityFocus: play,
        onDidLoseAccessibilityFocus: stop,
        child: widget.child,
      );

  /// Stop the sound.
  void stop() {
    _sound?.destroy();
    _sound = null;
  }

  /// Play the sound.
  void play() {
    stop();
    final assetReference = widget.assetReference;
    final projectRunner = ref.watch(projectRunnerProvider);
    if (projectRunner == null) {
      return;
    }
    final game = ref.watch(gameProvider);
    final asset = projectRunner.getAssetReference(assetReference);
    _sound = game.interfaceSounds.playSound(
      assetReference: asset,
      gain: asset.gain,
      keepAlive: true,
      looping: widget.looping,
    );
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    stop();
  }
}
