import 'dart:convert';

import 'package:uuid/uuid.dart';

/// The type of JSON.
typedef JsonType = Map<String, dynamic>;

/// The UUID generator to use.
const uuid = Uuid();

/// The key which holds the most recently loaded project path.
const recentProjectPathKey = 'crossbow_last_loaded_project_path';

/// The JSON encoder to use.
const indentedJsonEncoder = JsonEncoder.withIndent('  ');

/// The default project filename.
const defaultProjectFilename = 'project.json';
