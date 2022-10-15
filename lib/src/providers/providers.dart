import 'dart:convert';
import 'dart:io';

import 'package:dart_sdl/dart_sdl.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../json/json_value_context.dart';
import '../json/presets/preset_collection.dart';
import 'app_context.dart';
import 'preset_argument.dart';
import 'preset_context.dart';
import 'preset_field_argument.dart';
import 'preset_field_context.dart';

/// Provide an app context.
final appContextProvider = FutureProvider((final ref) async {
  final synthizer = Synthizer()..initialize();
  final context = synthizer.createContext();
  final sdl = Sdl();
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final crossbowDirectory =
      Directory(path.join(documentsDirectory.path, 'crossbow'));
  return AppContext(
    crossbowDirectory: crossbowDirectory,
    synthizer: synthizer,
    context: context,
    sdl: sdl,
  );
});

/// Provide the current presets.
final presetCollectionsProvider = FutureProvider((final ref) async {
  final context = await ref.watch(appContextProvider.future);
  final presetsDirectory = context.presetsDirectory;
  if (!presetsDirectory.existsSync()) {
    return <JsonValueContext<PresetCollection>>[];
  }
  return presetsDirectory
      .listSync()
      .whereType<File>()
      .where(
        (final element) =>
            path.extension(element.path) == presetCollectionFileExtension,
      )
      .map<JsonValueContext<PresetCollection>>(
    (final e) {
      final data = e.readAsStringSync();
      final json = jsonDecode(data) as JsonType;
      final collection = PresetCollection.fromJson(json);
      return JsonValueContext(file: e, value: collection);
    },
  );
});

/// Provide a single preset collection.
final presetCollectionProvider =
    Provider.family<JsonValueContext<PresetCollection>, File>(
  (final ref, final file) {
    final data = file.readAsStringSync();
    final json = jsonDecode(data) as JsonType;
    final presetCollection = PresetCollection.fromJson(json);
    return JsonValueContext(file: file, value: presetCollection);
  },
);

/// Provide a single preset.
final presetProvider = Provider.family<PresetContext, PresetArgument>(
  (final ref, final arg) {
    final presetCollectionContext = ref.watch(
      presetCollectionProvider.call(arg.file),
    );
    return PresetContext(
      presetCollectionContext: presetCollectionContext,
      id: arg.id,
    );
  },
);

/// Provide a single preset field.
final presetFieldProvider =
    Provider.family<PresetFieldContext, PresetFieldArgument>(
  (final ref, final arg) {
    final presetContext = ref.watch(
      presetProvider.call(
        PresetArgument(
          file: arg.presetCollectionContext.file,
          id: arg.presetId,
        ),
      ),
    );
    return PresetFieldContext(
      presetContext: presetContext,
      presetFieldId: arg.presetFieldId,
      presetId: presetContext.id,
    );
  },
);
