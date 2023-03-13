// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AssetReferencesTable extends AssetReferences
    with TableInfo<$AssetReferencesTable, AssetReference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetReferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Untitled Object'));
  static const VerificationMeta _folderNameMeta =
      const VerificationMeta('folderName');
  @override
  late final GeneratedColumn<String> folderName = GeneratedColumn<String>(
      'folder_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gainMeta = const VerificationMeta('gain');
  @override
  late final GeneratedColumn<double> gain = GeneratedColumn<double>(
      'gain', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.7));
  @override
  List<GeneratedColumn> get $columns => [id, name, folderName, gain];
  @override
  String get aliasedName => _alias ?? 'asset_references';
  @override
  String get actualTableName => 'asset_references';
  @override
  VerificationContext validateIntegrity(Insertable<AssetReference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('folder_name')) {
      context.handle(
          _folderNameMeta,
          folderName.isAcceptableOrUnknown(
              data['folder_name']!, _folderNameMeta));
    } else if (isInserting) {
      context.missing(_folderNameMeta);
    }
    if (data.containsKey('gain')) {
      context.handle(
          _gainMeta, gain.isAcceptableOrUnknown(data['gain']!, _gainMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetReference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetReference(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      folderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_name'])!,
      gain: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gain'])!,
    );
  }

  @override
  $AssetReferencesTable createAlias(String alias) {
    return $AssetReferencesTable(attachedDatabase, alias);
  }
}

class AssetReference extends DataClass implements Insertable<AssetReference> {
  /// The primary key.
  final int id;

  /// The name of this object.
  final String name;

  /// The folder that contains the asset with the given [name].
  final String folderName;

  /// The gain to play this sound at.
  final double gain;
  const AssetReference(
      {required this.id,
      required this.name,
      required this.folderName,
      required this.gain});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['folder_name'] = Variable<String>(folderName);
    map['gain'] = Variable<double>(gain);
    return map;
  }

  AssetReferencesCompanion toCompanion(bool nullToAbsent) {
    return AssetReferencesCompanion(
      id: Value(id),
      name: Value(name),
      folderName: Value(folderName),
      gain: Value(gain),
    );
  }

  factory AssetReference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetReference(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      folderName: serializer.fromJson<String>(json['folderName']),
      gain: serializer.fromJson<double>(json['gain']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'folderName': serializer.toJson<String>(folderName),
      'gain': serializer.toJson<double>(gain),
    };
  }

  AssetReference copyWith(
          {int? id, String? name, String? folderName, double? gain}) =>
      AssetReference(
        id: id ?? this.id,
        name: name ?? this.name,
        folderName: folderName ?? this.folderName,
        gain: gain ?? this.gain,
      );
  @override
  String toString() {
    return (StringBuffer('AssetReference(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('folderName: $folderName, ')
          ..write('gain: $gain')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, folderName, gain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetReference &&
          other.id == this.id &&
          other.name == this.name &&
          other.folderName == this.folderName &&
          other.gain == this.gain);
}

class AssetReferencesCompanion extends UpdateCompanion<AssetReference> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> folderName;
  final Value<double> gain;
  const AssetReferencesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.folderName = const Value.absent(),
    this.gain = const Value.absent(),
  });
  AssetReferencesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    required String folderName,
    this.gain = const Value.absent(),
  }) : folderName = Value(folderName);
  static Insertable<AssetReference> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? folderName,
    Expression<double>? gain,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (folderName != null) 'folder_name': folderName,
      if (gain != null) 'gain': gain,
    });
  }

  AssetReferencesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? folderName,
      Value<double>? gain}) {
    return AssetReferencesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      folderName: folderName ?? this.folderName,
      gain: gain ?? this.gain,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (folderName.present) {
      map['folder_name'] = Variable<String>(folderName.value);
    }
    if (gain.present) {
      map['gain'] = Variable<double>(gain.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetReferencesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('folderName: $folderName, ')
          ..write('gain: $gain')
          ..write(')'))
        .toString();
  }
}

class $CommandTriggerKeyboardKeysTable extends CommandTriggerKeyboardKeys
    with
        TableInfo<$CommandTriggerKeyboardKeysTable, CommandTriggerKeyboardKey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommandTriggerKeyboardKeysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _scanCodeMeta =
      const VerificationMeta('scanCode');
  @override
  late final GeneratedColumnWithTypeConverter<ScanCode, int> scanCode =
      GeneratedColumn<int>('scan_code', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<ScanCode>(
              $CommandTriggerKeyboardKeysTable.$converterscanCode);
  static const VerificationMeta _controlMeta =
      const VerificationMeta('control');
  @override
  late final GeneratedColumn<bool> control =
      GeneratedColumn<bool>('control', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("control" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _altMeta = const VerificationMeta('alt');
  @override
  late final GeneratedColumn<bool> alt =
      GeneratedColumn<bool>('alt', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("alt" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _shiftMeta = const VerificationMeta('shift');
  @override
  late final GeneratedColumn<bool> shift =
      GeneratedColumn<bool>('shift', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("shift" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, scanCode, control, alt, shift];
  @override
  String get aliasedName => _alias ?? 'command_trigger_keyboard_keys';
  @override
  String get actualTableName => 'command_trigger_keyboard_keys';
  @override
  VerificationContext validateIntegrity(
      Insertable<CommandTriggerKeyboardKey> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_scanCodeMeta, const VerificationResult.success());
    if (data.containsKey('control')) {
      context.handle(_controlMeta,
          control.isAcceptableOrUnknown(data['control']!, _controlMeta));
    }
    if (data.containsKey('alt')) {
      context.handle(
          _altMeta, alt.isAcceptableOrUnknown(data['alt']!, _altMeta));
    }
    if (data.containsKey('shift')) {
      context.handle(
          _shiftMeta, shift.isAcceptableOrUnknown(data['shift']!, _shiftMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommandTriggerKeyboardKey map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommandTriggerKeyboardKey(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      scanCode: $CommandTriggerKeyboardKeysTable.$converterscanCode.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.int, data['${effectivePrefix}scan_code'])!),
      control: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}control'])!,
      alt: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}alt'])!,
      shift: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}shift'])!,
    );
  }

  @override
  $CommandTriggerKeyboardKeysTable createAlias(String alias) {
    return $CommandTriggerKeyboardKeysTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ScanCode, int, int> $converterscanCode =
      const EnumIndexConverter<ScanCode>(ScanCode.values);
}

class CommandTriggerKeyboardKey extends DataClass
    implements Insertable<CommandTriggerKeyboardKey> {
  /// The primary key.
  final int id;

  /// The scan code to use.
  final ScanCode scanCode;

  /// Whether or not the control key must be held.
  final bool control;

  /// Whether or not the alt key must be held.
  final bool alt;

  /// Whether or not the shift key must be held.
  final bool shift;
  const CommandTriggerKeyboardKey(
      {required this.id,
      required this.scanCode,
      required this.control,
      required this.alt,
      required this.shift});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      final converter = $CommandTriggerKeyboardKeysTable.$converterscanCode;
      map['scan_code'] = Variable<int>(converter.toSql(scanCode));
    }
    map['control'] = Variable<bool>(control);
    map['alt'] = Variable<bool>(alt);
    map['shift'] = Variable<bool>(shift);
    return map;
  }

  CommandTriggerKeyboardKeysCompanion toCompanion(bool nullToAbsent) {
    return CommandTriggerKeyboardKeysCompanion(
      id: Value(id),
      scanCode: Value(scanCode),
      control: Value(control),
      alt: Value(alt),
      shift: Value(shift),
    );
  }

  factory CommandTriggerKeyboardKey.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommandTriggerKeyboardKey(
      id: serializer.fromJson<int>(json['id']),
      scanCode: $CommandTriggerKeyboardKeysTable.$converterscanCode
          .fromJson(serializer.fromJson<int>(json['scanCode'])),
      control: serializer.fromJson<bool>(json['control']),
      alt: serializer.fromJson<bool>(json['alt']),
      shift: serializer.fromJson<bool>(json['shift']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scanCode': serializer.toJson<int>(
          $CommandTriggerKeyboardKeysTable.$converterscanCode.toJson(scanCode)),
      'control': serializer.toJson<bool>(control),
      'alt': serializer.toJson<bool>(alt),
      'shift': serializer.toJson<bool>(shift),
    };
  }

  CommandTriggerKeyboardKey copyWith(
          {int? id,
          ScanCode? scanCode,
          bool? control,
          bool? alt,
          bool? shift}) =>
      CommandTriggerKeyboardKey(
        id: id ?? this.id,
        scanCode: scanCode ?? this.scanCode,
        control: control ?? this.control,
        alt: alt ?? this.alt,
        shift: shift ?? this.shift,
      );
  @override
  String toString() {
    return (StringBuffer('CommandTriggerKeyboardKey(')
          ..write('id: $id, ')
          ..write('scanCode: $scanCode, ')
          ..write('control: $control, ')
          ..write('alt: $alt, ')
          ..write('shift: $shift')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, scanCode, control, alt, shift);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommandTriggerKeyboardKey &&
          other.id == this.id &&
          other.scanCode == this.scanCode &&
          other.control == this.control &&
          other.alt == this.alt &&
          other.shift == this.shift);
}

