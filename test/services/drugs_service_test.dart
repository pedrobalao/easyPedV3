import 'dart:io';

import 'package:easypedv3/services/drugs_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  dotenv.loadFromString(envString: File('.env').readAsStringSync());
  final authToken = dotenv.env['TEST_TOKEN'];

  group('drug service test group', () {
    final drugService = DrugService();

    test('search drug', () async {
      final result = await drugService.searchDrug('parac', authToken!);
      expect(result.length, greaterThan(0));
    });

    test('fetch drug 5', () async {
      final result = await drugService.fetchDrug(5, authToken!);
      expect(result.name, equals('Azitromicina'));
    });
  });
}
