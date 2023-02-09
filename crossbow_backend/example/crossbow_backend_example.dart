// ignore_for_file: avoid_print
import 'dart:io';

import 'package:crossbow_backend/crossbow_backend.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

Future<void> main() async {
  final db = CrossbowBackendDatabase(
    LazyDatabase(
      () => NativeDatabase(File('db.sqlite3')),
    ),
  );
  final menus = db.menusDao;
  final menu = await menus.createMenu(name: 'Main Menu');
  await menus.createMenuItem(menuId: menu.id, name: 'Play Game');
  await menus.createMenuItem(menuId: menu.id, name: 'Quit');
  final popLevel = await db.into(db.popLevels).insertReturning(
        const PopLevelsCompanion(),
      );
  final command = await db.into(db.commands).insertReturning(
        CommandsCompanion(
          popLevelId: Value(popLevel.id),
        ),
      );
  print(command);
  await (db.delete(db.commands)
        ..where((final table) => table.id.equals(command.id)))
      .go();
  print(
    await (db.select(db.popLevels)
          ..where((final table) => table.id.equals(command.popLevelId!)))
        .get(),
  );
}
