import 'dart:io';

import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/services/drugs_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  dotenv.testLoad(fileInput: File('.env').readAsStringSync());
  const String authToken =
      "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOjEsImlhdCI6MTU0OTExMTE5N30.Ao7gDvxtuoMVyrsfeG3G6LDMZwWuIhbb4gJC5IL5Hus";

  group('drug service test group', () {
    DrugService _drugService = DrugService();

    test('search drug', () async {
      List<Drug> result = await _drugService.searchDrug("parac", authToken);
      expect(result.length, greaterThan(0));
    });

    test('fetch drug 5', () async {
      Drug result = await _drugService.fetchDrug(5, authToken);
      expect(result.name, equals('Azitromicina'));
    });
  });
}
