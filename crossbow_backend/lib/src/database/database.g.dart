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
  static const VerificationMeta _variableNameMeta =
      const VerificationMeta('variableName');
  @override
  late final GeneratedColumn<String> variableName = GeneratedColumn<String>(
      'variable_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  static const VerificationMeta _detachedMeta =
      const VerificationMeta('detached');
  @override
  late final GeneratedColumn<bool> detached =
      GeneratedColumn<bool>('detached', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("detached" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, variableName, folderName, gain, detached, comment];
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
    if (data.containsKey('variable_name')) {
      context.handle(
          _variableNameMeta,
          variableName.isAcceptableOrUnknown(
              data['variable_name']!, _variableNameMeta));
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
    if (data.containsKey('detached')) {
      context.handle(_detachedMeta,
          detached.isAcceptableOrUnknown(data['detached']!, _detachedMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
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
      variableName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variable_name']),
      folderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}folder_name'])!,
      gain: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gain'])!,
      detached: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}detached'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
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

  /// The variable name associated with a row.
  final String? variableName;

  /// The folder that contains the asset with the given [name].
  final String folderName;

  /// The gain to play this sound at.
  final double gain;

  /// Whether or not this asset reference is detached from any other row.
  final bool detached;

  /// The comment string for this asset.
  ///
  /// Used by the `build-game` script.
  final String? comment;
  const AssetReference(
      {required this.id,
      required this.name,
      this.variableName,
      required this.folderName,
      required this.gain,
      required this.detached,
      this.comment});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || variableName != null) {
      map['variable_name'] = Variable<String>(variableName);
    }
    map['folder_name'] = Variable<String>(folderName);
    map['gain'] = Variable<double>(gain);
    map['detached'] = Variable<bool>(detached);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    return map;
  }

  AssetReferencesCompanion toCompanion(bool nullToAbsent) {
    return AssetReferencesCompanion(
      id: Value(id),
      name: Value(name),
      variableName: variableName == null && nullToAbsent
          ? const Value.absent()
          : Value(variableName),
      folderName: Value(folderName),
      gain: Value(gain),
      detached: Value(detached),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
    );
  }

  factory AssetReference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetReference(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      variableName: serializer.fromJson<String?>(json['variableName']),
      folderName: serializer.fromJson<String>(json['folderName']),
      gain: serializer.fromJson<double>(json['gain']),
      detached: serializer.fromJson<bool>(json['detached']),
      comment: serializer.fromJson<String?>(json['comment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'variableName': serializer.toJson<String?>(variableName),
      'folderName': serializer.toJson<String>(folderName),
      'gain': serializer.toJson<double>(gain),
      'detached': serializer.toJson<bool>(detached),
      'comment': serializer.toJson<String?>(comment),
    };
  }

  AssetReference copyWith(
          {int? id,
          String? name,
          Value<String?> variableName = const Value.absent(),
          String? folderName,
          double? gain,
          bool? detached,
          Value<String?> comment = const Value.absent()}) =>
      AssetReference(
        id: id ?? this.id,
        name: name ?? this.name,
        variableName:
            variableName.present ? variableName.value : this.variableName,
        folderName: folderName ?? this.folderName,
        gain: gain ?? this.gain,
        detached: detached ?? this.detached,
        comment: comment.present ? comment.value : this.comment,
      );
  @override
  String toString() {
    return (StringBuffer('AssetReference(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('variableName: $variableName, ')
          ..write('folderName: $folderName, ')
          ..write('gain: $gain, ')
          ..write('detached: $detached, ')
          ..write('comment: $comment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, variableName, folderName, gain, detached, comment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetReference &&
          other.id == this.id &&
          other.name == this.name &&
          other.variableName == this.variableName &&
          other.folderName == this.folderName &&
          other.gain == this.gain &&
          other.detached == this.detached &&
          other.comment == this.comment);
}

class AssetReferencesCompanion extends UpdateCompanion<AssetReference> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> variableName;
  final Value<String> folderName;
  final Value<double> gain;
  final Value<bool> detached;
  final Value<String?> comment;
  const AssetReferencesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.variableName = const Value.absent(),
    this.folderName = const Value.absent(),
    this.gain = const Value.absent(),
    this.detached = const Value.absent(),
    this.comment = const Value.absent(),
  });
  AssetReferencesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.variableName = const Value.absent(),
    required String folderName,
    this.gain = const Value.absent(),
    this.detached = const Value.absent(),
    this.comment = const Value.absent(),
  }) : folderName = Value(folderName);
  static Insertable<AssetReference> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? variableName,
    Expression<String>? folderName,
    Expression<double>? gain,
    Expression<bool>? detached,
    Expression<String>? comment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (variableName != null) 'variable_name': variableName,
      if (folderName != null) 'folder_name': folderName,
      if (gain != null) 'gain': gain,
      if (detached != null) 'detached': detached,
      if (comment != null) 'comment': comment,
    });
  }

  AssetReferencesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? variableName,
      Value<String>? folderName,
      Value<double>? gain,
      Value<bool>? detached,
      Value<String?>? comment}) {
    return AssetReferencesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      variableName: variableName ?? this.variableName,
      folderName: folderName ?? this.folderName,
      gain: gain ?? this.gain,
      detached: detached ?? this.detached,
      comment: comment ?? this.comment,
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
    if (variableName.present) {
      map['variable_name'] = Variable<String>(variableName.value);
    }
    if (folderName.present) {
      map['folder_name'] = Variable<String>(folderName.value);
    }
    if (gain.present) {
      map['gain'] = Variable<double>(gain.value);
    }
    if (detached.present) {
      map['detached'] = Variable<bool>(detached.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetReferencesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('variableName: $variableName, ')
          ..write('folderName: $folderName, ')
          ..write('gain: $gain, ')
          ..write('detached: $detached, ')
          ..write('comment: $comment')
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
  static const VerificationMeta _variableNameMeta =
      const VerificationMeta('variableName');
  @override
  late final GeneratedColumn<String> variableName = GeneratedColumn<String>(
      'variable_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
      [id, description, variableName, gameControllerButton, keyboardKeyId];
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
    if (data.containsKey('variable_name')) {
      context.handle(
          _variableNameMeta,
          variableName.isAcceptableOrUnknown(
              data['variable_name']!, _variableNameMeta));
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
      variableName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variable_name']),
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

  /// The description of this object.
  final String description;

  /// The variable name associated with a row.
  final String? variableName;

  /// The game controller button that will trigger this command.
  final GameControllerButton? gameControllerButton;

  /// The keyboard key to use.
  final int? keyboardKeyId;
  const CommandTrigger(
      {required this.id,
      required this.description,
      this.variableName,
      this.gameControllerButton,
      this.keyboardKeyId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || variableName != null) {
      map['variable_name'] = Variable<String>(variableName);
    }
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
      variableName: variableName == null && nullToAbsent
          ? const Value.absent()
          : Value(variableName),
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
      variableName: serializer.fromJson<String?>(json['variableName']),
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
      'variableName': serializer.toJson<String?>(variableName),
      'gameControllerButton': serializer.toJson<int?>($CommandTriggersTable
          .$convertergameControllerButtonn
          .toJson(gameControllerButton)),
      'keyboardKeyId': serializer.toJson<int?>(keyboardKeyId),
    };
  }

  CommandTrigger copyWith(
          {int? id,
          String? description,
          Value<String?> variableName = const Value.absent(),
          Value<GameControllerButton?> gameControllerButton =
              const Value.absent(),
          Value<int?> keyboardKeyId = const Value.absent()}) =>
      CommandTrigger(
        id: id ?? this.id,
        description: description ?? this.description,
        variableName:
            variableName.present ? variableName.value : this.variableName,
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
          ..write('variableName: $variableName, ')
          ..write('gameControllerButton: $gameControllerButton, ')
          ..write('keyboardKeyId: $keyboardKeyId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, description, variableName, gameControllerButton, keyboardKeyId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommandTrigger &&
          other.id == this.id &&
          other.description == this.description &&
          other.variableName == this.variableName &&
          other.gameControllerButton == this.gameControllerButton &&
          other.keyboardKeyId == this.keyboardKeyId);
}

class CommandTriggersCompanion extends UpdateCompanion<CommandTrigger> {
  final Value<int> id;
  final Value<String> description;
  final Value<String?> variableName;
  final Value<GameControllerButton?> gameControllerButton;
  final Value<int?> keyboardKeyId;
  const CommandTriggersCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.variableName = const Value.absent(),
    this.gameControllerButton = const Value.absent(),
    this.keyboardKeyId = const Value.absent(),
  });
  CommandTriggersCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    this.variableName = const Value.absent(),
    this.gameControllerButton = const Value.absent(),
    this.keyboardKeyId = const Value.absent(),
  }) : description = Value(description);
  static Insertable<CommandTrigger> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<String>? variableName,
    Expression<int>? gameControllerButton,
    Expression<int>? keyboardKeyId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (variableName != null) 'variable_name': variableName,
      if (gameControllerButton != null)
        'game_controller_button': gameControllerButton,
      if (keyboardKeyId != null) 'keyboard_key_id': keyboardKeyId,
    });
  }

  CommandTriggersCompanion copyWith(
      {Value<int>? id,
      Value<String>? description,
      Value<String?>? variableName,
      Value<GameControllerButton?>? gameControllerButton,
      Value<int?>? keyboardKeyId}) {
    return CommandTriggersCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      variableName: variableName ?? this.variableName,
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
    if (variableName.present) {
      map['variable_name'] = Variable<String>(variableName.value);
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
          ..write('variableName: $variableName, ')
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
  static const VerificationMeta _variableNameMeta =
      const VerificationMeta('variableName');
  @override
  late final GeneratedColumn<String> variableName = GeneratedColumn<String>(
      'variable_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  static const VerificationMeta _upScanCodeMeta =
      const VerificationMeta('upScanCode');
  @override
  late final GeneratedColumnWithTypeConverter<ScanCode, int> upScanCode =
      GeneratedColumn<int>('up_scan_code', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(ScanCode.up.index))
          .withConverter<ScanCode>($MenusTable.$converterupScanCode);
  static const VerificationMeta _upButtonMeta =
      const VerificationMeta('upButton');
  @override
  late final GeneratedColumnWithTypeConverter<GameControllerButton, int>
      upButton = GeneratedColumn<int>('up_button', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(GameControllerButton.dpadUp.index))
          .withConverter<GameControllerButton>($MenusTable.$converterupButton);
  static const VerificationMeta _downScanCodeMeta =
      const VerificationMeta('downScanCode');
  @override
  late final GeneratedColumnWithTypeConverter<ScanCode, int> downScanCode =
      GeneratedColumn<int>('down_scan_code', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(ScanCode.down.index))
          .withConverter<ScanCode>($MenusTable.$converterdownScanCode);
  static const VerificationMeta _downButtonMeta =
      const VerificationMeta('downButton');
  @override
  late final GeneratedColumnWithTypeConverter<GameControllerButton, int>
      downButton = GeneratedColumn<int>('down_button', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(GameControllerButton.dpadDown.index))
          .withConverter<GameControllerButton>(
              $MenusTable.$converterdownButton);
  static const VerificationMeta _activateScanCodeMeta =
      const VerificationMeta('activateScanCode');
  @override
  late final GeneratedColumnWithTypeConverter<ScanCode, int> activateScanCode =
      GeneratedColumn<int>('activate_scan_code', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(ScanCode.space.index))
          .withConverter<ScanCode>($MenusTable.$converteractivateScanCode);
  static const VerificationMeta _activateButtonMeta =
      const VerificationMeta('activateButton');
  @override
  late final GeneratedColumnWithTypeConverter<GameControllerButton, int>
      activateButton = GeneratedColumn<int>(
              'activate_button', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(GameControllerButton.dpadRight.index))
          .withConverter<GameControllerButton>(
              $MenusTable.$converteractivateButton);
  static const VerificationMeta _cancelScanCodeMeta =
      const VerificationMeta('cancelScanCode');
  @override
  late final GeneratedColumnWithTypeConverter<ScanCode, int> cancelScanCode =
      GeneratedColumn<int>('cancel_scan_code', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(ScanCode.escape.index))
          .withConverter<ScanCode>($MenusTable.$convertercancelScanCode);
  static const VerificationMeta _cancelButtonMeta =
      const VerificationMeta('cancelButton');
  @override
  late final GeneratedColumnWithTypeConverter<GameControllerButton, int>
      cancelButton = GeneratedColumn<int>('cancel_button', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(GameControllerButton.dpadLeft.index))
          .withConverter<GameControllerButton>(
              $MenusTable.$convertercancelButton);
  static const VerificationMeta _movementAxisMeta =
      const VerificationMeta('movementAxis');
  @override
  late final GeneratedColumnWithTypeConverter<GameControllerAxis, int>
      movementAxis = GeneratedColumn<int>('movement_axis', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(GameControllerAxis.lefty.index))
          .withConverter<GameControllerAxis>(
              $MenusTable.$convertermovementAxis);
  static const VerificationMeta _activateAxisMeta =
      const VerificationMeta('activateAxis');
  @override
  late final GeneratedColumnWithTypeConverter<GameControllerAxis, int>
      activateAxis = GeneratedColumn<int>('activate_axis', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(GameControllerAxis.triggerright.index))
          .withConverter<GameControllerAxis>(
              $MenusTable.$converteractivateAxis);
  static const VerificationMeta _cancelAxisMeta =
      const VerificationMeta('cancelAxis');
  @override
  late final GeneratedColumnWithTypeConverter<GameControllerAxis, int>
      cancelAxis = GeneratedColumn<int>('cancel_axis', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: Constant(GameControllerAxis.triggerleft.index))
          .withConverter<GameControllerAxis>($MenusTable.$convertercancelAxis);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        variableName,
        musicId,
        selectItemSoundId,
        activateItemSoundId,
        upScanCode,
        upButton,
        downScanCode,
        downButton,
        activateScanCode,
        activateButton,
        cancelScanCode,
        cancelButton,
        movementAxis,
        activateAxis,
        cancelAxis
      ];
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
    if (data.containsKey('variable_name')) {
      context.handle(
          _variableNameMeta,
          variableName.isAcceptableOrUnknown(
              data['variable_name']!, _variableNameMeta));
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
    context.handle(_upScanCodeMeta, const VerificationResult.success());
    context.handle(_upButtonMeta, const VerificationResult.success());
    context.handle(_downScanCodeMeta, const VerificationResult.success());
    context.handle(_downButtonMeta, const VerificationResult.success());
    context.handle(_activateScanCodeMeta, const VerificationResult.success());
    context.handle(_activateButtonMeta, const VerificationResult.success());
    context.handle(_cancelScanCodeMeta, const VerificationResult.success());
    context.handle(_cancelButtonMeta, const VerificationResult.success());
    context.handle(_movementAxisMeta, const VerificationResult.success());
    context.handle(_activateAxisMeta, const VerificationResult.success());
    context.handle(_cancelAxisMeta, const VerificationResult.success());
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
      variableName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variable_name']),
      musicId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}music_id']),
      selectItemSoundId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}select_item_sound_id']),
      activateItemSoundId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}activate_item_sound_id']),
      upScanCode: $MenusTable.$converterupScanCode.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}up_scan_code'])!),
      upButton: $MenusTable.$converterupButton.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}up_button'])!),
      downScanCode: $MenusTable.$converterdownScanCode.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}down_scan_code'])!),
      downButton: $MenusTable.$converterdownButton.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}down_button'])!),
      activateScanCode: $MenusTable.$converteractivateScanCode.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}activate_scan_code'])!),
      activateButton: $MenusTable.$converteractivateButton.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}activate_button'])!),
      cancelScanCode: $MenusTable.$convertercancelScanCode.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.int, data['${effectivePrefix}cancel_scan_code'])!),
      cancelButton: $MenusTable.$convertercancelButton.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cancel_button'])!),
      movementAxis: $MenusTable.$convertermovementAxis.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}movement_axis'])!),
      activateAxis: $MenusTable.$converteractivateAxis.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activate_axis'])!),
      cancelAxis: $MenusTable.$convertercancelAxis.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cancel_axis'])!),
    );
  }

  @override
  $MenusTable createAlias(String alias) {
    return $MenusTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ScanCode, int, int> $converterupScanCode =
      const EnumIndexConverter<ScanCode>(ScanCode.values);
  static JsonTypeConverter2<GameControllerButton, int, int> $converterupButton =
      const EnumIndexConverter<GameControllerButton>(
          GameControllerButton.values);
  static JsonTypeConverter2<ScanCode, int, int> $converterdownScanCode =
      const EnumIndexConverter<ScanCode>(ScanCode.values);
  static JsonTypeConverter2<GameControllerButton, int, int>
      $converterdownButton = const EnumIndexConverter<GameControllerButton>(
          GameControllerButton.values);
  static JsonTypeConverter2<ScanCode, int, int> $converteractivateScanCode =
      const EnumIndexConverter<ScanCode>(ScanCode.values);
  static JsonTypeConverter2<GameControllerButton, int, int>
      $converteractivateButton = const EnumIndexConverter<GameControllerButton>(
          GameControllerButton.values);
  static JsonTypeConverter2<ScanCode, int, int> $convertercancelScanCode =
      const EnumIndexConverter<ScanCode>(ScanCode.values);
  static JsonTypeConverter2<GameControllerButton, int, int>
      $convertercancelButton = const EnumIndexConverter<GameControllerButton>(
          GameControllerButton.values);
  static JsonTypeConverter2<GameControllerAxis, int, int>
      $convertermovementAxis =
      const EnumIndexConverter<GameControllerAxis>(GameControllerAxis.values);
  static JsonTypeConverter2<GameControllerAxis, int, int>
      $converteractivateAxis =
      const EnumIndexConverter<GameControllerAxis>(GameControllerAxis.values);
  static JsonTypeConverter2<GameControllerAxis, int, int> $convertercancelAxis =
      const EnumIndexConverter<GameControllerAxis>(GameControllerAxis.values);
}