class CommandTriggerKeyboardKeysCompanion
    extends UpdateCompanion<CommandTriggerKeyboardKey> {
  final Value<int> id;
  final Value<ScanCode> scanCode;
  final Value<bool> control;
  final Value<bool> alt;
  final Value<bool> shift;
  const CommandTriggerKeyboardKeysCompanion({
    this.id = const Value.absent(),
    this.scanCode = const Value.absent(),
    this.control = const Value.absent(),
    this.alt = const Value.absent(),
    this.shift = const Value.absent(),
  });
  CommandTriggerKeyboardKeysCompanion.insert({
    this.id = const Value.absent(),
    required ScanCode scanCode,
    this.control = const Value.absent(),
    this.alt = const Value.absent(),
    this.shift = const Value.absent(),
  }) : scanCode = Value(scanCode);
  static Insertable<CommandTriggerKeyboardKey> custom({
    Expression<int>? id,
    Expression<int>? scanCode,
    Expression<bool>? control,
    Expression<bool>? alt,
    Expression<bool>? shift,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scanCode != null) 'scan_code': scanCode,
      if (control != null) 'control': control,
      if (alt != null) 'alt': alt,
      if (shift != null) 'shift': shift,
    });
  }

  CommandTriggerKeyboardKeysCompanion copyWith(
      {Value<int>? id,
      Value<ScanCode>? scanCode,
      Value<bool>? control,
      Value<bool>? alt,
      Value<bool>? shift}) {
    return CommandTriggerKeyboardKeysCompanion(
      id: id ?? this.id,
      scanCode: scanCode ?? this.scanCode,
      control: control ?? this.control,
      alt: alt ?? this.alt,
      shift: shift ?? this.shift,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scanCode.present) {
      final converter = $CommandTriggerKeyboardKeysTable.$converterscanCode;
      map['scan_code'] = Variable<int>(converter.toSql(scanCode.value));
    }
    if (control.present) {
      map['control'] = Variable<bool>(control.value);
    }
    if (alt.present) {
      map['alt'] = Variable<bool>(alt.value);
    }
    if (shift.present) {
      map['shift'] = Variable<bool>(shift.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommandTriggerKeyboardKeysCompanion(')
          ..write('id: $id, ')
          ..write('scanCode: $scanCode, ')
          ..write('control: $control, ')
          ..write('alt: $alt, ')
          ..write('shift: $shift')
          ..write(')'))
        .toString();
  }
}

class $CommandTriggersTable extends CommandTriggers
    with TableInfo<$CommandTriggersTable, CommandTrigger> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommandTriggersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gameControllerButtonMeta =
      const VerificationMeta('gameControllerButton');
  @override
  late final GeneratedColumnWithTypeConverter<GameControllerButton?, int>
      gameControllerButton = GeneratedColumn<int>(
              'game_controller_button', aliasedName, true,
              type: DriftSqlType.int, requiredDuringInsert: false)
          .withConverter<GameControllerButton?>(
              $CommandTriggersTable.$convertergameControllerButtonn);
  static const VerificationMeta _keyboardKeyIdMeta =
      const VerificationMeta('keyboardKeyId');
  @override
  late final GeneratedColumn<int> keyboardKeyId = GeneratedColumn<int>(
      'keyboard_key_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES command_trigger_keyboard_keys (id) ON DELETE SET NULL'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, description, gameControllerButton, keyboardKeyId];
  @override
  String get aliasedName => _alias ?? 'command_triggers';
  @override
  String get actualTableName => 'command_triggers';
  @override
  VerificationContext validateIntegrity(Insertable<CommandTrigger> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    context.handle(
        _gameControllerButtonMeta, const VerificationResult.success());
    if (data.containsKey('keyboard_key_id')) {
      context.handle(
          _keyboardKeyIdMeta,
          keyboardKeyId.isAcceptableOrUnknown(
              data['keyboard_key_id']!, _keyboardKeyIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommandTrigger map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommandTrigger(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      gameControllerButton: $CommandTriggersTable
          .$convertergameControllerButtonn
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int,
              data['${effectivePrefix}game_controller_button'])),
      keyboardKeyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}keyboard_key_id']),
    );
  }

  @override
  $CommandTriggersTable createAlias(String alias) {
    return $CommandTriggersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GameControllerButton, int, int>
      $convertergameControllerButton =
      const EnumIndexConverter<GameControllerButton>(
          GameControllerButton.values);
  static JsonTypeConverter2<GameControllerButton?, int?, int?>
      $convertergameControllerButtonn =
      JsonTypeConverter2.asNullable($convertergameControllerButton);
}

class CommandTrigger extends DataClass implements Insertable<CommandTrigger> {
  /// The primary key.
  final int id;

  /// The description of this command trigger.
  final String description;

  /// The game controller button that will trigger this command.
  final GameControllerButton? gameControllerButton;

  /// The keyboard key to use.
  final int? keyboardKeyId;
  const CommandTrigger(
      {required this.id,
      required this.description,
      this.gameControllerButton,
      this.keyboardKeyId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || gameControllerButton != null) {
      final converter = $CommandTriggersTable.$convertergameControllerButtonn;
      map['game_controller_button'] =
          Variable<int>(converter.toSql(gameControllerButton));
    }
    if (!nullToAbsent || keyboardKeyId != null) {
      map['keyboard_key_id'] = Variable<int>(keyboardKeyId);
    }
    return map;
  }

  CommandTriggersCompanion toCompanion(bool nullToAbsent) {
    return CommandTriggersCompanion(
      id: Value(id),
      description: Value(description),
      gameControllerButton: gameControllerButton == null && nullToAbsent
          ? const Value.absent()
          : Value(gameControllerButton),
      keyboardKeyId: keyboardKeyId == null && nullToAbsent
          ? const Value.absent()
          : Value(keyboardKeyId),
    );
  }

  factory CommandTrigger.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommandTrigger(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      gameControllerButton: $CommandTriggersTable
          .$convertergameControllerButtonn
          .fromJson(serializer.fromJson<int?>(json['gameControllerButton'])),
      keyboardKeyId: serializer.fromJson<int?>(json['keyboardKeyId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'gameControllerButton': serializer.toJson<int?>($CommandTriggersTable
          .$convertergameControllerButtonn
          .toJson(gameControllerButton)),
      'keyboardKeyId': serializer.toJson<int?>(keyboardKeyId),
    };
  }

  CommandTrigger copyWith(
          {int? id,
          String? description,
          Value<GameControllerButton?> gameControllerButton =
              const Value.absent(),
          Value<int?> keyboardKeyId = const Value.absent()}) =>
      CommandTrigger(
        id: id ?? this.id,
        description: description ?? this.description,
        gameControllerButton: gameControllerButton.present
            ? gameControllerButton.value
            : this.gameControllerButton,
        keyboardKeyId:
            keyboardKeyId.present ? keyboardKeyId.value : this.keyboardKeyId,
      );
  @override
  String toString() {
    return (StringBuffer('CommandTrigger(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('gameControllerButton: $gameControllerButton, ')
          ..write('keyboardKeyId: $keyboardKeyId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, description, gameControllerButton, keyboardKeyId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommandTrigger &&
          other.id == this.id &&
          other.description == this.description &&
          other.gameControllerButton == this.gameControllerButton &&
          other.keyboardKeyId == this.keyboardKeyId);
}

class CommandTriggersCompanion extends UpdateCompanion<CommandTrigger> {
  final Value<int> id;
  final Value<String> description;
  final Value<GameControllerButton?> gameControllerButton;
  final Value<int?> keyboardKeyId;
  const CommandTriggersCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.gameControllerButton = const Value.absent(),
    this.keyboardKeyId = const Value.absent(),
  });
  CommandTriggersCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    this.gameControllerButton = const Value.absent(),
    this.keyboardKeyId = const Value.absent(),
  }) : description = Value(description);
  static Insertable<CommandTrigger> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<int>? gameControllerButton,
    Expression<int>? keyboardKeyId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (gameControllerButton != null)
        'game_controller_button': gameControllerButton,
      if (keyboardKeyId != null) 'keyboard_key_id': keyboardKeyId,
    });
  }

  CommandTriggersCompanion copyWith(
      {Value<int>? id,
      Value<String>? description,
      Value<GameControllerButton?>? gameControllerButton,
      Value<int?>? keyboardKeyId}) {
    return CommandTriggersCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      gameControllerButton: gameControllerButton ?? this.gameControllerButton,
      keyboardKeyId: keyboardKeyId ?? this.keyboardKeyId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (gameControllerButton.present) {
      final converter = $CommandTriggersTable.$convertergameControllerButtonn;
      map['game_controller_button'] =
          Variable<int>(converter.toSql(gameControllerButton.value));
    }
    if (keyboardKeyId.present) {
      map['keyboard_key_id'] = Variable<int>(keyboardKeyId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommandTriggersCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('gameControllerButton: $gameControllerButton, ')
          ..write('keyboardKeyId: $keyboardKeyId')
          ..write(')'))
        .toString();
  }
}

class $MenusTable extends Menus with TableInfo<$MenusTable, Menu> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Untitled Object'));
  static const VerificationMeta _musicIdMeta =
      const VerificationMeta('musicId');
  @override
  late final GeneratedColumn<int> musicId = GeneratedColumn<int>(
      'music_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES asset_references (id) ON DELETE SET NULL'));
  static const VerificationMeta _selectItemSoundIdMeta =
      const VerificationMeta('selectItemSoundId');
  @override
  late final GeneratedColumn<int> selectItemSoundId = GeneratedColumn<int>(
      'select_item_sound_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES asset_references (id) ON DELETE SET NULL'));
  static const VerificationMeta _activateItemSoundIdMeta =
      const VerificationMeta('activateItemSoundId');
  @override
  late final GeneratedColumn<int> activateItemSoundId = GeneratedColumn<int>(
      'activate_item_sound_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES asset_references (id) ON DELETE SET NULL'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, musicId, selectItemSoundId, activateItemSoundId];
  @override
  String get aliasedName => _alias ?? 'menus';
  @override
  String get actualTableName => 'menus';
  @override
  VerificationContext validateIntegrity(Insertable<Menu> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('music_id')) {
      context.handle(_musicIdMeta,
          musicId.isAcceptableOrUnknown(data['music_id']!, _musicIdMeta));
    }
    if (data.containsKey('select_item_sound_id')) {
      context.handle(
          _selectItemSoundIdMeta,
          selectItemSoundId.isAcceptableOrUnknown(
              data['select_item_sound_id']!, _selectItemSoundIdMeta));
    }
    if (data.containsKey('activate_item_sound_id')) {
      context.handle(
          _activateItemSoundIdMeta,
          activateItemSoundId.isAcceptableOrUnknown(
              data['activate_item_sound_id']!, _activateItemSoundIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Menu map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Menu(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      musicId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}music_id']),
      selectItemSoundId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}select_item_sound_id']),
      activateItemSoundId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}activate_item_sound_id']),
    );
  }

  @override
  $MenusTable createAlias(String alias) {
    return $MenusTable(attachedDatabase, alias);
  }
}

