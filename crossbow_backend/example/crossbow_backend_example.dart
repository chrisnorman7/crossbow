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
  final command =
      await db.into(db.commands).insertReturning(const CommandsCompanion());
  print(command);
}