class Menu extends DataClass implements Insertable<Menu> {
  /// The primary key.
  final int id;

  /// The name of this object.
  final String name;

  /// The variable name associated with a row.
  final String? variableName;

  /// The music to use for this menu.
  final int? musicId;

  /// The sound to use when selecting an item.
  final int? selectItemSoundId;

  /// The sound to use when activating an item.
  final int? activateItemSoundId;

  /// The scan code to use to move up this menu.
  final ScanCode upScanCode;

  /// The game controller button to use to move up in the menu.
  final GameControllerButton upButton;

  /// The scan code to use to move down this menu.
  final ScanCode downScanCode;

  /// The game controller button to use to move down in the menu.
  final GameControllerButton downButton;

  /// The scan code to use to activate items in this menu.
  final ScanCode activateScanCode;

  /// The game controller button to use to activate items in this menu.
  final GameControllerButton activateButton;

  /// The scan code to use to cancel this menu.
  final ScanCode cancelScanCode;

  /// The game controller button to use to cancel this menu.
  final GameControllerButton cancelButton;

  /// The game controller axis to use to move through this menu.
  final GameControllerAxis movementAxis;

  /// The game controller axis to use to activate menu items.
  final GameControllerAxis activateAxis;

  /// The game controller axis to use to cancel this menu.
  final GameControllerAxis cancelAxis;
  const Menu(
      {required this.id,
      required this.name,
      this.variableName,
      this.musicId,
      this.selectItemSoundId,
      this.activateItemSoundId,
      required this.upScanCode,
      required this.upButton,
      required this.downScanCode,
      required this.downButton,
      required this.activateScanCode,
      required this.activateButton,
      required this.cancelScanCode,
      required this.cancelButton,
      required this.movementAxis,
      required this.activateAxis,
      required this.cancelAxis});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || variableName != null) {
      map['variable_name'] = Variable<String>(variableName);
    }
    if (!nullToAbsent || musicId != null) {
      map['music_id'] = Variable<int>(musicId);
    }
    if (!nullToAbsent || selectItemSoundId != null) {
      map['select_item_sound_id'] = Variable<int>(selectItemSoundId);
    }
    if (!nullToAbsent || activateItemSoundId != null) {
      map['activate_item_sound_id'] = Variable<int>(activateItemSoundId);
    }
    {
      final converter = $MenusTable.$converterupScanCode;
      map['up_scan_code'] = Variable<int>(converter.toSql(upScanCode));
    }
    {
      final converter = $MenusTable.$converterupButton;
      map['up_button'] = Variable<int>(converter.toSql(upButton));
    }
    {
      final converter = $MenusTable.$converterdownScanCode;
      map['down_scan_code'] = Variable<int>(converter.toSql(downScanCode));
    }
    {
      final converter = $MenusTable.$converterdownButton;
      map['down_button'] = Variable<int>(converter.toSql(downButton));
    }
    {
      final converter = $MenusTable.$converteractivateScanCode;
      map['activate_scan_code'] =
          Variable<int>(converter.toSql(activateScanCode));
    }
    {
      final converter = $MenusTable.$converteractivateButton;
      map['activate_button'] = Variable<int>(converter.toSql(activateButton));
    }
    {
      final converter = $MenusTable.$convertercancelScanCode;
      map['cancel_scan_code'] = Variable<int>(converter.toSql(cancelScanCode));
    }
    {
      final converter = $MenusTable.$convertercancelButton;
      map['cancel_button'] = Variable<int>(converter.toSql(cancelButton));
    }
    {
      final converter = $MenusTable.$convertermovementAxis;
      map['movement_axis'] = Variable<int>(converter.toSql(movementAxis));
    }
    {
      final converter = $MenusTable.$converteractivateAxis;
      map['activate_axis'] = Variable<int>(converter.toSql(activateAxis));
    }
    {
      final converter = $MenusTable.$convertercancelAxis;
      map['cancel_axis'] = Variable<int>(converter.toSql(cancelAxis));
    }
    return map;
  }

  MenusCompanion toCompanion(bool nullToAbsent) {
    return MenusCompanion(
      id: Value(id),
      name: Value(name),
      variableName: variableName == null && nullToAbsent
          ? const Value.absent()
          : Value(variableName),
      musicId: musicId == null && nullToAbsent
          ? const Value.absent()
          : Value(musicId),
      selectItemSoundId: selectItemSoundId == null && nullToAbsent
          ? const Value.absent()
          : Value(selectItemSoundId),
      activateItemSoundId: activateItemSoundId == null && nullToAbsent
          ? const Value.absent()
          : Value(activateItemSoundId),
      upScanCode: Value(upScanCode),
      upButton: Value(upButton),
      downScanCode: Value(downScanCode),
      downButton: Value(downButton),
      activateScanCode: Value(activateScanCode),
      activateButton: Value(activateButton),
      cancelScanCode: Value(cancelScanCode),
      cancelButton: Value(cancelButton),
      movementAxis: Value(movementAxis),
      activateAxis: Value(activateAxis),
      cancelAxis: Value(cancelAxis),
    );
  }

  factory Menu.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Menu(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      variableName: serializer.fromJson<String?>(json['variableName']),
      musicId: serializer.fromJson<int?>(json['musicId']),
      selectItemSoundId: serializer.fromJson<int?>(json['selectItemSoundId']),
      activateItemSoundId:
          serializer.fromJson<int?>(json['activateItemSoundId']),
      upScanCode: $MenusTable.$converterupScanCode
          .fromJson(serializer.fromJson<int>(json['upScanCode'])),
      upButton: $MenusTable.$converterupButton
          .fromJson(serializer.fromJson<int>(json['upButton'])),
      downScanCode: $MenusTable.$converterdownScanCode
          .fromJson(serializer.fromJson<int>(json['downScanCode'])),
      downButton: $MenusTable.$converterdownButton
          .fromJson(serializer.fromJson<int>(json['downButton'])),
      activateScanCode: $MenusTable.$converteractivateScanCode
          .fromJson(serializer.fromJson<int>(json['activateScanCode'])),
      activateButton: $MenusTable.$converteractivateButton
          .fromJson(serializer.fromJson<int>(json['activateButton'])),
      cancelScanCode: $MenusTable.$convertercancelScanCode
          .fromJson(serializer.fromJson<int>(json['cancelScanCode'])),
      cancelButton: $MenusTable.$convertercancelButton
          .fromJson(serializer.fromJson<int>(json['cancelButton'])),
      movementAxis: $MenusTable.$convertermovementAxis
          .fromJson(serializer.fromJson<int>(json['movementAxis'])),
      activateAxis: $MenusTable.$converteractivateAxis
          .fromJson(serializer.fromJson<int>(json['activateAxis'])),
      cancelAxis: $MenusTable.$convertercancelAxis
          .fromJson(serializer.fromJson<int>(json['cancelAxis'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'variableName': serializer.toJson<String?>(variableName),
      'musicId': serializer.toJson<int?>(musicId),
      'selectItemSoundId': serializer.toJson<int?>(selectItemSoundId),
      'activateItemSoundId': serializer.toJson<int?>(activateItemSoundId),
      'upScanCode': serializer
          .toJson<int>($MenusTable.$converterupScanCode.toJson(upScanCode)),
      'upButton': serializer
          .toJson<int>($MenusTable.$converterupButton.toJson(upButton)),
      'downScanCode': serializer
          .toJson<int>($MenusTable.$converterdownScanCode.toJson(downScanCode)),
      'downButton': serializer
          .toJson<int>($MenusTable.$converterdownButton.toJson(downButton)),
      'activateScanCode': serializer.toJson<int>(
          $MenusTable.$converteractivateScanCode.toJson(activateScanCode)),
      'activateButton': serializer.toJson<int>(
          $MenusTable.$converteractivateButton.toJson(activateButton)),
      'cancelScanCode': serializer.toJson<int>(
          $MenusTable.$convertercancelScanCode.toJson(cancelScanCode)),
      'cancelButton': serializer
          .toJson<int>($MenusTable.$convertercancelButton.toJson(cancelButton)),
      'movementAxis': serializer
          .toJson<int>($MenusTable.$convertermovementAxis.toJson(movementAxis)),
      'activateAxis': serializer
          .toJson<int>($MenusTable.$converteractivateAxis.toJson(activateAxis)),
      'cancelAxis': serializer
          .toJson<int>($MenusTable.$convertercancelAxis.toJson(cancelAxis)),
    };
  }

  Menu copyWith(
          {int? id,
          String? name,
          Value<String?> variableName = const Value.absent(),
          Value<int?> musicId = const Value.absent(),
          Value<int?> selectItemSoundId = const Value.absent(),
          Value<int?> activateItemSoundId = const Value.absent(),
          ScanCode? upScanCode,
          GameControllerButton? upButton,
          ScanCode? downScanCode,
          GameControllerButton? downButton,
          ScanCode? activateScanCode,
          GameControllerButton? activateButton,
          ScanCode? cancelScanCode,
          GameControllerButton? cancelButton,
          GameControllerAxis? movementAxis,
          GameControllerAxis? activateAxis,
          GameControllerAxis? cancelAxis}) =>
      Menu(
        id: id ?? this.id,
        name: name ?? this.name,
        variableName:
            variableName.present ? variableName.value : this.variableName,
        musicId: musicId.present ? musicId.value : this.musicId,
        selectItemSoundId: selectItemSoundId.present
            ? selectItemSoundId.value
            : this.selectItemSoundId,
        activateItemSoundId: activateItemSoundId.present
            ? activateItemSoundId.value
            : this.activateItemSoundId,
        upScanCode: upScanCode ?? this.upScanCode,
        upButton: upButton ?? this.upButton,
        downScanCode: downScanCode ?? this.downScanCode,
        downButton: downButton ?? this.downButton,
        activateScanCode: activateScanCode ?? this.activateScanCode,
        activateButton: activateButton ?? this.activateButton,
        cancelScanCode: cancelScanCode ?? this.cancelScanCode,
        cancelButton: cancelButton ?? this.cancelButton,
        movementAxis: movementAxis ?? this.movementAxis,
        activateAxis: activateAxis ?? this.activateAxis,
        cancelAxis: cancelAxis ?? this.cancelAxis,
      );
  @override
  String toString() {
    return (StringBuffer('Menu(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('variableName: $variableName, ')
          ..write('musicId: $musicId, ')
          ..write('selectItemSoundId: $selectItemSoundId, ')
          ..write('activateItemSoundId: $activateItemSoundId, ')
          ..write('upScanCode: $upScanCode, ')
          ..write('upButton: $upButton, ')
          ..write('downScanCode: $downScanCode, ')
          ..write('downButton: $downButton, ')
          ..write('activateScanCode: $activateScanCode, ')
          ..write('activateButton: $activateButton, ')
          ..write('cancelScanCode: $cancelScanCode, ')
          ..write('cancelButton: $cancelButton, ')
          ..write('movementAxis: $movementAxis, ')
          ..write('activateAxis: $activateAxis, ')
          ..write('cancelAxis: $cancelAxis')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      variableName,
      musicId,
      selectItemSoundId,
      activateItemSoundId,
      upScanCode,
      upButton,
      downScanCode,
      downButton,
      activateScanCode,
      activateButton,
      cancelScanCode,
      cancelButton,
      movementAxis,
      activateAxis,
      cancelAxis);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Menu &&
          other.id == this.id &&
          other.name == this.name &&
          other.variableName == this.variableName &&
          other.musicId == this.musicId &&
          other.selectItemSoundId == this.selectItemSoundId &&
          other.activateItemSoundId == this.activateItemSoundId &&
          other.upScanCode == this.upScanCode &&
          other.upButton == this.upButton &&
          other.downScanCode == this.downScanCode &&
          other.downButton == this.downButton &&
          other.activateScanCode == this.activateScanCode &&
          other.activateButton == this.activateButton &&
          other.cancelScanCode == this.cancelScanCode &&
          other.cancelButton == this.cancelButton &&
          other.movementAxis == this.movementAxis &&
          other.activateAxis == this.activateAxis &&
          other.cancelAxis == this.cancelAxis);
}

class MenusCompanion extends UpdateCompanion<Menu> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> variableName;
  final Value<int?> musicId;
  final Value<int?> selectItemSoundId;
  final Value<int?> activateItemSoundId;
  final Value<ScanCode> upScanCode;
  final Value<GameControllerButton> upButton;
  final Value<ScanCode> downScanCode;
  final Value<GameControllerButton> downButton;
  final Value<ScanCode> activateScanCode;
  final Value<GameControllerButton> activateButton;
  final Value<ScanCode> cancelScanCode;
  final Value<GameControllerButton> cancelButton;
  final Value<GameControllerAxis> movementAxis;
  final Value<GameControllerAxis> activateAxis;
  final Value<GameControllerAxis> cancelAxis;
  const MenusCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.variableName = const Value.absent(),
    this.musicId = const Value.absent(),
    this.selectItemSoundId = const Value.absent(),
    this.activateItemSoundId = const Value.absent(),
    this.upScanCode = const Value.absent(),
    this.upButton = const Value.absent(),
    this.downScanCode = const Value.absent(),
    this.downButton = const Value.absent(),
    this.activateScanCode = const Value.absent(),
    this.activateButton = const Value.absent(),
    this.cancelScanCode = const Value.absent(),
    this.cancelButton = const Value.absent(),
    this.movementAxis = const Value.absent(),
    this.activateAxis = const Value.absent(),
    this.cancelAxis = const Value.absent(),
  });
  MenusCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.variableName = const Value.absent(),
    this.musicId = const Value.absent(),
    this.selectItemSoundId = const Value.absent(),
    this.activateItemSoundId = const Value.absent(),
    this.upScanCode = const Value.absent(),
    this.upButton = const Value.absent(),
    this.downScanCode = const Value.absent(),
    this.downButton = const Value.absent(),
    this.activateScanCode = const Value.absent(),
    this.activateButton = const Value.absent(),
    this.cancelScanCode = const Value.absent(),
    this.cancelButton = const Value.absent(),
    this.movementAxis = const Value.absent(),
    this.activateAxis = const Value.absent(),
    this.cancelAxis = const Value.absent(),
  });
  static Insertable<Menu> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? variableName,
    Expression<int>? musicId,
    Expression<int>? selectItemSoundId,
    Expression<int>? activateItemSoundId,
    Expression<int>? upScanCode,
    Expression<int>? upButton,
    Expression<int>? downScanCode,
    Expression<int>? downButton,
    Expression<int>? activateScanCode,
    Expression<int>? activateButton,
    Expression<int>? cancelScanCode,
    Expression<int>? cancelButton,
    Expression<int>? movementAxis,
    Expression<int>? activateAxis,
    Expression<int>? cancelAxis,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (variableName != null) 'variable_name': variableName,
      if (musicId != null) 'music_id': musicId,
      if (selectItemSoundId != null) 'select_item_sound_id': selectItemSoundId,
      if (activateItemSoundId != null)
        'activate_item_sound_id': activateItemSoundId,
      if (upScanCode != null) 'up_scan_code': upScanCode,
      if (upButton != null) 'up_button': upButton,
      if (downScanCode != null) 'down_scan_code': downScanCode,
      if (downButton != null) 'down_button': downButton,
      if (activateScanCode != null) 'activate_scan_code': activateScanCode,
      if (activateButton != null) 'activate_button': activateButton,
      if (cancelScanCode != null) 'cancel_scan_code': cancelScanCode,
      if (cancelButton != null) 'cancel_button': cancelButton,
      if (movementAxis != null) 'movement_axis': movementAxis,
      if (activateAxis != null) 'activate_axis': activateAxis,
      if (cancelAxis != null) 'cancel_axis': cancelAxis,
    });
  }

  MenusCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? variableName,
      Value<int?>? musicId,
      Value<int?>? selectItemSoundId,
      Value<int?>? activateItemSoundId,
      Value<ScanCode>? upScanCode,
      Value<GameControllerButton>? upButton,
      Value<ScanCode>? downScanCode,
      Value<GameControllerButton>? downButton,
      Value<ScanCode>? activateScanCode,
      Value<GameControllerButton>? activateButton,
      Value<ScanCode>? cancelScanCode,
      Value<GameControllerButton>? cancelButton,
      Value<GameControllerAxis>? movementAxis,
      Value<GameControllerAxis>? activateAxis,
      Value<GameControllerAxis>? cancelAxis}) {
    return MenusCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      variableName: variableName ?? this.variableName,
      musicId: musicId ?? this.musicId,
      selectItemSoundId: selectItemSoundId ?? this.selectItemSoundId,
      activateItemSoundId: activateItemSoundId ?? this.activateItemSoundId,
      upScanCode: upScanCode ?? this.upScanCode,
      upButton: upButton ?? this.upButton,
      downScanCode: downScanCode ?? this.downScanCode,
      downButton: downButton ?? this.downButton,
      activateScanCode: activateScanCode ?? this.activateScanCode,
      activateButton: activateButton ?? this.activateButton,
      cancelScanCode: cancelScanCode ?? this.cancelScanCode,
      cancelButton: cancelButton ?? this.cancelButton,
      movementAxis: movementAxis ?? this.movementAxis,
      activateAxis: activateAxis ?? this.activateAxis,
      cancelAxis: cancelAxis ?? this.cancelAxis,
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
    if (variableName.present) {
      map['variable_name'] = Variable<String>(variableName.value);
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
    if (upScanCode.present) {
      final converter = $MenusTable.$converterupScanCode;
      map['up_scan_code'] = Variable<int>(converter.toSql(upScanCode.value));
    }
    if (upButton.present) {
      final converter = $MenusTable.$converterupButton;
      map['up_button'] = Variable<int>(converter.toSql(upButton.value));
    }
    if (downScanCode.present) {
      final converter = $MenusTable.$converterdownScanCode;
      map['down_scan_code'] =
          Variable<int>(converter.toSql(downScanCode.value));
    }
    if (downButton.present) {
      final converter = $MenusTable.$converterdownButton;
      map['down_button'] = Variable<int>(converter.toSql(downButton.value));
    }
    if (activateScanCode.present) {
      final converter = $MenusTable.$converteractivateScanCode;
      map['activate_scan_code'] =
          Variable<int>(converter.toSql(activateScanCode.value));
    }
    if (activateButton.present) {
      final converter = $MenusTable.$converteractivateButton;
      map['activate_button'] =
          Variable<int>(converter.toSql(activateButton.value));
    }
    if (cancelScanCode.present) {
      final converter = $MenusTable.$convertercancelScanCode;
      map['cancel_scan_code'] =
          Variable<int>(converter.toSql(cancelScanCode.value));
    }
    if (cancelButton.present) {
      final converter = $MenusTable.$convertercancelButton;
      map['cancel_button'] = Variable<int>(converter.toSql(cancelButton.value));
    }
    if (movementAxis.present) {
      final converter = $MenusTable.$convertermovementAxis;
      map['movement_axis'] = Variable<int>(converter.toSql(movementAxis.value));
    }
    if (activateAxis.present) {
      final converter = $MenusTable.$converteractivateAxis;
      map['activate_axis'] = Variable<int>(converter.toSql(activateAxis.value));
    }
    if (cancelAxis.present) {
      final converter = $MenusTable.$convertercancelAxis;
      map['cancel_axis'] = Variable<int>(converter.toSql(cancelAxis.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenusCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('variableName: $variableName, ')
          ..write('musicId: $musicId, ')
          ..write('selectItemSoundId: $selectItemSoundId, ')
          ..write('activateItemSoundId: $activateItemSoundId, ')
          ..write('upScanCode: $upScanCode, ')
          ..write('upButton: $upButton, ')
          ..write('downScanCode: $downScanCode, ')
          ..write('downButton: $downButton, ')
          ..write('activateScanCode: $activateScanCode, ')
          ..write('activateButton: $activateButton, ')
          ..write('cancelScanCode: $cancelScanCode, ')
          ..write('cancelButton: $cancelButton, ')
          ..write('movementAxis: $movementAxis, ')
          ..write('activateAxis: $activateAxis, ')
          ..write('cancelAxis: $cancelAxis')
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
  static const VerificationMeta _variableNameMeta =
      const VerificationMeta('variableName');
  @override
  late final GeneratedColumn<String> variableName = GeneratedColumn<String>(
      'variable_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  List<GeneratedColumn> get $columns => [
        id,
        name,
        variableName,
        menuId,
        selectSoundId,
        activateSoundId,
        position
      ];
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
    if (data.containsKey('variable_name')) {
      context.handle(
          _variableNameMeta,
          variableName.isAcceptableOrUnknown(
              data['variable_name']!, _variableNameMeta));
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
      variableName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variable_name']),
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

  /// The variable name associated with a row.
  final String? variableName;

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
      this.variableName,
      required this.menuId,
      this.selectSoundId,
      this.activateSoundId,
      required this.position});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || variableName != null) {
      map['variable_name'] = Variable<String>(variableName);
    }
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
      variableName: variableName == null && nullToAbsent
          ? const Value.absent()
          : Value(variableName),
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
      variableName: serializer.fromJson<String?>(json['variableName']),
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
      'variableName': serializer.toJson<String?>(variableName),
      'menuId': serializer.toJson<int>(menuId),
      'selectSoundId': serializer.toJson<int?>(selectSoundId),
      'activateSoundId': serializer.toJson<int?>(activateSoundId),
      'position': serializer.toJson<int>(position),
    };
  }

  MenuItem copyWith(
          {int? id,
          String? name,
          Value<String?> variableName = const Value.absent(),
          int? menuId,
          Value<int?> selectSoundId = const Value.absent(),
          Value<int?> activateSoundId = const Value.absent(),
          int? position}) =>
      MenuItem(
        id: id ?? this.id,
        name: name ?? this.name,
        variableName:
            variableName.present ? variableName.value : this.variableName,
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
          ..write('variableName: $variableName, ')
          ..write('menuId: $menuId, ')
          ..write('selectSoundId: $selectSoundId, ')
          ..write('activateSoundId: $activateSoundId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, variableName, menuId, selectSoundId, activateSoundId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.variableName == this.variableName &&
          other.menuId == this.menuId &&
          other.selectSoundId == this.selectSoundId &&
          other.activateSoundId == this.activateSoundId &&
          other.position == this.position);
}

class MenuItemsCompanion extends UpdateCompanion<MenuItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> variableName;
  final Value<int> menuId;
  final Value<int?> selectSoundId;
  final Value<int?> activateSoundId;
  final Value<int> position;
  const MenuItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.variableName = const Value.absent(),
    this.menuId = const Value.absent(),
    this.selectSoundId = const Value.absent(),
    this.activateSoundId = const Value.absent(),
    this.position = const Value.absent(),
  });
  MenuItemsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.variableName = const Value.absent(),
    required int menuId,
    this.selectSoundId = const Value.absent(),
    this.activateSoundId = const Value.absent(),
    this.position = const Value.absent(),
  }) : menuId = Value(menuId);
  static Insertable<MenuItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? variableName,
    Expression<int>? menuId,
    Expression<int>? selectSoundId,
    Expression<int>? activateSoundId,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (variableName != null) 'variable_name': variableName,
      if (menuId != null) 'menu_id': menuId,
      if (selectSoundId != null) 'select_sound_id': selectSoundId,
      if (activateSoundId != null) 'activate_sound_id': activateSoundId,
      if (position != null) 'position': position,
    });
  }

  MenuItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? variableName,
      Value<int>? menuId,
      Value<int?>? selectSoundId,
      Value<int?>? activateSoundId,
      Value<int>? position}) {
    return MenuItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      variableName: variableName ?? this.variableName,
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
    if (variableName.present) {
      map['variable_name'] = Variable<String>(variableName.value);
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
          ..write('variableName: $variableName, ')
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
  static const VerificationMeta _variableNameMeta =
      const VerificationMeta('variableName');
  @override
  late final GeneratedColumn<String> variableName = GeneratedColumn<String>(
      'variable_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _menuIdMeta = const VerificationMeta('menuId');
  @override
  late final GeneratedColumn<int> menuId = GeneratedColumn<int>(
      'menu_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES menus (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, after, fadeLength, variableName, menuId];
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
    if (data.containsKey('variable_name')) {
      context.handle(
          _variableNameMeta,
          variableName.isAcceptableOrUnknown(
              data['variable_name']!, _variableNameMeta));
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
      variableName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variable_name']),
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

  /// The variable name associated with a row.
  final String? variableName;

  /// The ID of the menu to push.
  final int menuId;
  const PushMenu(
      {required this.id,
      this.after,
      this.fadeLength,
      this.variableName,
      required this.menuId});
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
    if (!nullToAbsent || variableName != null) {
      map['variable_name'] = Variable<String>(variableName);
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
      variableName: variableName == null && nullToAbsent
          ? const Value.absent()
          : Value(variableName),
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
      variableName: serializer.fromJson<String?>(json['variableName']),
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
      'variableName': serializer.toJson<String?>(variableName),
      'menuId': serializer.toJson<int>(menuId),
    };
  }

  PushMenu copyWith(
          {int? id,
          Value<int?> after = const Value.absent(),
          Value<double?> fadeLength = const Value.absent(),
          Value<String?> variableName = const Value.absent(),
          int? menuId}) =>
      PushMenu(
        id: id ?? this.id,
        after: after.present ? after.value : this.after,
        fadeLength: fadeLength.present ? fadeLength.value : this.fadeLength,
        variableName:
            variableName.present ? variableName.value : this.variableName,
        menuId: menuId ?? this.menuId,
      );
  @override
  String toString() {
    return (StringBuffer('PushMenu(')
          ..write('id: $id, ')
          ..write('after: $after, ')
          ..write('fadeLength: $fadeLength, ')
          ..write('variableName: $variableName, ')
          ..write('menuId: $menuId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, after, fadeLength, variableName, menuId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PushMenu &&
          other.id == this.id &&
          other.after == this.after &&
          other.fadeLength == this.fadeLength &&
          other.variableName == this.variableName &&
          other.menuId == this.menuId);
}

class PushMenusCompanion extends UpdateCompanion<PushMenu> {
  final Value<int> id;
  final Value<int?> after;
  final Value<double?> fadeLength;
  final Value<String?> variableName;
  final Value<int> menuId;
  const PushMenusCompanion({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.fadeLength = const Value.absent(),
    this.variableName = const Value.absent(),
    this.menuId = const Value.absent(),
  });
  PushMenusCompanion.insert({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.fadeLength = const Value.absent(),
    this.variableName = const Value.absent(),
    required int menuId,
  }) : menuId = Value(menuId);
  static Insertable<PushMenu> custom({
    Expression<int>? id,
    Expression<int>? after,
    Expression<double>? fadeLength,
    Expression<String>? variableName,
    Expression<int>? menuId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (after != null) 'after': after,
      if (fadeLength != null) 'fade_length': fadeLength,
      if (variableName != null) 'variable_name': variableName,
      if (menuId != null) 'menu_id': menuId,
    });
  }

  PushMenusCompanion copyWith(
      {Value<int>? id,
      Value<int?>? after,
      Value<double?>? fadeLength,
      Value<String?>? variableName,
      Value<int>? menuId}) {
    return PushMenusCompanion(
      id: id ?? this.id,
      after: after ?? this.after,
      fadeLength: fadeLength ?? this.fadeLength,
      variableName: variableName ?? this.variableName,
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
    if (variableName.present) {
      map['variable_name'] = Variable<String>(variableName.value);
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
          ..write('variableName: $variableName, ')
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
  static const VerificationMeta _variableNameMeta =
      const VerificationMeta('variableName');
  @override
  late final GeneratedColumn<String> variableName = GeneratedColumn<String>(
      'variable_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, fadeLength, variableName];
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
    if (data.containsKey('variable_name')) {
      context.handle(
          _variableNameMeta,
          variableName.isAcceptableOrUnknown(
              data['variable_name']!, _variableNameMeta));
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
      variableName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variable_name']),
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

  /// The variable name associated with a row.
  final String? variableName;
  const PopLevel({required this.id, this.fadeLength, this.variableName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || fadeLength != null) {
      map['fade_length'] = Variable<double>(fadeLength);
    }
    if (!nullToAbsent || variableName != null) {
      map['variable_name'] = Variable<String>(variableName);
    }
    return map;
  }

  PopLevelsCompanion toCompanion(bool nullToAbsent) {
    return PopLevelsCompanion(
      id: Value(id),
      fadeLength: fadeLength == null && nullToAbsent
          ? const Value.absent()
          : Value(fadeLength),
      variableName: variableName == null && nullToAbsent
          ? const Value.absent()
          : Value(variableName),
    );
  }

  factory PopLevel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PopLevel(
      id: serializer.fromJson<int>(json['id']),
      fadeLength: serializer.fromJson<double?>(json['fadeLength']),
      variableName: serializer.fromJson<String?>(json['variableName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fadeLength': serializer.toJson<double?>(fadeLength),
      'variableName': serializer.toJson<String?>(variableName),
    };
  }

  PopLevel copyWith(
          {int? id,
          Value<double?> fadeLength = const Value.absent(),
          Value<String?> variableName = const Value.absent()}) =>
      PopLevel(
        id: id ?? this.id,
        fadeLength: fadeLength.present ? fadeLength.value : this.fadeLength,
        variableName:
            variableName.present ? variableName.value : this.variableName,
      );
  @override
  String toString() {
    return (StringBuffer('PopLevel(')
          ..write('id: $id, ')
          ..write('fadeLength: $fadeLength, ')
          ..write('variableName: $variableName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fadeLength, variableName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PopLevel &&
          other.id == this.id &&
          other.fadeLength == this.fadeLength &&
          other.variableName == this.variableName);
}

class PopLevelsCompanion extends UpdateCompanion<PopLevel> {
  final Value<int> id;
  final Value<double?> fadeLength;
  final Value<String?> variableName;
  const PopLevelsCompanion({
    this.id = const Value.absent(),
    this.fadeLength = const Value.absent(),
    this.variableName = const Value.absent(),
  });
  PopLevelsCompanion.insert({
    this.id = const Value.absent(),
    this.fadeLength = const Value.absent(),
    this.variableName = const Value.absent(),
  });
  static Insertable<PopLevel> custom({
    Expression<int>? id,
    Expression<double>? fadeLength,
    Expression<String>? variableName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fadeLength != null) 'fade_length': fadeLength,
      if (variableName != null) 'variable_name': variableName,
    });
  }

  PopLevelsCompanion copyWith(
      {Value<int>? id,
      Value<double?>? fadeLength,
      Value<String?>? variableName}) {
    return PopLevelsCompanion(
      id: id ?? this.id,
      fadeLength: fadeLength ?? this.fadeLength,
      variableName: variableName ?? this.variableName,
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
    if (variableName.present) {
      map['variable_name'] = Variable<String>(variableName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PopLevelsCompanion(')
          ..write('id: $id, ')
          ..write('fadeLength: $fadeLength, ')
          ..write('variableName: $variableName')
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
  static const VerificationMeta _variableNameMeta =
      const VerificationMeta('variableName');
  @override
  late final GeneratedColumn<String> variableName = GeneratedColumn<String>(
      'variable_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, after, variableName];
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
    if (data.containsKey('variable_name')) {
      context.handle(
          _variableNameMeta,
          variableName.isAcceptableOrUnknown(
              data['variable_name']!, _variableNameMeta));
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
      variableName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variable_name']),
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

  /// The variable name associated with a row.
  final String? variableName;
  const StopGame({required this.id, this.after, this.variableName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || after != null) {
      map['after'] = Variable<int>(after);
    }
    if (!nullToAbsent || variableName != null) {
      map['variable_name'] = Variable<String>(variableName);
    }
    return map;
  }

  StopGamesCompanion toCompanion(bool nullToAbsent) {
    return StopGamesCompanion(
      id: Value(id),
      after:
          after == null && nullToAbsent ? const Value.absent() : Value(after),
      variableName: variableName == null && nullToAbsent
          ? const Value.absent()
          : Value(variableName),
    );
  }

  factory StopGame.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StopGame(
      id: serializer.fromJson<int>(json['id']),
      after: serializer.fromJson<int?>(json['after']),
      variableName: serializer.fromJson<String?>(json['variableName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'after': serializer.toJson<int?>(after),
      'variableName': serializer.toJson<String?>(variableName),
    };
  }

  StopGame copyWith(
          {int? id,
          Value<int?> after = const Value.absent(),
          Value<String?> variableName = const Value.absent()}) =>
      StopGame(
        id: id ?? this.id,
        after: after.present ? after.value : this.after,
        variableName:
            variableName.present ? variableName.value : this.variableName,
      );
  @override
  String toString() {
    return (StringBuffer('StopGame(')
          ..write('id: $id, ')
          ..write('after: $after, ')
          ..write('variableName: $variableName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, after, variableName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StopGame &&
          other.id == this.id &&
          other.after == this.after &&
          other.variableName == this.variableName);
}

class StopGamesCompanion extends UpdateCompanion<StopGame> {
  final Value<int> id;
  final Value<int?> after;
  final Value<String?> variableName;
  const StopGamesCompanion({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.variableName = const Value.absent(),
  });
  StopGamesCompanion.insert({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.variableName = const Value.absent(),
  });
  static Insertable<StopGame> custom({
    Expression<int>? id,
    Expression<int>? after,
    Expression<String>? variableName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (after != null) 'after': after,
      if (variableName != null) 'variable_name': variableName,
    });
  }

  StopGamesCompanion copyWith(
      {Value<int>? id, Value<int?>? after, Value<String?>? variableName}) {
    return StopGamesCompanion(
      id: id ?? this.id,
      after: after ?? this.after,
      variableName: variableName ?? this.variableName,
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
    if (variableName.present) {
      map['variable_name'] = Variable<String>(variableName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StopGamesCompanion(')
          ..write('id: $id, ')
          ..write('after: $after, ')
          ..write('variableName: $variableName')
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
  static const VerificationMeta _variableNameMeta =
      const VerificationMeta('variableName');
  @override
  late final GeneratedColumn<String> variableName = GeneratedColumn<String>(
      'variable_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _musicIdMeta =
      const VerificationMeta('musicId');
  @override
  late final GeneratedColumn<int> musicId = GeneratedColumn<int>(
      'music_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES asset_references (id) ON DELETE SET NULL'));
  @override
  List<GeneratedColumn> get $columns => [id, name, variableName, musicId];
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
    if (data.containsKey('variable_name')) {
      context.handle(
          _variableNameMeta,
          variableName.isAcceptableOrUnknown(
              data['variable_name']!, _variableNameMeta));
    }
    if (data.containsKey('music_id')) {
      context.handle(_musicIdMeta,
          musicId.isAcceptableOrUnknown(data['music_id']!, _musicIdMeta));
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
      variableName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variable_name']),
      musicId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}music_id']),
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

  /// The variable name associated with a row.
  final String? variableName;

  /// The ID of the music to play.
  final int? musicId;
  const CustomLevel(
      {required this.id, required this.name, this.variableName, this.musicId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || variableName != null) {
      map['variable_name'] = Variable<String>(variableName);
    }
    if (!nullToAbsent || musicId != null) {
      map['music_id'] = Variable<int>(musicId);
    }
    return map;
  }

  CustomLevelsCompanion toCompanion(bool nullToAbsent) {
    return CustomLevelsCompanion(
      id: Value(id),
      name: Value(name),
      variableName: variableName == null && nullToAbsent
          ? const Value.absent()
          : Value(variableName),
      musicId: musicId == null && nullToAbsent
          ? const Value.absent()
          : Value(musicId),
    );
  }

  factory CustomLevel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomLevel(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      variableName: serializer.fromJson<String?>(json['variableName']),
      musicId: serializer.fromJson<int?>(json['musicId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'variableName': serializer.toJson<String?>(variableName),
      'musicId': serializer.toJson<int?>(musicId),
    };
  }

  CustomLevel copyWith(
          {int? id,
          String? name,
          Value<String?> variableName = const Value.absent(),
          Value<int?> musicId = const Value.absent()}) =>
      CustomLevel(
        id: id ?? this.id,
        name: name ?? this.name,
        variableName:
            variableName.present ? variableName.value : this.variableName,
        musicId: musicId.present ? musicId.value : this.musicId,
      );
  @override
  String toString() {
    return (StringBuffer('CustomLevel(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('variableName: $variableName, ')
          ..write('musicId: $musicId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, variableName, musicId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomLevel &&
          other.id == this.id &&
          other.name == this.name &&
          other.variableName == this.variableName &&
          other.musicId == this.musicId);
}

class CustomLevelsCompanion extends UpdateCompanion<CustomLevel> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> variableName;
  final Value<int?> musicId;
  const CustomLevelsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.variableName = const Value.absent(),
    this.musicId = const Value.absent(),
  });
  CustomLevelsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.variableName = const Value.absent(),
    this.musicId = const Value.absent(),
  });
  static Insertable<CustomLevel> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? variableName,
    Expression<int>? musicId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (variableName != null) 'variable_name': variableName,
      if (musicId != null) 'music_id': musicId,
    });
  }

  CustomLevelsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? variableName,
      Value<int?>? musicId}) {
    return CustomLevelsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      variableName: variableName ?? this.variableName,
      musicId: musicId ?? this.musicId,
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
    if (variableName.present) {
      map['variable_name'] = Variable<String>(variableName.value);
    }
    if (musicId.present) {
      map['music_id'] = Variable<int>(musicId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomLevelsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('variableName: $variableName, ')
          ..write('musicId: $musicId')
          ..write(')'))
        .toString();
  }
}

class $PushCustomLevelsTable extends PushCustomLevels
    with TableInfo<$PushCustomLevelsTable, PushCustomLevel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PushCustomLevelsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _variableNameMeta =
      const VerificationMeta('variableName');
  @override
  late final GeneratedColumn<String> variableName = GeneratedColumn<String>(
      'variable_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customLevelIdMeta =
      const VerificationMeta('customLevelId');
  @override
  late final GeneratedColumn<int> customLevelId = GeneratedColumn<int>(
      'custom_level_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES custom_levels (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, after, fadeLength, variableName, customLevelId];
  @override
  String get aliasedName => _alias ?? 'push_custom_levels';
  @override
  String get actualTableName => 'push_custom_levels';
  @override
  VerificationContext validateIntegrity(Insertable<PushCustomLevel> instance,
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
    if (data.containsKey('variable_name')) {
      context.handle(
          _variableNameMeta,
          variableName.isAcceptableOrUnknown(
              data['variable_name']!, _variableNameMeta));
    }
    if (data.containsKey('custom_level_id')) {
      context.handle(
          _customLevelIdMeta,
          customLevelId.isAcceptableOrUnknown(
              data['custom_level_id']!, _customLevelIdMeta));
    } else if (isInserting) {
      context.missing(_customLevelIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PushCustomLevel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PushCustomLevel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      after: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}after']),
      fadeLength: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fade_length']),
      variableName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variable_name']),
      customLevelId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}custom_level_id'])!,
    );
  }

  @override
  $PushCustomLevelsTable createAlias(String alias) {
    return $PushCustomLevelsTable(attachedDatabase, alias);
  }
}

class PushCustomLevel extends DataClass implements Insertable<PushCustomLevel> {
  /// The primary key.
  final int id;

  /// How many milliseconds to wait before doing something.
  final int? after;

  /// The fade length to use when pushing a level.
  final double? fadeLength;

  /// The variable name associated with a row.
  final String? variableName;

  /// The ID of the custom level to push.
  final int customLevelId;
  const PushCustomLevel(
      {required this.id,
      this.after,
      this.fadeLength,
      this.variableName,
      required this.customLevelId});
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
    if (!nullToAbsent || variableName != null) {
      map['variable_name'] = Variable<String>(variableName);
    }
    map['custom_level_id'] = Variable<int>(customLevelId);
    return map;
  }

  PushCustomLevelsCompanion toCompanion(bool nullToAbsent) {
    return PushCustomLevelsCompanion(
      id: Value(id),
      after:
          after == null && nullToAbsent ? const Value.absent() : Value(after),
      fadeLength: fadeLength == null && nullToAbsent
          ? const Value.absent()
          : Value(fadeLength),
      variableName: variableName == null && nullToAbsent
          ? const Value.absent()
          : Value(variableName),
      customLevelId: Value(customLevelId),
    );
  }

  factory PushCustomLevel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PushCustomLevel(
      id: serializer.fromJson<int>(json['id']),
      after: serializer.fromJson<int?>(json['after']),
      fadeLength: serializer.fromJson<double?>(json['fadeLength']),
      variableName: serializer.fromJson<String?>(json['variableName']),
      customLevelId: serializer.fromJson<int>(json['customLevelId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'after': serializer.toJson<int?>(after),
      'fadeLength': serializer.toJson<double?>(fadeLength),
      'variableName': serializer.toJson<String?>(variableName),
      'customLevelId': serializer.toJson<int>(customLevelId),
    };
  }

  PushCustomLevel copyWith(
          {int? id,
          Value<int?> after = const Value.absent(),
          Value<double?> fadeLength = const Value.absent(),
          Value<String?> variableName = const Value.absent(),
          int? customLevelId}) =>
      PushCustomLevel(
        id: id ?? this.id,
        after: after.present ? after.value : this.after,
        fadeLength: fadeLength.present ? fadeLength.value : this.fadeLength,
        variableName:
            variableName.present ? variableName.value : this.variableName,
        customLevelId: customLevelId ?? this.customLevelId,
      );
  @override
  String toString() {
    return (StringBuffer('PushCustomLevel(')
          ..write('id: $id, ')
          ..write('after: $after, ')
          ..write('fadeLength: $fadeLength, ')
          ..write('variableName: $variableName, ')
          ..write('customLevelId: $customLevelId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, after, fadeLength, variableName, customLevelId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PushCustomLevel &&
          other.id == this.id &&
          other.after == this.after &&
          other.fadeLength == this.fadeLength &&
          other.variableName == this.variableName &&
          other.customLevelId == this.customLevelId);
}

class PushCustomLevelsCompanion extends UpdateCompanion<PushCustomLevel> {
  final Value<int> id;
  final Value<int?> after;
  final Value<double?> fadeLength;
  final Value<String?> variableName;
  final Value<int> customLevelId;
  const PushCustomLevelsCompanion({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.fadeLength = const Value.absent(),
    this.variableName = const Value.absent(),
    this.customLevelId = const Value.absent(),
  });
  PushCustomLevelsCompanion.insert({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.fadeLength = const Value.absent(),
    this.variableName = const Value.absent(),
    required int customLevelId,
  }) : customLevelId = Value(customLevelId);
  static Insertable<PushCustomLevel> custom({
    Expression<int>? id,
    Expression<int>? after,
    Expression<double>? fadeLength,
    Expression<String>? variableName,
    Expression<int>? customLevelId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (after != null) 'after': after,
      if (fadeLength != null) 'fade_length': fadeLength,
      if (variableName != null) 'variable_name': variableName,
      if (customLevelId != null) 'custom_level_id': customLevelId,
    });
  }

  PushCustomLevelsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? after,
      Value<double?>? fadeLength,
      Value<String?>? variableName,
      Value<int>? customLevelId}) {
    return PushCustomLevelsCompanion(
      id: id ?? this.id,
      after: after ?? this.after,
      fadeLength: fadeLength ?? this.fadeLength,
      variableName: variableName ?? this.variableName,
      customLevelId: customLevelId ?? this.customLevelId,
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
    if (variableName.present) {
      map['variable_name'] = Variable<String>(variableName.value);
    }
    if (customLevelId.present) {
      map['custom_level_id'] = Variable<int>(customLevelId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PushCustomLevelsCompanion(')
          ..write('id: $id, ')
          ..write('after: $after, ')
          ..write('fadeLength: $fadeLength, ')
          ..write('variableName: $variableName, ')
          ..write('customLevelId: $customLevelId')
          ..write(')'))
        .toString();
  }
}

class $DartFunctionsTable extends DartFunctions
    with TableInfo<$DartFunctionsTable, DartFunction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DartFunctionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _functionNameMeta =
      const VerificationMeta('functionName');
  @override
  late final GeneratedColumn<String> functionName = GeneratedColumn<String>(
      'function_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, description, functionName];
  @override
  String get aliasedName => _alias ?? 'dart_functions';
  @override
  String get actualTableName => 'dart_functions';
  @override
  VerificationContext validateIntegrity(Insertable<DartFunction> instance,
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
    if (data.containsKey('function_name')) {
      context.handle(
          _functionNameMeta,
          functionName.isAcceptableOrUnknown(
              data['function_name']!, _functionNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DartFunction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DartFunction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      functionName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}function_name']),
    );
  }

  @override
  $DartFunctionsTable createAlias(String alias) {
    return $DartFunctionsTable(attachedDatabase, alias);
  }
}

class DartFunction extends DataClass implements Insertable<DartFunction> {
  /// The primary key.
  final int id;

  /// The description of this object.
  final String description;

  /// The name of this function.
  final String? functionName;
  const DartFunction(
      {required this.id, required this.description, this.functionName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || functionName != null) {
      map['function_name'] = Variable<String>(functionName);
    }
    return map;
  }

  DartFunctionsCompanion toCompanion(bool nullToAbsent) {
    return DartFunctionsCompanion(
      id: Value(id),
      description: Value(description),
      functionName: functionName == null && nullToAbsent
          ? const Value.absent()
          : Value(functionName),
    );
  }

  factory DartFunction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DartFunction(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      functionName: serializer.fromJson<String?>(json['functionName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'functionName': serializer.toJson<String?>(functionName),
    };
  }

  DartFunction copyWith(
          {int? id,
          String? description,
          Value<String?> functionName = const Value.absent()}) =>
      DartFunction(
        id: id ?? this.id,
        description: description ?? this.description,
        functionName:
            functionName.present ? functionName.value : this.functionName,
      );
  @override
  String toString() {
    return (StringBuffer('DartFunction(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('functionName: $functionName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, description, functionName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DartFunction &&
          other.id == this.id &&
          other.description == this.description &&
          other.functionName == this.functionName);
}

class DartFunctionsCompanion extends UpdateCompanion<DartFunction> {
  final Value<int> id;
  final Value<String> description;
  final Value<String?> functionName;
  const DartFunctionsCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.functionName = const Value.absent(),
  });
  DartFunctionsCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    this.functionName = const Value.absent(),
  }) : description = Value(description);
  static Insertable<DartFunction> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<String>? functionName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (functionName != null) 'function_name': functionName,
    });
  }

  DartFunctionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? description,
      Value<String?>? functionName}) {
    return DartFunctionsCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      functionName: functionName ?? this.functionName,
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
    if (functionName.present) {
      map['function_name'] = Variable<String>(functionName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DartFunctionsCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('functionName: $functionName')
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
  static const VerificationMeta _variableNameMeta =
      const VerificationMeta('variableName');
  @override
  late final GeneratedColumn<String> variableName = GeneratedColumn<String>(
      'variable_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  static const VerificationMeta _pushCustomLevelIdMeta =
      const VerificationMeta('pushCustomLevelId');
  @override
  late final GeneratedColumn<int> pushCustomLevelId = GeneratedColumn<int>(
      'push_custom_level_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES push_custom_levels (id) ON DELETE SET NULL'));
  static const VerificationMeta _dartFunctionIdMeta =
      const VerificationMeta('dartFunctionId');
  @override
  late final GeneratedColumn<int> dartFunctionId = GeneratedColumn<int>(
      'dart_function_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES dart_functions (id) ON DELETE SET NULL'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('An unremarkable command.'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        variableName,
        pushMenuId,
        messageText,
        messageSoundId,
        popLevelId,
        stopGameId,
        url,
        pushCustomLevelId,
        dartFunctionId,
        description
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
    if (data.containsKey('variable_name')) {
      context.handle(
          _variableNameMeta,
          variableName.isAcceptableOrUnknown(
              data['variable_name']!, _variableNameMeta));
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
    if (data.containsKey('push_custom_level_id')) {
      context.handle(
          _pushCustomLevelIdMeta,
          pushCustomLevelId.isAcceptableOrUnknown(
              data['push_custom_level_id']!, _pushCustomLevelIdMeta));
    }
    if (data.containsKey('dart_function_id')) {
      context.handle(
          _dartFunctionIdMeta,
          dartFunctionId.isAcceptableOrUnknown(
              data['dart_function_id']!, _dartFunctionIdMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
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
      variableName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}variable_name']),
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
      pushCustomLevelId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}push_custom_level_id']),
      dartFunctionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dart_function_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
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

  /// The variable name associated with a row.
  final String? variableName;

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

  /// The ID of a push custom level.
  final int? pushCustomLevelId;

  /// The ID of a dart function to call.
  final int? dartFunctionId;

  /// The description for this command.
  final String description;
  const Command(
      {required this.id,
      this.variableName,
      this.pushMenuId,
      this.messageText,
      this.messageSoundId,
      this.popLevelId,
      this.stopGameId,
      this.url,
      this.pushCustomLevelId,
      this.dartFunctionId,
      required this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || variableName != null) {
      map['variable_name'] = Variable<String>(variableName);
    }
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
    if (!nullToAbsent || pushCustomLevelId != null) {
      map['push_custom_level_id'] = Variable<int>(pushCustomLevelId);
    }
    if (!nullToAbsent || dartFunctionId != null) {
      map['dart_function_id'] = Variable<int>(dartFunctionId);
    }
    map['description'] = Variable<String>(description);
    return map;
  }

  CommandsCompanion toCompanion(bool nullToAbsent) {
    return CommandsCompanion(
      id: Value(id),
      variableName: variableName == null && nullToAbsent
          ? const Value.absent()
          : Value(variableName),
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
      pushCustomLevelId: pushCustomLevelId == null && nullToAbsent
          ? const Value.absent()
          : Value(pushCustomLevelId),
      dartFunctionId: dartFunctionId == null && nullToAbsent
          ? const Value.absent()
          : Value(dartFunctionId),
      description: Value(description),
    );
  }

  factory Command.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Command(
      id: serializer.fromJson<int>(json['id']),
      variableName: serializer.fromJson<String?>(json['variableName']),
      pushMenuId: serializer.fromJson<int?>(json['pushMenuId']),
      messageText: serializer.fromJson<String?>(json['messageText']),
      messageSoundId: serializer.fromJson<int?>(json['messageSoundId']),
      popLevelId: serializer.fromJson<int?>(json['popLevelId']),
      stopGameId: serializer.fromJson<int?>(json['stopGameId']),
      url: serializer.fromJson<String?>(json['url']),
      pushCustomLevelId: serializer.fromJson<int?>(json['pushCustomLevelId']),
      dartFunctionId: serializer.fromJson<int?>(json['dartFunctionId']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'variableName': serializer.toJson<String?>(variableName),
      'pushMenuId': serializer.toJson<int?>(pushMenuId),
      'messageText': serializer.toJson<String?>(messageText),
      'messageSoundId': serializer.toJson<int?>(messageSoundId),
      'popLevelId': serializer.toJson<int?>(popLevelId),
      'stopGameId': serializer.toJson<int?>(stopGameId),
      'url': serializer.toJson<String?>(url),
      'pushCustomLevelId': serializer.toJson<int?>(pushCustomLevelId),
      'dartFunctionId': serializer.toJson<int?>(dartFunctionId),
      'description': serializer.toJson<String>(description),
    };
  }

  Command copyWith(
          {int? id,
          Value<String?> variableName = const Value.absent(),
          Value<int?> pushMenuId = const Value.absent(),
          Value<String?> messageText = const Value.absent(),
          Value<int?> messageSoundId = const Value.absent(),
          Value<int?> popLevelId = const Value.absent(),
          Value<int?> stopGameId = const Value.absent(),
          Value<String?> url = const Value.absent(),
          Value<int?> pushCustomLevelId = const Value.absent(),
          Value<int?> dartFunctionId = const Value.absent(),
          String? description}) =>
      Command(
        id: id ?? this.id,
        variableName:
            variableName.present ? variableName.value : this.variableName,
        pushMenuId: pushMenuId.present ? pushMenuId.value : this.pushMenuId,
        messageText: messageText.present ? messageText.value : this.messageText,
        messageSoundId:
            messageSoundId.present ? messageSoundId.value : this.messageSoundId,
        popLevelId: popLevelId.present ? popLevelId.value : this.popLevelId,
        stopGameId: stopGameId.present ? stopGameId.value : this.stopGameId,
        url: url.present ? url.value : this.url,
        pushCustomLevelId: pushCustomLevelId.present
            ? pushCustomLevelId.value
            : this.pushCustomLevelId,
        dartFunctionId:
            dartFunctionId.present ? dartFunctionId.value : this.dartFunctionId,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('Command(')
          ..write('id: $id, ')
          ..write('variableName: $variableName, ')
          ..write('pushMenuId: $pushMenuId, ')
          ..write('messageText: $messageText, ')
          ..write('messageSoundId: $messageSoundId, ')
          ..write('popLevelId: $popLevelId, ')
          ..write('stopGameId: $stopGameId, ')
          ..write('url: $url, ')
          ..write('pushCustomLevelId: $pushCustomLevelId, ')
          ..write('dartFunctionId: $dartFunctionId, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      variableName,
      pushMenuId,
      messageText,
      messageSoundId,
      popLevelId,
      stopGameId,
      url,
      pushCustomLevelId,
      dartFunctionId,
      description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Command &&
          other.id == this.id &&
          other.variableName == this.variableName &&
          other.pushMenuId == this.pushMenuId &&
          other.messageText == this.messageText &&
          other.messageSoundId == this.messageSoundId &&
          other.popLevelId == this.popLevelId &&
          other.stopGameId == this.stopGameId &&
          other.url == this.url &&
          other.pushCustomLevelId == this.pushCustomLevelId &&
          other.dartFunctionId == this.dartFunctionId &&
          other.description == this.description);
}

class CommandsCompanion extends UpdateCompanion<Command> {
  final Value<int> id;
  final Value<String?> variableName;
  final Value<int?> pushMenuId;
  final Value<String?> messageText;
  final Value<int?> messageSoundId;
  final Value<int?> popLevelId;
  final Value<int?> stopGameId;
  final Value<String?> url;
  final Value<int?> pushCustomLevelId;
  final Value<int?> dartFunctionId;
  final Value<String> description;
  const CommandsCompanion({
    this.id = const Value.absent(),
    this.variableName = const Value.absent(),
    this.pushMenuId = const Value.absent(),
    this.messageText = const Value.absent(),
    this.messageSoundId = const Value.absent(),
    this.popLevelId = const Value.absent(),
    this.stopGameId = const Value.absent(),
    this.url = const Value.absent(),
    this.pushCustomLevelId = const Value.absent(),
    this.dartFunctionId = const Value.absent(),
    this.description = const Value.absent(),
  });
  CommandsCompanion.insert({
    this.id = const Value.absent(),
    this.variableName = const Value.absent(),
    this.pushMenuId = const Value.absent(),
    this.messageText = const Value.absent(),
    this.messageSoundId = const Value.absent(),
    this.popLevelId = const Value.absent(),
    this.stopGameId = const Value.absent(),
    this.url = const Value.absent(),
    this.pushCustomLevelId = const Value.absent(),
    this.dartFunctionId = const Value.absent(),
    this.description = const Value.absent(),
  });
  static Insertable<Command> custom({
    Expression<int>? id,
    Expression<String>? variableName,
    Expression<int>? pushMenuId,
    Expression<String>? messageText,
    Expression<int>? messageSoundId,
    Expression<int>? popLevelId,
    Expression<int>? stopGameId,
    Expression<String>? url,
    Expression<int>? pushCustomLevelId,
    Expression<int>? dartFunctionId,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (variableName != null) 'variable_name': variableName,
      if (pushMenuId != null) 'push_menu_id': pushMenuId,
      if (messageText != null) 'message_text': messageText,
      if (messageSoundId != null) 'message_sound_id': messageSoundId,
      if (popLevelId != null) 'pop_level_id': popLevelId,
      if (stopGameId != null) 'stop_game_id': stopGameId,
      if (url != null) 'url': url,
      if (pushCustomLevelId != null) 'push_custom_level_id': pushCustomLevelId,
      if (dartFunctionId != null) 'dart_function_id': dartFunctionId,
      if (description != null) 'description': description,
    });
  }

  CommandsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? variableName,
      Value<int?>? pushMenuId,
      Value<String?>? messageText,
      Value<int?>? messageSoundId,
      Value<int?>? popLevelId,
      Value<int?>? stopGameId,
      Value<String?>? url,
      Value<int?>? pushCustomLevelId,
      Value<int?>? dartFunctionId,
      Value<String>? description}) {
    return CommandsCompanion(
      id: id ?? this.id,
      variableName: variableName ?? this.variableName,
      pushMenuId: pushMenuId ?? this.pushMenuId,
      messageText: messageText ?? this.messageText,
      messageSoundId: messageSoundId ?? this.messageSoundId,
      popLevelId: popLevelId ?? this.popLevelId,
      stopGameId: stopGameId ?? this.stopGameId,
      url: url ?? this.url,
      pushCustomLevelId: pushCustomLevelId ?? this.pushCustomLevelId,
      dartFunctionId: dartFunctionId ?? this.dartFunctionId,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (variableName.present) {
      map['variable_name'] = Variable<String>(variableName.value);
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
    if (pushCustomLevelId.present) {
      map['push_custom_level_id'] = Variable<int>(pushCustomLevelId.value);
    }
    if (dartFunctionId.present) {
      map['dart_function_id'] = Variable<int>(dartFunctionId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommandsCompanion(')
          ..write('id: $id, ')
          ..write('variableName: $variableName, ')
          ..write('pushMenuId: $pushMenuId, ')
          ..write('messageText: $messageText, ')
          ..write('messageSoundId: $messageSoundId, ')
          ..write('popLevelId: $popLevelId, ')
          ..write('stopGameId: $stopGameId, ')
          ..write('url: $url, ')
          ..write('pushCustomLevelId: $pushCustomLevelId, ')
          ..write('dartFunctionId: $dartFunctionId, ')
          ..write('description: $description')
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
  static const VerificationMeta _intervalMeta =
      const VerificationMeta('interval');
  @override
  late final GeneratedColumn<int> interval = GeneratedColumn<int>(
      'interval', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
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
  List<GeneratedColumn> get $columns =>
      [id, interval, customLevelId, commandTriggerId];
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
    if (data.containsKey('interval')) {
      context.handle(_intervalMeta,
          interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta));
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
      interval: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval']),
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

  /// How often something should happen.
  final int? interval;

  /// The ID of the custom level to attach to.
  final int customLevelId;

  /// The ID of the trigger to use.
  final int commandTriggerId;
  const CustomLevelCommand(
      {required this.id,
      this.interval,
      required this.customLevelId,
      required this.commandTriggerId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || interval != null) {
      map['interval'] = Variable<int>(interval);
    }
    map['custom_level_id'] = Variable<int>(customLevelId);
    map['command_trigger_id'] = Variable<int>(commandTriggerId);
    return map;
  }

  CustomLevelCommandsCompanion toCompanion(bool nullToAbsent) {
    return CustomLevelCommandsCompanion(
      id: Value(id),
      interval: interval == null && nullToAbsent
          ? const Value.absent()
          : Value(interval),
      customLevelId: Value(customLevelId),
      commandTriggerId: Value(commandTriggerId),
    );
  }

  factory CustomLevelCommand.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomLevelCommand(
      id: serializer.fromJson<int>(json['id']),
      interval: serializer.fromJson<int?>(json['interval']),
      customLevelId: serializer.fromJson<int>(json['customLevelId']),
      commandTriggerId: serializer.fromJson<int>(json['commandTriggerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'interval': serializer.toJson<int?>(interval),
      'customLevelId': serializer.toJson<int>(customLevelId),
      'commandTriggerId': serializer.toJson<int>(commandTriggerId),
    };
  }

  CustomLevelCommand copyWith(
          {int? id,
          Value<int?> interval = const Value.absent(),
          int? customLevelId,
          int? commandTriggerId}) =>
      CustomLevelCommand(
        id: id ?? this.id,
        interval: interval.present ? interval.value : this.interval,
        customLevelId: customLevelId ?? this.customLevelId,
        commandTriggerId: commandTriggerId ?? this.commandTriggerId,
      );
  @override
  String toString() {
    return (StringBuffer('CustomLevelCommand(')
          ..write('id: $id, ')
          ..write('interval: $interval, ')
          ..write('customLevelId: $customLevelId, ')
          ..write('commandTriggerId: $commandTriggerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, interval, customLevelId, commandTriggerId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomLevelCommand &&
          other.id == this.id &&
          other.interval == this.interval &&
          other.customLevelId == this.customLevelId &&
          other.commandTriggerId == this.commandTriggerId);
}

class CustomLevelCommandsCompanion extends UpdateCompanion<CustomLevelCommand> {
  final Value<int> id;
  final Value<int?> interval;
  final Value<int> customLevelId;
  final Value<int> commandTriggerId;
  const CustomLevelCommandsCompanion({
    this.id = const Value.absent(),
    this.interval = const Value.absent(),
    this.customLevelId = const Value.absent(),
    this.commandTriggerId = const Value.absent(),
  });
  CustomLevelCommandsCompanion.insert({
    this.id = const Value.absent(),
    this.interval = const Value.absent(),
    required int customLevelId,
    required int commandTriggerId,
  })  : customLevelId = Value(customLevelId),
        commandTriggerId = Value(commandTriggerId);
  static Insertable<CustomLevelCommand> custom({
    Expression<int>? id,
    Expression<int>? interval,
    Expression<int>? customLevelId,
    Expression<int>? commandTriggerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (interval != null) 'interval': interval,
      if (customLevelId != null) 'custom_level_id': customLevelId,
      if (commandTriggerId != null) 'command_trigger_id': commandTriggerId,
    });
  }

  CustomLevelCommandsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? interval,
      Value<int>? customLevelId,
      Value<int>? commandTriggerId}) {
    return CustomLevelCommandsCompanion(
      id: id ?? this.id,
      interval: interval ?? this.interval,
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
    if (interval.present) {
      map['interval'] = Variable<int>(interval.value);
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
          ..write('interval: $interval, ')
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
  static const VerificationMeta _callingCustomLevelCommandIdMeta =
      const VerificationMeta('callingCustomLevelCommandId');
  @override
  late final GeneratedColumn<int> callingCustomLevelCommandId =
      GeneratedColumn<int>('calling_custom_level_command_id', aliasedName, true,
          type: DriftSqlType.int,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES custom_level_commands (id) ON DELETE CASCADE'));
  static const VerificationMeta _releasingCustomLevelCommandIdMeta =
      const VerificationMeta('releasingCustomLevelCommandId');
  @override
  late final GeneratedColumn<int> releasingCustomLevelCommandId =
      GeneratedColumn<int>(
          'releasing_custom_level_command_id', aliasedName, true,
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
        callingCustomLevelCommandId,
        releasingCustomLevelCommandId,
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
    if (data.containsKey('calling_custom_level_command_id')) {
      context.handle(
          _callingCustomLevelCommandIdMeta,
          callingCustomLevelCommandId.isAcceptableOrUnknown(
              data['calling_custom_level_command_id']!,
              _callingCustomLevelCommandIdMeta));
    }
    if (data.containsKey('releasing_custom_level_command_id')) {
      context.handle(
          _releasingCustomLevelCommandIdMeta,
          releasingCustomLevelCommandId.isAcceptableOrUnknown(
              data['releasing_custom_level_command_id']!,
              _releasingCustomLevelCommandIdMeta));
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
      callingCustomLevelCommandId: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}calling_custom_level_command_id']),
      releasingCustomLevelCommandId: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}releasing_custom_level_command_id']),
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

  /// The ID of the custom level command whose activation will will call this
  /// command.
  final int? callingCustomLevelCommandId;

  /// The ID of the custom level command whose release will will call this
  /// command.
  final int? releasingCustomLevelCommandId;

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
      this.callingCustomLevelCommandId,
      this.releasingCustomLevelCommandId,
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
    if (!nullToAbsent || callingCustomLevelCommandId != null) {
      map['calling_custom_level_command_id'] =
          Variable<int>(callingCustomLevelCommandId);
    }
    if (!nullToAbsent || releasingCustomLevelCommandId != null) {
      map['releasing_custom_level_command_id'] =
          Variable<int>(releasingCustomLevelCommandId);
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
      callingCustomLevelCommandId:
          callingCustomLevelCommandId == null && nullToAbsent
              ? const Value.absent()
              : Value(callingCustomLevelCommandId),
      releasingCustomLevelCommandId:
          releasingCustomLevelCommandId == null && nullToAbsent
              ? const Value.absent()
              : Value(releasingCustomLevelCommandId),
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
      callingCustomLevelCommandId:
          serializer.fromJson<int?>(json['callingCustomLevelCommandId']),
      releasingCustomLevelCommandId:
          serializer.fromJson<int?>(json['releasingCustomLevelCommandId']),
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
      'callingCustomLevelCommandId':
          serializer.toJson<int?>(callingCustomLevelCommandId),
      'releasingCustomLevelCommandId':
          serializer.toJson<int?>(releasingCustomLevelCommandId),
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
          Value<int?> callingCustomLevelCommandId = const Value.absent(),
          Value<int?> releasingCustomLevelCommandId = const Value.absent(),
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
        callingCustomLevelCommandId: callingCustomLevelCommandId.present
            ? callingCustomLevelCommandId.value
            : this.callingCustomLevelCommandId,
        releasingCustomLevelCommandId: releasingCustomLevelCommandId.present
            ? releasingCustomLevelCommandId.value
            : this.releasingCustomLevelCommandId,
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
          ..write('callingCustomLevelCommandId: $callingCustomLevelCommandId, ')
          ..write(
              'releasingCustomLevelCommandId: $releasingCustomLevelCommandId, ')
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
      callingCustomLevelCommandId,
      releasingCustomLevelCommandId,
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
          other.callingCustomLevelCommandId ==
              this.callingCustomLevelCommandId &&
          other.releasingCustomLevelCommandId ==
              this.releasingCustomLevelCommandId &&
          other.commandId == this.commandId &&
          other.randomNumberBase == this.randomNumberBase);
}

class CallCommandsCompanion extends UpdateCompanion<CallCommand> {
  final Value<int> id;
  final Value<int?> after;
  final Value<int?> callingCommandId;
  final Value<int?> callingMenuItemId;
  final Value<int?> onCancelMenuId;
  final Value<int?> callingCustomLevelCommandId;
  final Value<int?> releasingCustomLevelCommandId;
  final Value<int> commandId;
  final Value<int?> randomNumberBase;
  const CallCommandsCompanion({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.callingCommandId = const Value.absent(),
    this.callingMenuItemId = const Value.absent(),
    this.onCancelMenuId = const Value.absent(),
    this.callingCustomLevelCommandId = const Value.absent(),
    this.releasingCustomLevelCommandId = const Value.absent(),
    this.commandId = const Value.absent(),
    this.randomNumberBase = const Value.absent(),
  });
  CallCommandsCompanion.insert({
    this.id = const Value.absent(),
    this.after = const Value.absent(),
    this.callingCommandId = const Value.absent(),
    this.callingMenuItemId = const Value.absent(),
    this.onCancelMenuId = const Value.absent(),
    this.callingCustomLevelCommandId = const Value.absent(),
    this.releasingCustomLevelCommandId = const Value.absent(),
    required int commandId,
    this.randomNumberBase = const Value.absent(),
  }) : commandId = Value(commandId);
  static Insertable<CallCommand> custom({
    Expression<int>? id,
    Expression<int>? after,
    Expression<int>? callingCommandId,
    Expression<int>? callingMenuItemId,
    Expression<int>? onCancelMenuId,
    Expression<int>? callingCustomLevelCommandId,
    Expression<int>? releasingCustomLevelCommandId,
    Expression<int>? commandId,
    Expression<int>? randomNumberBase,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (after != null) 'after': after,
      if (callingCommandId != null) 'calling_command_id': callingCommandId,
      if (callingMenuItemId != null) 'calling_menu_item_id': callingMenuItemId,
      if (onCancelMenuId != null) 'on_cancel_menu_id': onCancelMenuId,
      if (callingCustomLevelCommandId != null)
        'calling_custom_level_command_id': callingCustomLevelCommandId,
      if (releasingCustomLevelCommandId != null)
        'releasing_custom_level_command_id': releasingCustomLevelCommandId,
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
      Value<int?>? callingCustomLevelCommandId,
      Value<int?>? releasingCustomLevelCommandId,
      Value<int>? commandId,
      Value<int?>? randomNumberBase}) {
    return CallCommandsCompanion(
      id: id ?? this.id,
      after: after ?? this.after,
      callingCommandId: callingCommandId ?? this.callingCommandId,
      callingMenuItemId: callingMenuItemId ?? this.callingMenuItemId,
      onCancelMenuId: onCancelMenuId ?? this.onCancelMenuId,
      callingCustomLevelCommandId:
          callingCustomLevelCommandId ?? this.callingCustomLevelCommandId,
      releasingCustomLevelCommandId:
          releasingCustomLevelCommandId ?? this.releasingCustomLevelCommandId,
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
    if (callingCustomLevelCommandId.present) {
      map['calling_custom_level_command_id'] =
          Variable<int>(callingCustomLevelCommandId.value);
    }
    if (releasingCustomLevelCommandId.present) {
      map['releasing_custom_level_command_id'] =
          Variable<int>(releasingCustomLevelCommandId.value);
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
          ..write('callingCustomLevelCommandId: $callingCustomLevelCommandId, ')
          ..write(
              'releasingCustomLevelCommandId: $releasingCustomLevelCommandId, ')
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
  late final $CustomLevelsTable customLevels = $CustomLevelsTable(this);
  late final $PushCustomLevelsTable pushCustomLevels =
      $PushCustomLevelsTable(this);
  late final $DartFunctionsTable dartFunctions = $DartFunctionsTable(this);
  late final $CommandsTable commands = $CommandsTable(this);
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
  late final CustomLevelCommandsDao customLevelCommandsDao =
      CustomLevelCommandsDao(this as CrossbowBackendDatabase);
  late final PushCustomLevelsDao pushCustomLevelsDao =
      PushCustomLevelsDao(this as CrossbowBackendDatabase);
  late final DartFunctionsDao dartFunctionsDao =
      DartFunctionsDao(this as CrossbowBackendDatabase);
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
        customLevels,
        pushCustomLevels,
        dartFunctions,
        commands,
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
            on: TableUpdateQuery.onTableName('asset_references',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('custom_levels', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('custom_levels',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('push_custom_levels', kind: UpdateKind.delete),
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
            on: TableUpdateQuery.onTableName('push_custom_levels',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('commands', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('dart_functions',
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