class Menu extends DataClass implements Insertable<Menu> {
  /// The primary key.
  final int id;

  /// The name of this object.
  final String name;

  /// The music to use for this menu.
  final int? musicId;

  /// The sound to use when selecting an item.
  final int? selectItemSoundId;

  /// The sound to use when selecting an item.
  final int? activateItemSoundId;
  const Menu(
      {required this.id,
      required this.name,
      this.musicId,
      this.selectItemSoundId,
      this.activateItemSoundId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || musicId != null) {
      map['music_id'] = Variable<int>(musicId);
    }
    if (!nullToAbsent || selectItemSoundId != null) {
      map['select_item_sound_id'] = Variable<int>(selectItemSoundId);
    }
    if (!nullToAbsent || activateItemSoundId != null) {
      map['activate_item_sound_id'] = Variable<int>(activateItemSoundId);
    }
    return map;
  }

  MenusCompanion toCompanion(bool nullToAbsent) {
    return MenusCompanion(
      id: Value(id),
      name: Value(name),
      musicId: musicId == null && nullToAbsent
          ? const Value.absent()
          : Value(musicId),
      selectItemSoundId: selectItemSoundId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectItemSoundId),
      activateItemSoundId: activateItemSoundId == null && nullToAbsent
          ? const Value.absent()
          : Value(activateItemSoundId),
    );
  }

  factory Menu.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Menu(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      musicId: serializer.fromJson<int?>(json['musicId']),
      selectItemSoundId: serializer.fromJson<int?>(json['selectItemSoundId']),
      activateItemSoundId:
          serializer.fromJson<int?>(json['activateItemSoundId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'musicId': serializer.toJson<int?>(musicId),
      'selectItemSoundId': serializer.toJson<int?>(selectItemSoundId),
      'activateItemSoundId': serializer.toJson<int?>(activateItemSoundId),
    };
  }

  Menu copyWith(
          {int? id,
          String? name,
          Value<int?> musicId = const Value.absent(),
          Value<int?> selectItemSoundId = const Value.absent(),
          Value<int?> activateItemSoundId = const Value.absent()}) =>
      Menu(
        id: id ?? this.id,
        name: name ?? this.name,
        musicId: musicId.present ? musicId.value : this.musicId,
        selectItemSoundId: selectItemSoundId.present
            ? selectItemSoundId.value
            : this.selectItemSoundId,
        activateItemSoundId: activateItemSoundId.present
            ? activateItemSoundId.value
            : this.activateItemSoundId,
      );
  @override
  String toString() {
    return (StringBuffer('Menu(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('musicId: $musicId, ')
          ..write('selectItemSoundId: $selectItemSoundId, ')
          ..write('activateItemSoundId: $activateItemSoundId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, musicId, selectItemSoundId, activateItemSoundId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Menu &&
          other.id == this.id &&
          other.name == this.name &&
          other.musicId == this.musicId &&
          other.selectItemSoundId == this.selectItemSoundId &&
          other.activateItemSoundId == this.activateItemSoundId);
}

class MenusCompanion extends UpdateCompanion<Menu> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> musicId;
  final Value<int?> selectItemSoundId;
  final Value<int?> activateItemSoundId;
  const MenusCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.musicId = const Value.absent(),
    this.selectItemSoundId = const Value.absent(),
    this.activateItemSoundId = const Value.absent(),
  });
  MenusCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.musicId = const Value.absent(),
    this.selectItemSoundId = const Value.absent(),
    this.activateItemSoundId = const Value.absent(),
  });
  static Insertable<Menu> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? musicId,
    Expression<int>? selectItemSoundId,
    Expression<int>? activateItemSoundId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (musicId != null) 'music_id': musicId,
      if (selectItemSoundId != null) 'select_item_sound_id': selectItemSoundId,
      if (activateItemSoundId != null)
        'activate_item_sound_id': activateItemSoundId,
    });
  }

  MenusCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int?>? musicId,
      Value<int?>? selectItemSoundId,
      Value<int?>? activateItemSoundId}) {
    return MenusCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      musicId: musicId ?? this.musicId,
      selectItemSoundId: selectItemSoundId ?? this.selectItemSoundId,
      activateItemSoundId: activateItemSoundId ?? this.activateItemSoundId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (musicId.present) {
      map['music_id'] = Variable<int>(musicId.value);
    }
    if (selectItemSoundId.present) {
      map['select_item_sound_id'] = Variable<int>(selectItemSoundId.value);
    }
    if (activateItemSoundId.present) {
      map['activate_item_sound_id'] = Variable<int>(activateItemSoundId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenusCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('musicId: $musicId, ')
          ..write('selectItemSoundId: $selectItemSoundId, ')
          ..write('activateItemSoundId: $activateItemSoundId')
          ..write(')'))
        .toString();
  }
}

class $MenuItemsTable extends MenuItems
    with TableInfo<$MenuItemsTable, MenuItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Untitled Object'));
  static const VerificationMeta _menuIdMeta = const VerificationMeta('menuId');
  @override
  late final GeneratedColumn<int> menuId = GeneratedColumn<int>(
      'menu_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES menus (id) ON DELETE CASCADE'));
  static const VerificationMeta _selectSoundIdMeta =
      const VerificationMeta('selectSoundId');
  @override
  late final GeneratedColumn<int> selectSoundId = GeneratedColumn<int>(
      'select_sound_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES asset_references (id) ON DELETE SET NULL'));
  static const VerificationMeta _activateSoundIdMeta =
      const VerificationMeta('activateSoundId');
  @override
  late final GeneratedColumn<int> activateSoundId = GeneratedColumn<int>(
      'activate_sound_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES asset_references (id) ON DELETE SET NULL'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, menuId, selectSoundId, activateSoundId, position];
  @override
  String get aliasedName => _alias ?? 'menu_items';
  @override
  String get actualTableName => 'menu_items';
  @override
  VerificationContext validateIntegrity(Insertable<MenuItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('menu_id')) {
      context.handle(_menuIdMeta,
          menuId.isAcceptableOrUnknown(data['menu_id']!, _menuIdMeta));
    } else if (isInserting) {
      context.missing(_menuIdMeta);
    }
    if (data.containsKey('select_sound_id')) {
      context.handle(
          _selectSoundIdMeta,
          selectSoundId.isAcceptableOrUnknown(
              data['select_sound_id']!, _selectSoundIdMeta));
    }
    if (data.containsKey('activate_sound_id')) {
      context.handle(
          _activateSoundIdMeta,
          activateSoundId.isAcceptableOrUnknown(
              data['activate_sound_id']!, _activateSoundIdMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      menuId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}menu_id'])!,
      selectSoundId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}select_sound_id']),
      activateSoundId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activate_sound_id']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
    );
  }

  @override
  $MenuItemsTable createAlias(String alias) {
    return $MenuItemsTable(attachedDatabase, alias);
  }
}

class MenuItem extends DataClass implements Insertable<MenuItem> {
  /// The primary key.
  final int id;

  /// The name of this object.
  final String name;

  /// The menu this menu item belongs to.
  final int menuId;

  /// The sound to use when this item is selected.
  final int? selectSoundId;

  /// The sound to use when this item is activated.
  final int? activateSoundId;

