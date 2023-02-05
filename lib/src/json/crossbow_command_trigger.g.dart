// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crossbow_command_trigger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrossbowCommandTrigger _$CrossbowCommandTriggerFromJson(
        Map<String, dynamic> json) =>
    CrossbowCommandTrigger(
      id: json['id'] as String,
      description: json['description'] as String? ?? 'New command trigger',
      keyboardKey: json['keyboardKey'] == null
          ? null
          : CommandKeyboardKey.fromJson(
              json['keyboardKey'] as Map<String, dynamic>),
      button:
          $enumDecodeNullable(_$GameControllerButtonEnumMap, json['button']),
    );

Map<String, dynamic> _$CrossbowCommandTriggerToJson(
        CrossbowCommandTrigger instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'keyboardKey': instance.keyboardKey,
      'button': _$GameControllerButtonEnumMap[instance.button],
    };

const _$GameControllerButtonEnumMap = {
  GameControllerButton.invalid: 'invalid',
  GameControllerButton.a: 'a',
  GameControllerButton.b: 'b',
  GameControllerButton.x: 'x',
  GameControllerButton.y: 'y',
  GameControllerButton.back: 'back',
  GameControllerButton.guide: 'guide',
  GameControllerButton.start: 'start',
  GameControllerButton.leftstick: 'leftstick',
  GameControllerButton.rightstick: 'rightstick',
  GameControllerButton.leftshoulder: 'leftshoulder',
  GameControllerButton.rightshoulder: 'rightshoulder',
  GameControllerButton.dpadUp: 'dpadUp',
  GameControllerButton.dpadDown: 'dpadDown',
  GameControllerButton.dpadLeft: 'dpadLeft',
  GameControllerButton.dpadRight: 'dpadRight',
  GameControllerButton.misc1: 'misc1',
  GameControllerButton.paddle1: 'paddle1',
  GameControllerButton.paddle2: 'paddle2',
  GameControllerButton.paddle3: 'paddle3',
  GameControllerButton.paddle4: 'paddle4',
  GameControllerButton.touchpad: 'touchpad',
  GameControllerButton.max: 'max',
};
