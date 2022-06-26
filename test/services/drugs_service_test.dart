import 'dart:io';

import 'package:easypedv3/models/drug.dart';
import 'package:easypedv3/services/drugs_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  dotenv.testLoad(fileInput: File('.env').readAsStringSync());
  final String? authToken = dotenv.env['TEST_TOKEN'];

  group('drug service test group', () {
    DrugService _drugService = DrugService();

    test('search drug', () async {
      List<Drug> result = await _drugService.searchDrug("parac", authToken!);
      expect(result.length, greaterThan(0));
    });

    test('fetch drug 5', () async {
      Drug result = await _drugService.fetchDrug(5, authToken!);
      expect(result.name, equals('Azitromicina'));
    });
  });
}