  /// The position of this item in the menu.
  final int position;
  const MenuItem(
      {required this.id,
      required this.name,
      required this.menuId,
      this.selectSoundId,
      this.activateSoundId,
      required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['menu_id'] = Variable<int>(menuId);
    if (!nullToAbsent || selectSoundId != null) {
      map['select_sound_id'] = Variable<int>(selectSoundId);
    }
    if (!nullToAbsent || activateSoundId != null) {
      map['activate_sound_id'] = Variable<int>(activateSoundId);
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  MenuItemsCompanion toCompanion(bool nullToAbsent) {
    return MenuItemsCompanion(
      id: Value(id),
      name: Value(name),
      menuId: Value(menuId),
      selectSoundId: selectSoundId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectSoundId),
      activateSoundId: activateSoundId == null && nullToAbsent
          ? const Value.absent()
          : Value(activateSoundId),
      position: Value(position),
    );
  }

  factory MenuItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      menuId: serializer.fromJson<int>(json['menuId']),
      selectSoundId: serializer.fromJson<int?>(json['selectSoundId']),
      activateSoundId: serializer.fromJson<int?>(json['activateSoundId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'menuId': serializer.toJson<int>(menuId),
      'selectSoundId': serializer.toJson<int?>(selectSoundId),
      'activateSoundId': serializer.toJson<int?>(activateSoundId),
      'position': serializer.toJson<int>(position),
    };
  }

  MenuItem copyWith(
          {int? id,
          String? name,
          int? menuId,
          Value<int?> selectSoundId = const Value.absent(),
          Value<int?> activateSoundId = const Value.absent(),
          int? position}) =>
      MenuItem(
        id: id ?? this.id,
        name: name ?? this.name,
        menuId: menuId ?? this.menuId,
        selectSoundId:
            selectSoundId.present ? selectSoundId.value : this.selectSoundId,
        activateSoundId: activateSoundId.present
            ? activateSoundId.value
            : this.activateSoundId,
        position: position ?? this.position,
      );
  @override
  String toString() {
    return (StringBuffer('MenuItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('menuId: $menuId, ')
          ..write('selectSoundId: $selectSoundId, ')
          ..write('activateSoundId: $activateSoundId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, menuId, selectSoundId, activateSoundId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.menuId == this.menuId &&
          other.selectSoundId == this.selectSoundId &&
          other.activateSoundId == this.activateSoundId &&
          other.position == this.position);
}

class MenuItemsCompanion extends UpdateCompanion<MenuItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> menuId;
  final Value<int?> selectSoundId;
  final Value<int?> activateSoundId;
  final Value<int> position;
  const MenuItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.menuId = const Value.absent(),
    this.selectSoundId = const Value.absent(),
    this.activateSoundId = const Value.absent(),
    this.position = const Value.absent(),
  });
  MenuItemsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    required int menuId,
    this.selectSoundId = const Value.absent(),
    this.activateSoundId = const Value.absent(),
    this.position = const Value.absent(),
  }) : menuId = Value(menuId);
  static Insertable<MenuItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? menuId,
    Expression<int>? selectSoundId,
    Expression<int>? activateSoundId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (menuId != null) 'menu_id': menuId,
      if (selectSoundId != null) 'select_sound_id': selectSoundId,
      if (activateSoundId != null) 'activate_sound_id': activateSoundId,
      if (position != null) 'position': position,
    });
  }

  MenuItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? menuId,
      Value<int?>? selectSoundId,
      Value<int?>? activateSoundId,
      Value<int>? position}) {
    return MenuItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      menuId: menuId ?? this.menuId,
      selectSoundId: selectSoundId ?? this.selectSoundId,
      activateSoundId: activateSoundId ?? this.activateSoundId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (menuId.present) {
      map['menu_id'] = Variable<int>(menuId.value);
    }
    if (selectSoundId.present) {
      map['select_sound_id'] = Variable<int>(selectSoundId.value);
    }
    if (activateSoundId.present) {
      map['activate_sound_id'] = Variable<int>(activateSoundId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('menuId: $menuId, ')
          ..write('selectSoundId: $selectSoundId, ')
          ..write('activateSoundId: $activateSoundId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $PushMenusTable extends PushMenus
    with TableInfo<$PushMenusTable, PushMenu> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PushMenusTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _afterMeta = const VerificationMeta('after');
  @override
  late final GeneratedColumn<int> after = GeneratedColumn<int>(
      'after', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fadeLengthMeta =
      const VerificationMeta('fadeLength');
  @override
  late final GeneratedColumn<double> fadeLength = GeneratedColumn<double>(
      'fade_length', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _menuIdMeta = const VerificationMeta('menuId');
  @override
  late final GeneratedColumn<int> menuId = GeneratedColumn<int>(
      'menu_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES menus (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [id, after, fadeLength, menuId];
  @override
  String get aliasedName => _alias ?? 'push_menus';
  @override
  String get actualTableName => 'push_menus';
  @override
  VerificationContext validateIntegrity(Insertable<PushMenu> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('after')) {
      context.handle(
          _afterMeta, after.isAcceptableOrUnknown(data['after']!, _afterMeta));
    }
    if (data.containsKey('fade_length')) {
      context.handle(
          _fadeLengthMeta,
          fadeLength.isAcceptableOrUnknown(
              data['fade_length']!, _fadeLengthMeta));
    }
    if (data.containsKey('menu_id')) {
      context.handle(_menuIdMeta,
          menuId.isAcceptableOrUnknown(data['menu_id']!, _menuIdMeta));
    } else if (isInserting) {
      context.missing(_menuIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PushMenu map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PushMenu(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      after: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}after']),
      fadeLength: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fade_length']),
      menuId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}menu_id'])!,
    );
  }

  @override
  $PushMenusTable createAlias(String alias) {
    return $PushMenusTable(attachedDatabase, alias);
  }
}

class PushMenu extends DataClass implements Insertable<PushMenu> {
  /// The primary key.
  final int id;

  /// How many milliseconds to wait before doing something.
  final int? after;

  /// The fade length to use when pushing a level.
  final double? fadeLength;

  /// The ID of the menu to push.
  final int menuId;
  const PushMenu(
      {required this.id, this.after, this.fadeLength, required this.menuId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || after != null) {
      map['after'] = Variable<int>(after);
    }
    if (!nullToAbsent || fadeLength != null) {
      map['fade_length'] = Variable<double>(fadeLength);
    }
    map['menu_id'] = Variable<int>(menuId);
    return map;
  }

  PushMenusCompanion toCompanion(bool nullToAbsent) {
    return PushMenusCompanion(
      id: Value(id),
      after:
          after == null && nullToAbsent ? const Value.absent() : Value(after),
      fadeLength: fadeLength == null && nullToAbsent
          ? const Value.absent()
          : Value(fadeLength),
      menuId: Value(menuId),
    );
  }

  factory PushMenu.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PushMenu(
      id: serializer.fromJson<int>(json['id']),
      after: serializer.fromJson<int?>(json['after']),
      fadeLength: serializer.fromJson<double?>(json['fadeLength']),
      menuId: serializer.fromJson<int>(json['menuId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'after': serializer.toJson<int?>(after),
      'fadeLength': serializer.toJson<double?>(fadeLength),
      'menuId': serializer.toJson<int>(menuId),
    };
  }

  PushMenu copyWith(
          {int? id,
          Value<int?> after = const Value.absent(),
          Value<double?> fadeLength = const Value.absent(),
          int? menuId}) =>
      PushMenu(
        id: id ?? this.id,
        after: after.present ? after.value : this.after,
        fadeLength: fadeLength.present ? fadeLength.value : this.fadeLength,
        menuId: menuId ?? this.menuId,
      );
  @override
  String toString() {
    return (StringBuffer('PushMenu(')
          ..write('id: $id, ')
          ..write('after: $after, ')
          ..write('fadeLength: $fadeLength, ')
          ..write('menuId: $menuId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, after, fadeLength, menuId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PushMenu &&
          other.id == this.id &&
          other.after == this.after &&
          other.fadeLength == this.fadeLength &&
          other.menuId == this.menuId);
}

class PushMenusCompanion extends UpdateCompanion<PushMenu> {
  final Value<int> id;
  final Value<int?> after;
  final Value<double?> fadeLength;
  final Value<int> menuId;
  const PushMenusCompanion({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.fadeLength = const Value.absent(),
    this.menuId = const Value.absent(),
  });
  PushMenusCompanion.insert({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.fadeLength = const Value.absent(),
    required int menuId,
  }) : menuId = Value(menuId);
  static Insertable<PushMenu> custom({
    Expression<int>? id,
    Expression<int>? after,
    Expression<double>? fadeLength,
    Expression<int>? menuId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (after != null) 'after': after,
      if (fadeLength != null) 'fade_length': fadeLength,
      if (menuId != null) 'menu_id': menuId,
    });
  }

  PushMenusCompanion copyWith(
      {Value<int>? id,
      Value<int?>? after,
      Value<double?>? fadeLength,
      Value<int>? menuId}) {
    return PushMenusCompanion(
      id: id ?? this.id,
      after: after ?? this.after,
      fadeLength: fadeLength ?? this.fadeLength,
      menuId: menuId ?? this.menuId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (after.present) {
      map['after'] = Variable<int>(after.value);
    }
    if (fadeLength.present) {
      map['fade_length'] = Variable<double>(fadeLength.value);
    }
    if (menuId.present) {
      map['menu_id'] = Variable<int>(menuId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PushMenusCompanion(')
          ..write('id: $id, ')
          ..write('after: $after, ')
          ..write('fadeLength: $fadeLength, ')
          ..write('menuId: $menuId')
          ..write(')'))
        .toString();
  }
}

class $PopLevelsTable extends PopLevels
    with TableInfo<$PopLevelsTable, PopLevel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PopLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fadeLengthMeta =
      const VerificationMeta('fadeLength');
  @override
  late final GeneratedColumn<double> fadeLength = GeneratedColumn<double>(
      'fade_length', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, fadeLength];
  @override
  String get aliasedName => _alias ?? 'pop_levels';
  @override
  String get actualTableName => 'pop_levels';
  @override
  VerificationContext validateIntegrity(Insertable<PopLevel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fade_length')) {
      context.handle(
          _fadeLengthMeta,
          fadeLength.isAcceptableOrUnknown(
              data['fade_length']!, _fadeLengthMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PopLevel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PopLevel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fadeLength: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fade_length']),
    );
  }

  @override
  $PopLevelsTable createAlias(String alias) {
    return $PopLevelsTable(attachedDatabase, alias);
  }
}

class PopLevel extends DataClass implements Insertable<PopLevel> {
  /// The primary key.
  final int id;

  /// The fade length to use when pushing a level.
  final double? fadeLength;
  const PopLevel({required this.id, this.fadeLength});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || fadeLength != null) {
      map['fade_length'] = Variable<double>(fadeLength);
    }
    return map;
  }

  PopLevelsCompanion toCompanion(bool nullToAbsent) {
    return PopLevelsCompanion(
      id: Value(id),
      fadeLength: fadeLength == null && nullToAbsent
          ? const Value.absent()
          : Value(fadeLength),
    );
  }

  factory PopLevel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PopLevel(
      id: serializer.fromJson<int>(json['id']),
      fadeLength: serializer.fromJson<double?>(json['fadeLength']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fadeLength': serializer.toJson<double?>(fadeLength),
    };
  }

  PopLevel copyWith(
          {int? id, Value<double?> fadeLength = const Value.absent()}) =>
      PopLevel(
        id: id ?? this.id,
        fadeLength: fadeLength.present ? fadeLength.value : this.fadeLength,
      );
  @override
  String toString() {
    return (StringBuffer('PopLevel(')
          ..write('id: $id, ')
          ..write('fadeLength: $fadeLength')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fadeLength);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PopLevel &&
          other.id == this.id &&
          other.fadeLength == this.fadeLength);
}

class PopLevelsCompanion extends UpdateCompanion<PopLevel> {
  final Value<int> id;
  final Value<double?> fadeLength;
  const PopLevelsCompanion({
    this.id = const Value.absent(),
    this.fadeLength = const Value.absent(),
  });
  PopLevelsCompanion.insert({
    this.id = const Value.absent(),
    this.fadeLength = const Value.absent(),
  });
  static Insertable<PopLevel> custom({
    Expression<int>? id,
    Expression<double>? fadeLength,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fadeLength != null) 'fade_length': fadeLength,
    });
  }

  PopLevelsCompanion copyWith({Value<int>? id, Value<double?>? fadeLength}) {
    return PopLevelsCompanion(
      id: id ?? this.id,
      fadeLength: fadeLength ?? this.fadeLength,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fadeLength.present) {
      map['fade_length'] = Variable<double>(fadeLength.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PopLevelsCompanion(')
          ..write('id: $id, ')
          ..write('fadeLength: $fadeLength')
          ..write(')'))
        .toString();
  }
}

class $StopGamesTable extends StopGames
    with TableInfo<$StopGamesTable, StopGame> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StopGamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _afterMeta = const VerificationMeta('after');
  @override
  late final GeneratedColumn<int> after = GeneratedColumn<int>(
      'after', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, after];
  @override
  String get aliasedName => _alias ?? 'stop_games';
  @override
  String get actualTableName => 'stop_games';
  @override
  VerificationContext validateIntegrity(Insertable<StopGame> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('after')) {
      context.handle(
          _afterMeta, after.isAcceptableOrUnknown(data['after']!, _afterMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StopGame map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StopGame(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      after: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}after']),
    );
  }

  @override
  $StopGamesTable createAlias(String alias) {
    return $StopGamesTable(attachedDatabase, alias);
  }
}

class StopGame extends DataClass implements Insertable<StopGame> {
  /// The primary key.
  final int id;

  /// How many milliseconds to wait before doing something.
  final int? after;
  const StopGame({required this.id, this.after});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || after != null) {
      map['after'] = Variable<int>(after);
    }
    return map;
  }

  StopGamesCompanion toCompanion(bool nullToAbsent) {
    return StopGamesCompanion(
      id: Value(id),
      after:
          after == null && nullToAbsent ? const Value.absent() : Value(after),
    );
  }

  factory StopGame.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StopGame(
      id: serializer.fromJson<int>(json['id']),
      after: serializer.fromJson<int?>(json['after']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'after': serializer.toJson<int?>(after),
    };
  }

  StopGame copyWith({int? id, Value<int?> after = const Value.absent()}) =>
      StopGame(
        id: id ?? this.id,
        after: after.present ? after.value : this.after,
      );
  @override
  String toString() {
    return (StringBuffer('StopGame(')
          ..write('id: $id, ')
          ..write('after: $after')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, after);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StopGame && other.id == this.id && other.after == this.after);
}

class StopGamesCompanion extends UpdateCompanion<StopGame> {
  final Value<int> id;
  final Value<int?> after;
  const StopGamesCompanion({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
  });
  StopGamesCompanion.insert({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
  });
  static Insertable<StopGame> custom({
    Expression<int>? id,
    Expression<int>? after,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (after != null) 'after': after,
    });
  }

  StopGamesCompanion copyWith({Value<int>? id, Value<int?>? after}) {
    return StopGamesCompanion(
      id: id ?? this.id,
      after: after ?? this.after,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (after.present) {
      map['after'] = Variable<int>(after.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StopGamesCompanion(')
          ..write('id: $id, ')
          ..write('after: $after')
          ..write(')'))
        .toString();
  }
}

class $CommandsTable extends Commands with TableInfo<$CommandsTable, Command> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pushMenuIdMeta =
      const VerificationMeta('pushMenuId');
  @override
  late final GeneratedColumn<int> pushMenuId = GeneratedColumn<int>(
      'push_menu_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES push_menus (id) ON DELETE SET NULL'));
  static const VerificationMeta _messageTextMeta =
      const VerificationMeta('messageText');
  @override
  late final GeneratedColumn<String> messageText = GeneratedColumn<String>(
      'message_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _messageSoundIdMeta =
      const VerificationMeta('messageSoundId');
  @override
  late final GeneratedColumn<int> messageSoundId = GeneratedColumn<int>(
      'message_sound_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES asset_references (id) ON DELETE SET NULL'));
  static const VerificationMeta _popLevelIdMeta =
      const VerificationMeta('popLevelId');
  @override
  late final GeneratedColumn<int> popLevelId = GeneratedColumn<int>(
      'pop_level_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES pop_levels (id) ON DELETE SET NULL'));
  static const VerificationMeta _stopGameIdMeta =
      const VerificationMeta('stopGameId');
  @override
  late final GeneratedColumn<int> stopGameId = GeneratedColumn<int>(
      'stop_game_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES stop_games (id) ON DELETE SET NULL'));
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pushMenuId,
        messageText,
        messageSoundId,
        popLevelId,
        stopGameId,
        url
      ];
  @override
  String get aliasedName => _alias ?? 'commands';
  @override
  String get actualTableName => 'commands';
  @override
  VerificationContext validateIntegrity(Insertable<Command> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('push_menu_id')) {
      context.handle(
          _pushMenuIdMeta,
          pushMenuId.isAcceptableOrUnknown(
              data['push_menu_id']!, _pushMenuIdMeta));
    }
    if (data.containsKey('message_text')) {
      context.handle(
          _messageTextMeta,
          messageText.isAcceptableOrUnknown(
              data['message_text']!, _messageTextMeta));
    }
    if (data.containsKey('message_sound_id')) {
      context.handle(
          _messageSoundIdMeta,
          messageSoundId.isAcceptableOrUnknown(
              data['message_sound_id']!, _messageSoundIdMeta));
    }
    if (data.containsKey('pop_level_id')) {
      context.handle(
          _popLevelIdMeta,
          popLevelId.isAcceptableOrUnknown(
              data['pop_level_id']!, _popLevelIdMeta));
    }
    if (data.containsKey('stop_game_id')) {
      context.handle(
          _stopGameIdMeta,
          stopGameId.isAcceptableOrUnknown(
              data['stop_game_id']!, _stopGameIdMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Command map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Command(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pushMenuId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}push_menu_id']),
      messageText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_text']),
      messageSoundId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}message_sound_id']),
      popLevelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pop_level_id']),
      stopGameId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stop_game_id']),
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url']),
    );
  }

  @override
  $CommandsTable createAlias(String alias) {
    return $CommandsTable(attachedDatabase, alias);
  }
}

class Command extends DataClass implements Insertable<Command> {
  /// The primary key.
  final int id;

  /// The ID of a menu to push.
  final int? pushMenuId;

  /// Some text to output.
  final String? messageText;

  /// The ID of a sound to play.
  final int? messageSoundId;

  /// How to pop a level.
  final int? popLevelId;

  /// The ID of a stop game.
  final int? stopGameId;

  /// A URL to open.
  final String? url;
  const Command(
      {required this.id,
      this.pushMenuId,
      this.messageText,
      this.messageSoundId,
      this.popLevelId,
      this.stopGameId,
      this.url});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || pushMenuId != null) {
      map['push_menu_id'] = Variable<int>(pushMenuId);
    }
    if (!nullToAbsent || messageText != null) {
      map['message_text'] = Variable<String>(messageText);
    }
    if (!nullToAbsent || messageSoundId != null) {
      map['message_sound_id'] = Variable<int>(messageSoundId);
    }
    if (!nullToAbsent || popLevelId != null) {
      map['pop_level_id'] = Variable<int>(popLevelId);
    }
    if (!nullToAbsent || stopGameId != null) {
      map['stop_game_id'] = Variable<int>(stopGameId);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    return map;
  }

  CommandsCompanion toCompanion(bool nullToAbsent) {
    return CommandsCompanion(
      id: Value(id),
      pushMenuId: pushMenuId == null && nullToAbsent
          ? const Value.absent()
          : Value(pushMenuId),
      messageText: messageText == null && nullToAbsent
          ? const Value.absent()
          : Value(messageText),
      messageSoundId: messageSoundId == null && nullToAbsent
          ? const Value.absent()
          : Value(messageSoundId),
      popLevelId: popLevelId == null && nullToAbsent
          ? const Value.absent()
          : Value(popLevelId),
      stopGameId: stopGameId == null && nullToAbsent
          ? const Value.absent()
          : Value(stopGameId),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
    );
  }

  factory Command.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Command(
      id: serializer.fromJson<int>(json['id']),
      pushMenuId: serializer.fromJson<int?>(json['pushMenuId']),
      messageText: serializer.fromJson<String?>(json['messageText']),
      messageSoundId: serializer.fromJson<int?>(json['messageSoundId']),
      popLevelId: serializer.fromJson<int?>(json['popLevelId']),
      stopGameId: serializer.fromJson<int?>(json['stopGameId']),
      url: serializer.fromJson<String?>(json['url']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pushMenuId': serializer.toJson<int?>(pushMenuId),
      'messageText': serializer.toJson<String?>(messageText),
      'messageSoundId': serializer.toJson<int?>(messageSoundId),
      'popLevelId': serializer.toJson<int?>(popLevelId),
      'stopGameId': serializer.toJson<int?>(stopGameId),
      'url': serializer.toJson<String?>(url),
    };
  }

  Command copyWith(
          {int? id,
          Value<int?> pushMenuId = const Value.absent(),
          Value<String?> messageText = const Value.absent(),
          Value<int?> messageSoundId = const Value.absent(),
          Value<int?> popLevelId = const Value.absent(),
          Value<int?> stopGameId = const Value.absent(),
          Value<String?> url = const Value.absent()}) =>
      Command(
        id: id ?? this.id,
        pushMenuId: pushMenuId.present ? pushMenuId.value : this.pushMenuId,
        messageText: messageText.present ? messageText.value : this.messageText,
        messageSoundId:
            messageSoundId.present ? messageSoundId.value : this.messageSoundId,
        popLevelId: popLevelId.present ? popLevelId.value : this.popLevelId,
        stopGameId: stopGameId.present ? stopGameId.value : this.stopGameId,
        url: url.present ? url.value : this.url,
      );
  @override
  String toString() {
    return (StringBuffer('Command(')
          ..write('id: $id, ')
          ..write('pushMenuId: $pushMenuId, ')
          ..write('messageText: $messageText, ')
          ..write('messageSoundId: $messageSoundId, ')
          ..write('popLevelId: $popLevelId, ')
          ..write('stopGameId: $stopGameId, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, pushMenuId, messageText, messageSoundId, popLevelId, stopGameId, url);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Command &&
          other.id == this.id &&
          other.pushMenuId == this.pushMenuId &&
          other.messageText == this.messageText &&
          other.messageSoundId == this.messageSoundId &&
          other.popLevelId == this.popLevelId &&
          other.stopGameId == this.stopGameId &&
          other.url == this.url);
}

class CommandsCompanion extends UpdateCompanion<Command> {
  final Value<int> id;
  final Value<int?> pushMenuId;
  final Value<String?> messageText;
  final Value<int?> messageSoundId;
  final Value<int?> popLevelId;
  final Value<int?> stopGameId;
  final Value<String?> url;
  const CommandsCompanion({
    this.id = const Value.absent(),
    this.pushMenuId = const Value.absent(),
    this.messageText = const Value.absent(),
    this.messageSoundId = const Value.absent(),
    this.popLevelId = const Value.absent(),
    this.stopGameId = const Value.absent(),
    this.url = const Value.absent(),
  });
  CommandsCompanion.insert({
    this.id = const Value.absent(),
    this.pushMenuId = const Value.absent(),
    this.messageText = const Value.absent(),
    this.messageSoundId = const Value.absent(),
    this.popLevelId = const Value.absent(),
    this.stopGameId = const Value.absent(),
    this.url = const Value.absent(),
  });
  static Insertable<Command> custom({
    Expression<int>? id,
    Expression<int>? pushMenuId,
    Expression<String>? messageText,
    Expression<int>? messageSoundId,
    Expression<int>? popLevelId,
    Expression<int>? stopGameId,
    Expression<String>? url,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pushMenuId != null) 'push_menu_id': pushMenuId,
      if (messageText != null) 'message_text': messageText,
      if (messageSoundId != null) 'message_sound_id': messageSoundId,
      if (popLevelId != null) 'pop_level_id': popLevelId,
      if (stopGameId != null) 'stop_game_id': stopGameId,
      if (url != null) 'url': url,
    });
  }

  CommandsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? pushMenuId,
      Value<String?>? messageText,
      Value<int?>? messageSoundId,
      Value<int?>? popLevelId,
      Value<int?>? stopGameId,
      Value<String?>? url}) {
    return CommandsCompanion(
      id: id ?? this.id,
      pushMenuId: pushMenuId ?? this.pushMenuId,
      messageText: messageText ?? this.messageText,
      messageSoundId: messageSoundId ?? this.messageSoundId,
      popLevelId: popLevelId ?? this.popLevelId,
      stopGameId: stopGameId ?? this.stopGameId,
      url: url ?? this.url,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pushMenuId.present) {
      map['push_menu_id'] = Variable<int>(pushMenuId.value);
    }
    if (messageText.present) {
      map['message_text'] = Variable<String>(messageText.value);
    }
    if (messageSoundId.present) {
      map['message_sound_id'] = Variable<int>(messageSoundId.value);
    }
    if (popLevelId.present) {
      map['pop_level_id'] = Variable<int>(popLevelId.value);
    }
    if (stopGameId.present) {
      map['stop_game_id'] = Variable<int>(stopGameId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommandsCompanion(')
          ..write('id: $id, ')
          ..write('pushMenuId: $pushMenuId, ')
          ..write('messageText: $messageText, ')
          ..write('messageSoundId: $messageSoundId, ')
          ..write('popLevelId: $popLevelId, ')
          ..write('stopGameId: $stopGameId, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }
}

class $CustomLevelsTable extends CustomLevels
    with TableInfo<$CustomLevelsTable, CustomLevel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Untitled Object'));
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'custom_levels';
  @override
  String get actualTableName => 'custom_levels';
  @override
  VerificationContext validateIntegrity(Insertable<CustomLevel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomLevel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomLevel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $CustomLevelsTable createAlias(String alias) {
    return $CustomLevelsTable(attachedDatabase, alias);
  }
}

class CustomLevel extends DataClass implements Insertable<CustomLevel> {
  /// The primary key.
  final int id;

  /// The name of this object.
  final String name;
  const CustomLevel({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  CustomLevelsCompanion toCompanion(bool nullToAbsent) {
    return CustomLevelsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory CustomLevel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomLevel(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  CustomLevel copyWith({int? id, String? name}) => CustomLevel(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('CustomLevel(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomLevel && other.id == this.id && other.name == this.name);
}

class CustomLevelsCompanion extends UpdateCompanion<CustomLevel> {
  final Value<int> id;
  final Value<String> name;
  const CustomLevelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  CustomLevelsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  static Insertable<CustomLevel> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  CustomLevelsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return CustomLevelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomLevelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $CustomLevelCommandsTable extends CustomLevelCommands
    with TableInfo<$CustomLevelCommandsTable, CustomLevelCommand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomLevelCommandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _customLevelIdMeta =
      const VerificationMeta('customLevelId');
  @override
  late final GeneratedColumn<int> customLevelId = GeneratedColumn<int>(
      'custom_level_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES custom_levels (id) ON DELETE CASCADE'));
  static const VerificationMeta _commandTriggerIdMeta =
      const VerificationMeta('commandTriggerId');
  @override
  late final GeneratedColumn<int> commandTriggerId = GeneratedColumn<int>(
      'command_trigger_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES command_triggers (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [id, customLevelId, commandTriggerId];
  @override
  String get aliasedName => _alias ?? 'custom_level_commands';
  @override
  String get actualTableName => 'custom_level_commands';
  @override
  VerificationContext validateIntegrity(Insertable<CustomLevelCommand> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('custom_level_id')) {
      context.handle(
          _customLevelIdMeta,
          customLevelId.isAcceptableOrUnknown(
              data['custom_level_id']!, _customLevelIdMeta));
    } else if (isInserting) {
      context.missing(_customLevelIdMeta);
    }
    if (data.containsKey('command_trigger_id')) {
      context.handle(
          _commandTriggerIdMeta,
          commandTriggerId.isAcceptableOrUnknown(
              data['command_trigger_id']!, _commandTriggerIdMeta));
    } else if (isInserting) {
      context.missing(_commandTriggerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomLevelCommand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomLevelCommand(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      customLevelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}custom_level_id'])!,
      commandTriggerId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}command_trigger_id'])!,
    );
  }

  @override
  $CustomLevelCommandsTable createAlias(String alias) {
    return $CustomLevelCommandsTable(attachedDatabase, alias);
  }
}

class CustomLevelCommand extends DataClass
    implements Insertable<CustomLevelCommand> {
  /// The primary key.
  final int id;

  /// The ID of the custom level to attach to.
  final int customLevelId;

  /// The ID of the trigger to use.
  final int commandTriggerId;
  const CustomLevelCommand(
      {required this.id,
      required this.customLevelId,
      required this.commandTriggerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['custom_level_id'] = Variable<int>(customLevelId);
    map['command_trigger_id'] = Variable<int>(commandTriggerId);
    return map;
  }

  CustomLevelCommandsCompanion toCompanion(bool nullToAbsent) {
    return CustomLevelCommandsCompanion(
      id: Value(id),
      customLevelId: Value(customLevelId),
      commandTriggerId: Value(commandTriggerId),
    );
  }

  factory CustomLevelCommand.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomLevelCommand(
      id: serializer.fromJson<int>(json['id']),
      customLevelId: serializer.fromJson<int>(json['customLevelId']),
      commandTriggerId: serializer.fromJson<int>(json['commandTriggerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customLevelId': serializer.toJson<int>(customLevelId),
      'commandTriggerId': serializer.toJson<int>(commandTriggerId),
    };
  }

  CustomLevelCommand copyWith(
          {int? id, int? customLevelId, int? commandTriggerId}) =>
      CustomLevelCommand(
        id: id ?? this.id,
        customLevelId: customLevelId ?? this.customLevelId,
        commandTriggerId: commandTriggerId ?? this.commandTriggerId,
      );
  @override
  String toString() {
    return (StringBuffer('CustomLevelCommand(')
          ..write('id: $id, ')
          ..write('customLevelId: $customLevelId, ')
          ..write('commandTriggerId: $commandTriggerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, customLevelId, commandTriggerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomLevelCommand &&
          other.id == this.id &&
          other.customLevelId == this.customLevelId &&
          other.commandTriggerId == this.commandTriggerId);
}

class CustomLevelCommandsCompanion extends UpdateCompanion<CustomLevelCommand> {
  final Value<int> id;
  final Value<int> customLevelId;
  final Value<int> commandTriggerId;
  const CustomLevelCommandsCompanion({
    this.id = const Value.absent(),
    this.customLevelId = const Value.absent(),
    this.commandTriggerId = const Value.absent(),
  });
  CustomLevelCommandsCompanion.insert({
    this.id = const Value.absent(),
    required int customLevelId,
    required int commandTriggerId,
  })  : customLevelId = Value(customLevelId),
        commandTriggerId = Value(commandTriggerId);
  static Insertable<CustomLevelCommand> custom({
    Expression<int>? id,
    Expression<int>? customLevelId,
    Expression<int>? commandTriggerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customLevelId != null) 'custom_level_id': customLevelId,
      if (commandTriggerId != null) 'command_trigger_id': commandTriggerId,
    });
  }

  CustomLevelCommandsCompanion copyWith(
      {Value<int>? id,
      Value<int>? customLevelId,
      Value<int>? commandTriggerId}) {
    return CustomLevelCommandsCompanion(
      id: id ?? this.id,
      customLevelId: customLevelId ?? this.customLevelId,
      commandTriggerId: commandTriggerId ?? this.commandTriggerId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customLevelId.present) {
      map['custom_level_id'] = Variable<int>(customLevelId.value);
    }
    if (commandTriggerId.present) {
      map['command_trigger_id'] = Variable<int>(commandTriggerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomLevelCommandsCompanion(')
          ..write('id: $id, ')
          ..write('customLevelId: $customLevelId, ')
          ..write('commandTriggerId: $commandTriggerId')
          ..write(')'))
        .toString();
  }
}

class $CallCommandsTable extends CallCommands
    with TableInfo<$CallCommandsTable, CallCommand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CallCommandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _afterMeta = const VerificationMeta('after');
  @override
  late final GeneratedColumn<int> after = GeneratedColumn<int>(
      'after', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _callingCommandIdMeta =
      const VerificationMeta('callingCommandId');
  @override
  late final GeneratedColumn<int> callingCommandId = GeneratedColumn<int>(
      'calling_command_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES commands (id) ON DELETE CASCADE'));
  static const VerificationMeta _callingMenuItemIdMeta =
      const VerificationMeta('callingMenuItemId');
  @override
  late final GeneratedColumn<int> callingMenuItemId = GeneratedColumn<int>(
      'calling_menu_item_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES menu_items (id) ON DELETE CASCADE'));
  static const VerificationMeta _onCancelMenuIdMeta =
      const VerificationMeta('onCancelMenuId');
  @override
  late final GeneratedColumn<int> onCancelMenuId = GeneratedColumn<int>(
      'on_cancel_menu_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES menus (id) ON DELETE CASCADE'));
  static const VerificationMeta _customLevelCommandIdMeta =
      const VerificationMeta('customLevelCommandId');
  @override
  late final GeneratedColumn<int> customLevelCommandId = GeneratedColumn<int>(
      'custom_level_command_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES custom_level_commands (id) ON DELETE CASCADE'));
  static const VerificationMeta _commandIdMeta =
      const VerificationMeta('commandId');
  @override
  late final GeneratedColumn<int> commandId = GeneratedColumn<int>(
      'command_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES commands (id) ON DELETE CASCADE'));
  static const VerificationMeta _randomNumberBaseMeta =
      const VerificationMeta('randomNumberBase');
  @override
  late final GeneratedColumn<int> randomNumberBase = GeneratedColumn<int>(
      'random_number_base', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        after,
        callingCommandId,
        callingMenuItemId,
        onCancelMenuId,
        customLevelCommandId,
        commandId,
        randomNumberBase
      ];
  @override
  String get aliasedName => _alias ?? 'call_commands';
  @override
  String get actualTableName => 'call_commands';
  @override
  VerificationContext validateIntegrity(Insertable<CallCommand> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('after')) {
      context.handle(
          _afterMeta, after.isAcceptableOrUnknown(data['after']!, _afterMeta));
    }
    if (data.containsKey('calling_command_id')) {
      context.handle(
          _callingCommandIdMeta,
          callingCommandId.isAcceptableOrUnknown(
              data['calling_command_id']!, _callingCommandIdMeta));
    }
    if (data.containsKey('calling_menu_item_id')) {
      context.handle(
          _callingMenuItemIdMeta,
          callingMenuItemId.isAcceptableOrUnknown(
              data['calling_menu_item_id']!, _callingMenuItemIdMeta));
    }
    if (data.containsKey('on_cancel_menu_id')) {
      context.handle(
          _onCancelMenuIdMeta,
          onCancelMenuId.isAcceptableOrUnknown(
              data['on_cancel_menu_id']!, _onCancelMenuIdMeta));
    }
    if (data.containsKey('custom_level_command_id')) {
      context.handle(
          _customLevelCommandIdMeta,
          customLevelCommandId.isAcceptableOrUnknown(
              data['custom_level_command_id']!, _customLevelCommandIdMeta));
    }
    if (data.containsKey('command_id')) {
      context.handle(_commandIdMeta,
          commandId.isAcceptableOrUnknown(data['command_id']!, _commandIdMeta));
    } else if (isInserting) {
      context.missing(_commandIdMeta);
    }
    if (data.containsKey('random_number_base')) {
      context.handle(
          _randomNumberBaseMeta,
          randomNumberBase.isAcceptableOrUnknown(
              data['random_number_base']!, _randomNumberBaseMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CallCommand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CallCommand(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      after: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}after']),
      callingCommandId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}calling_command_id']),
      callingMenuItemId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}calling_menu_item_id']),
      onCancelMenuId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}on_cancel_menu_id']),
      customLevelCommandId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}custom_level_command_id']),
      commandId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}command_id'])!,
      randomNumberBase: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}random_number_base']),
    );
  }

  @override
  $CallCommandsTable createAlias(String alias) {
    return $CallCommandsTable(attachedDatabase, alias);
  }
}

class CallCommand extends DataClass implements Insertable<CallCommand> {
  /// The primary key.
  final int id;

  /// How many milliseconds to wait before doing something.
  final int? after;

  /// The ID of the command that will call this row.
  final int? callingCommandId;

  /// The ID of the menu item that will call this command.
  final int? callingMenuItemId;

  /// The ID of the menu whose on cancel action will call this command.
  final int? onCancelMenuId;

  /// The ID of the custom level command which will call this command.
  final int? customLevelCommandId;

  /// The ID of the command to call.
  final int commandId;

  /// A random number to use to decide whether or not this command will run.
  final int? randomNumberBase;
  const CallCommand(
      {required this.id,
      this.after,
      this.callingCommandId,
      this.callingMenuItemId,
      this.onCancelMenuId,
      this.customLevelCommandId,
      required this.commandId,
      this.randomNumberBase});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || after != null) {
      map['after'] = Variable<int>(after);
    }
    if (!nullToAbsent || callingCommandId != null) {
      map['calling_command_id'] = Variable<int>(callingCommandId);
    }
    if (!nullToAbsent || callingMenuItemId != null) {
      map['calling_menu_item_id'] = Variable<int>(callingMenuItemId);
    }
    if (!nullToAbsent || onCancelMenuId != null) {
      map['on_cancel_menu_id'] = Variable<int>(onCancelMenuId);
    }
    if (!nullToAbsent || customLevelCommandId != null) {
      map['custom_level_command_id'] = Variable<int>(customLevelCommandId);
    }
    map['command_id'] = Variable<int>(commandId);
    if (!nullToAbsent || randomNumberBase != null) {
      map['random_number_base'] = Variable<int>(randomNumberBase);
    }
    return map;
  }

  CallCommandsCompanion toCompanion(bool nullToAbsent) {
    return CallCommandsCompanion(
      id: Value(id),
      after:
          after == null && nullToAbsent ? const Value.absent() : Value(after),
      callingCommandId: callingCommandId == null && nullToAbsent
          ? const Value.absent()
          : Value(callingCommandId),
      callingMenuItemId: callingMenuItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(callingMenuItemId),
      onCancelMenuId: onCancelMenuId == null && nullToAbsent
          ? const Value.absent()
          : Value(onCancelMenuId),
      customLevelCommandId: customLevelCommandId == null && nullToAbsent
          ? const Value.absent()
          : Value(customLevelCommandId),
      commandId: Value(commandId),
      randomNumberBase: randomNumberBase == null && nullToAbsent
          ? const Value.absent()
          : Value(randomNumberBase),
    );
  }

  factory CallCommand.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CallCommand(
      id: serializer.fromJson<int>(json['id']),
      after: serializer.fromJson<int?>(json['after']),
      callingCommandId: serializer.fromJson<int?>(json['callingCommandId']),
      callingMenuItemId: serializer.fromJson<int?>(json['callingMenuItemId']),
      onCancelMenuId: serializer.fromJson<int?>(json['onCancelMenuId']),
      customLevelCommandId:
          serializer.fromJson<int?>(json['customLevelCommandId']),
      commandId: serializer.fromJson<int>(json['commandId']),
      randomNumberBase: serializer.fromJson<int?>(json['randomNumberBase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'after': serializer.toJson<int?>(after),
      'callingCommandId': serializer.toJson<int?>(callingCommandId),
      'callingMenuItemId': serializer.toJson<int?>(callingMenuItemId),
      'onCancelMenuId': serializer.toJson<int?>(onCancelMenuId),
      'customLevelCommandId': serializer.toJson<int?>(customLevelCommandId),
      'commandId': serializer.toJson<int>(commandId),
      'randomNumberBase': serializer.toJson<int?>(randomNumberBase),
    };
  }

  CallCommand copyWith(
          {int? id,
          Value<int?> after = const Value.absent(),
          Value<int?> callingCommandId = const Value.absent(),
          Value<int?> callingMenuItemId = const Value.absent(),
          Value<int?> onCancelMenuId = const Value.absent(),
          Value<int?> customLevelCommandId = const Value.absent(),
          int? commandId,
          Value<int?> randomNumberBase = const Value.absent()}) =>
      CallCommand(
        id: id ?? this.id,
        after: after.present ? after.value : this.after,
        callingCommandId: callingCommandId.present
            ? callingCommandId.value
            : this.callingCommandId,
        callingMenuItemId: callingMenuItemId.present
            ? callingMenuItemId.value
            : this.callingMenuItemId,
        onCancelMenuId:
            onCancelMenuId.present ? onCancelMenuId.value : this.onCancelMenuId,
        customLevelCommandId: customLevelCommandId.present
            ? customLevelCommandId.value
            : this.customLevelCommandId,
        commandId: commandId ?? this.commandId,
        randomNumberBase: randomNumberBase.present
            ? randomNumberBase.value
            : this.randomNumberBase,
      );
  @override
  String toString() {
    return (StringBuffer('CallCommand(')
          ..write('id: $id, ')
          ..write('after: $after, ')
          ..write('callingCommandId: $callingCommandId, ')
          ..write('callingMenuItemId: $callingMenuItemId, ')
          ..write('onCancelMenuId: $onCancelMenuId, ')
          ..write('customLevelCommandId: $customLevelCommandId, ')
          ..write('commandId: $commandId, ')
          ..write('randomNumberBase: $randomNumberBase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      after,
      callingCommandId,
      callingMenuItemId,
      onCancelMenuId,
      customLevelCommandId,
      commandId,
      randomNumberBase);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CallCommand &&
          other.id == this.id &&
          other.after == this.after &&
          other.callingCommandId == this.callingCommandId &&
          other.callingMenuItemId == this.callingMenuItemId &&
          other.onCancelMenuId == this.onCancelMenuId &&
          other.customLevelCommandId == this.customLevelCommandId &&
          other.commandId == this.commandId &&
          other.randomNumberBase == this.randomNumberBase);
}

class CallCommandsCompanion extends UpdateCompanion<CallCommand> {
  final Value<int> id;
  final Value<int?> after;
  final Value<int?> callingCommandId;
  final Value<int?> callingMenuItemId;
  final Value<int?> onCancelMenuId;
  final Value<int?> customLevelCommandId;
  final Value<int> commandId;
  final Value<int?> randomNumberBase;
  const CallCommandsCompanion({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.callingCommandId = const Value.absent(),
    this.callingMenuItemId = const Value.absent(),
    this.onCancelMenuId = const Value.absent(),
    this.customLevelCommandId = const Value.absent(),
    this.commandId = const Value.absent(),
    this.randomNumberBase = const Value.absent(),
  });
  CallCommandsCompanion.insert({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.callingCommandId = const Value.absent(),
    this.callingMenuItemId = const Value.absent(),
    this.onCancelMenuId = const Value.absent(),
    this.customLevelCommandId = const Value.absent(),
    required int commandId,
    this.randomNumberBase = const Value.absent(),
  }) : commandId = Value(commandId);
  static Insertable<CallCommand> custom({
    Expression<int>? id,
    Expression<int>? after,
    Expression<int>? callingCommandId,
    Expression<int>? callingMenuItemId,
    Expression<int>? onCancelMenuId,
    Expression<int>? customLevelCommandId,
    Expression<int>? commandId,
    Expression<int>? randomNumberBase,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (after != null) 'after': after,
      if (callingCommandId != null) 'calling_command_id': callingCommandId,
      if (callingMenuItemId != null) 'calling_menu_item_id': callingMenuItemId,
      if (onCancelMenuId != null) 'on_cancel_menu_id': onCancelMenuId,
      if (customLevelCommandId != null)
        'custom_level_command_id': customLevelCommandId,
      if (commandId != null) 'command_id': commandId,
      if (randomNumberBase != null) 'random_number_base': randomNumberBase,
    });
  }

  CallCommandsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? after,
      Value<int?>? callingCommandId,
      Value<int?>? callingMenuItemId,
      Value<int?>? onCancelMenuId,
      Value<int?>? customLevelCommandId,
      Value<int>? commandId,
      Value<int?>? randomNumberBase}) {
    return CallCommandsCompanion(
      id: id ?? this.id,
      after: after ?? this.after,
      callingCommandId: callingCommandId ?? this.callingCommandId,
      callingMenuItemId: callingMenuItemId ?? this.callingMenuItemId,
      onCancelMenuId: onCancelMenuId ?? this.onCancelMenuId,
      customLevelCommandId: customLevelCommandId ?? this.customLevelCommandId,
      commandId: commandId ?? this.commandId,
      randomNumberBase: randomNumberBase ?? this.randomNumberBase,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (after.present) {
      map['after'] = Variable<int>(after.value);
    }
    if (callingCommandId.present) {
      map['calling_command_id'] = Variable<int>(callingCommandId.value);
    }
    if (callingMenuItemId.present) {
      map['calling_menu_item_id'] = Variable<int>(callingMenuItemId.value);
    }
    if (onCancelMenuId.present) {
      map['on_cancel_menu_id'] = Variable<int>(onCancelMenuId.value);
    }
    if (customLevelCommandId.present) {
      map['custom_level_command_id'] =
          Variable<int>(customLevelCommandId.value);
    }
    if (commandId.present) {
      map['command_id'] = Variable<int>(commandId.value);
    }
    if (randomNumberBase.present) {
      map['random_number_base'] = Variable<int>(randomNumberBase.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CallCommandsCompanion(')
          ..write('id: $id, ')
          ..write('after: $after, ')
          ..write('callingCommandId: $callingCommandId, ')
          ..write('callingMenuItemId: $callingMenuItemId, ')
          ..write('onCancelMenuId: $onCancelMenuId, ')
          ..write('customLevelCommandId: $customLevelCommandId, ')
          ..write('commandId: $commandId, ')
          ..write('randomNumberBase: $randomNumberBase')
          ..write(')'))
        .toString();
  }
}

class $PinnedCommandsTable extends PinnedCommands
    with TableInfo<$PinnedCommandsTable, PinnedCommand> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PinnedCommandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Untitled Object'));
  static const VerificationMeta _commandIdMeta =
      const VerificationMeta('commandId');
  @override
  late final GeneratedColumn<int> commandId = GeneratedColumn<int>(
      'command_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES commands (id) ON DELETE RESTRICT'));
  @override
  List<GeneratedColumn> get $columns => [id, name, commandId];
  @override
  String get aliasedName => _alias ?? 'pinned_commands';
  @override
  String get actualTableName => 'pinned_commands';
  @override
  VerificationContext validateIntegrity(Insertable<PinnedCommand> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('command_id')) {
      context.handle(_commandIdMeta,
          commandId.isAcceptableOrUnknown(data['command_id']!, _commandIdMeta));
    } else if (isInserting) {
      context.missing(_commandIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PinnedCommand map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PinnedCommand(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      commandId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}command_id'])!,
    );
  }

  @override
  $PinnedCommandsTable createAlias(String alias) {
    return $PinnedCommandsTable(attachedDatabase, alias);
  }
}

class PinnedCommand extends DataClass implements Insertable<PinnedCommand> {
  /// The primary key.
  final int id;

  /// The name of this object.
  final String name;

  /// The ID of the command to pin.
  final int commandId;
  const PinnedCommand(
      {required this.id, required this.name, required this.commandId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['command_id'] = Variable<int>(commandId);
    return map;
  }

  PinnedCommandsCompanion toCompanion(bool nullToAbsent) {
    return PinnedCommandsCompanion(
      id: Value(id),
      name: Value(name),
      commandId: Value(commandId),
    );
  }

  factory PinnedCommand.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PinnedCommand(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      commandId: serializer.fromJson<int>(json['commandId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'commandId': serializer.toJson<int>(commandId),
    };
  }

  PinnedCommand copyWith({int? id, String? name, int? commandId}) =>
      PinnedCommand(
        id: id ?? this.id,
        name: name ?? this.name,
        commandId: commandId ?? this.commandId,
      );
  @override
  String toString() {
    return (StringBuffer('PinnedCommand(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('commandId: $commandId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, commandId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PinnedCommand &&
          other.id == this.id &&
          other.name == this.name &&
          other.commandId == this.commandId);
}

class PinnedCommandsCompanion extends UpdateCompanion<PinnedCommand> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> commandId;
  const PinnedCommandsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.commandId = const Value.absent(),
  });
  PinnedCommandsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    required int commandId,
  }) : commandId = Value(commandId);
  static Insertable<PinnedCommand> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? commandId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (commandId != null) 'command_id': commandId,
    });
  }

  PinnedCommandsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? commandId}) {
    return PinnedCommandsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      commandId: commandId ?? this.commandId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (commandId.present) {
      map['command_id'] = Variable<int>(commandId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PinnedCommandsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('commandId: $commandId')
          ..write(')'))
        .toString();
  }
}

