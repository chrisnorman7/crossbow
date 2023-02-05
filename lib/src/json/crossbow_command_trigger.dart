import 'package:dart_sdl/dart_sdl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ziggurat/ziggurat.dart';

part 'crossbow_command_trigger.g.dart';

/// A schema to represent a Ziggurat command trigger.
@JsonSerializable()
class CrossbowCommandTrigger {
  /// Create an instance.
  CrossbowCommandTrigger({
    required this.id,
    this.description = 'New command trigger',
    this.keyboardKey,
    this.button,
  });

  /// Create an instance from a JSON object.
  factory CrossbowCommandTrigger.fromJson(final Map<String, dynamic> json) =>
      _$CrossbowCommandTriggerFromJson(json);

  /// The ID of this command trigger.
  final String id;

  /// The description of this trigger.
  String description;

  /// The keyboard trigger to use.
  CommandKeyboardKey? keyboardKey;

  /// The game controller button to use.
  GameControllerButton? button;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$CrossbowCommandTriggerToJson(this);
}
