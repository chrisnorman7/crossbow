import 'package:dart_sdl/dart_sdl.dart';
import 'package:drift/drift.dart';

import 'asset_references.dart';
import 'mixins.dart';

/// The menus table.
class Menus extends Table with WithPrimaryKey, WithName {
  /// The music to use for this menu.
  IntColumn get musicId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.setNull)
      .nullable()();

  /// The sound to use when selecting an item.
  IntColumn get selectItemSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.setNull)
      .nullable()();

  /// The sound to use when activating an item.
  IntColumn get activateItemSoundId => integer()
      .references(AssetReferences, #id, onDelete: KeyAction.setNull)
      .nullable()();

  /// The scan code to use to move up this menu.
  IntColumn get upScanCode =>
      intEnum<ScanCode>().withDefault(Constant(ScanCode.up.index))();

  /// The game controller button to use to move up in the menu.
  IntColumn get upButton => intEnum<GameControllerButton>()
      .withDefault(Constant(GameControllerButton.dpadUp.index))();

  /// The scan code to use to move down this menu.
  IntColumn get downScanCode =>
      intEnum<ScanCode>().withDefault(Constant(ScanCode.down.index))();

  /// The game controller button to use to move down in the menu.
  IntColumn get downButton => intEnum<GameControllerButton>()
      .withDefault(Constant(GameControllerButton.dpadDown.index))();

  /// The scan code to use to activate items in this menu.
  IntColumn get activateScanCode =>
      intEnum<ScanCode>().withDefault(Constant(ScanCode.space.index))();

  /// The game controller button to use to activate items in this menu.
  IntColumn get activateButton => intEnum<GameControllerButton>()
      .withDefault(Constant(GameControllerButton.dpadRight.index))();

  /// The scan code to use to cancel this menu.
  IntColumn get cancelScanCode =>
      intEnum<ScanCode>().withDefault(Constant(ScanCode.escape.index))();

  /// The game controller button to use to cancel this menu.
  IntColumn get cancelButton => intEnum<GameControllerButton>()
      .withDefault(Constant(GameControllerButton.dpadLeft.index))();

  /// The game controller axis to use to move through this menu.
  IntColumn get movementAxis => intEnum<GameControllerAxis>()
      .withDefault(Constant(GameControllerAxis.lefty.index))();

  /// The game controller axis to use to activate menu items.
  IntColumn get activateAxis => intEnum<GameControllerAxis>()
      .withDefault(Constant(GameControllerAxis.triggerright.index))();

  /// The game controller axis to use to cancel this menu.
  IntColumn get cancelAxis => intEnum<GameControllerAxis>()
      .withDefault(Constant(GameControllerAxis.triggerleft.index))();
}