abstract class _$CrossbowBackendDatabase extends GeneratedDatabase {
  _$CrossbowBackendDatabase(QueryExecutor e) : super(e);
  late final $AssetReferencesTable assetReferences =
      $AssetReferencesTable(this);
  late final $CommandTriggerKeyboardKeysTable commandTriggerKeyboardKeys =
      $CommandTriggerKeyboardKeysTable(this);
  late final $CommandTriggersTable commandTriggers =
      $CommandTriggersTable(this);
  late final $MenusTable menus = $MenusTable(this);
  late final $MenuItemsTable menuItems = $MenuItemsTable(this);
  late final $PushMenusTable pushMenus = $PushMenusTable(this);
  late final $PopLevelsTable popLevels = $PopLevelsTable(this);
  late final $StopGamesTable stopGames = $StopGamesTable(this);
  late final $CommandsTable commands = $CommandsTable(this);
  late final $CustomLevelsTable customLevels = $CustomLevelsTable(this);
  late final $CustomLevelCommandsTable customLevelCommands =
      $CustomLevelCommandsTable(this);
  late final $CallCommandsTable callCommands = $CallCommandsTable(this);
  late final $PinnedCommandsTable pinnedCommands = $PinnedCommandsTable(this);
  late final MenusDao menusDao = MenusDao(this as CrossbowBackendDatabase);
  late final MenuItemsDao menuItemsDao =
      MenuItemsDao(this as CrossbowBackendDatabase);
  late final CommandsDao commandsDao =
      CommandsDao(this as CrossbowBackendDatabase);
  late final PushMenusDao pushMenusDao =
      PushMenusDao(this as CrossbowBackendDatabase);
  late final CallCommandsDao callCommandsDao =
      CallCommandsDao(this as CrossbowBackendDatabase);
  late final StopGamesDao stopGamesDao =
      StopGamesDao(this as CrossbowBackendDatabase);
  late final PopLevelsDao popLevelsDao =
      PopLevelsDao(this as CrossbowBackendDatabase);
  late final AssetReferencesDao assetReferencesDao =
      AssetReferencesDao(this as CrossbowBackendDatabase);
  late final CommandTriggersDao commandTriggersDao =
      CommandTriggersDao(this as CrossbowBackendDatabase);
  late final CommandTriggerKeyboardKeysDao commandTriggerKeyboardKeysDao =
      CommandTriggerKeyboardKeysDao(this as CrossbowBackendDatabase);
  late final UtilsDao utilsDao = UtilsDao(this as CrossbowBackendDatabase);
  late final PinnedCommandsDao pinnedCommandsDao =
      PinnedCommandsDao(this as CrossbowBackendDatabase);
  late final CustomLevelsDao customLevelsDao =
      CustomLevelsDao(this as CrossbowBackendDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        assetReferences,
        commandTriggerKeyboardKeys,
        commandTriggers,
        menus,
        menuItems,
        pushMenus,
        popLevels,
        stopGames,
        commands,
        customLevels,
        customLevelCommands,
        callCommands,
        pinnedCommands
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('command_trigger_keyboard_keys',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('command_triggers', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('asset_references',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('menus', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('asset_references',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('menus', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('asset_references',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('menus', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('menus',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('menu_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('asset_references',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('menu_items', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('asset_references',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('menu_items', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('menus',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('push_menus', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('push_menus',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('commands', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('asset_references',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('commands', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('pop_levels',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('commands', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('stop_games',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('commands', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('custom_levels',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('custom_level_commands', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('command_triggers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('custom_level_commands', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('commands',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('call_commands', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('menu_items',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('call_commands', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('menus',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('call_commands', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('custom_level_commands',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('call_commands', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('commands',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('call_commands', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
