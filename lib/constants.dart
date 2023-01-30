import 'package:uuid/uuid.dart';

/// The type of JSON.
typedef JsonType = Map<String, dynamic>;

/// The UUID generator to use.
const _uuid = Uuid();

/// Get a new ID.
String newId() => _uuid.v4();
