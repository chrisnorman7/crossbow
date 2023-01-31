import 'dart:convert';

import 'package:uuid/uuid.dart';

/// The type of JSON.
typedef JsonType = Map<String, dynamic>;

/// The UUID generator to use.
const _uuid = Uuid();

/// Get a new ID.
String newId() => _uuid.v4();

/// The key which holds the most recently loaded project path.
const recentProjectPathKey = 'crossbow_last_loaded_project_path';

/// The JSON encoder to use.
const indentedJsonEncoder = JsonEncoder.withIndent('  ');
