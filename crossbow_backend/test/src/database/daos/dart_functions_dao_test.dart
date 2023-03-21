import 'package:crossbow_backend/extensions.dart';
import 'package:test/test.dart';

import '../../../custom_database.dart';

void main() {
  group(
    'DartFunctionsDao',
    () {
      final db = getDatabase();

      final dartFunctionsDao = db.dartFunctionsDao;

      test(
        '.createDartFunction',
        () async {
          final f = await dartFunctionsDao.createDartFunction(
            description: 'Testing.',
          );
          expect(f.id, isNonZero);
          expect(f.description, 'Testing.');
        },
      );

      test(
        '.deleteDartFunction',
        () async {
          final f = await dartFunctionsDao.createDartFunction(
            description: 'Testing.',
          );
          await dartFunctionsDao.deleteDartFunction(id: f.id);
          await expectLater(
            dartFunctionsDao.getDartFunction(id: f.id),
            throwsStateError,
          );
        },
      );

      test(
        '.setDescription',
        () async {
          final f =
              await dartFunctionsDao.createDartFunction(description: 'Test');
          var updatedFunction = await dartFunctionsDao.setDescription(
            dartFunctionId: f.id,
            description: 'Something else',
          );
          expect(updatedFunction.id, f.id);
          expect(updatedFunction.description, 'Something else');
          updatedFunction = await dartFunctionsDao.setDescription(
            dartFunctionId: f.id,
            description: f.description,
          );
          expect(updatedFunction.id, f.id);
          expect(updatedFunction.description, f.description);
        },
      );

      test(
        '.getDartFunctions',
        () async {
          await db.delete(db.dartFunctions).go();
          final f2 =
              await dartFunctionsDao.createDartFunction(description: '2');
          final f1 =
              await dartFunctionsDao.createDartFunction(description: '1');
          final functions = await dartFunctionsDao.getDartFunctions();
          expect(functions.length, 2);
          expect(functions.first.id, f1.id);
          expect(functions.last.id, f2.id);
        },
      );

      test(
        '.setName',
        () async {
          final f = await dartFunctionsDao.createDartFunction(
            description: 'Testing.',
          );
          expect(f.functionName, null);
          expect(f.name, 'function${f.id}');
          const name = 'doSomething';
          var updatedFunction = await dartFunctionsDao.setName(
            dartFunctionId: f.id,
            name: name,
          );
          expect(updatedFunction.id, f.id);
          expect(updatedFunction.functionName, name);
          expect(updatedFunction.name, name);
          updatedFunction = await dartFunctionsDao.setName(
            dartFunctionId: f.id,
          );
          expect(updatedFunction.id, f.id);
          expect(updatedFunction.functionName, null);
          expect(updatedFunction.name, 'function${f.id}');
        },
      );
    },
  );
}
