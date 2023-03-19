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
    },
  );
}
