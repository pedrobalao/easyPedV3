import 'dart:io';

import 'package:easypedv3/utils/map_utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  dotenv.loadFromString(envString: File('.env').readAsStringSync());

  group('test map to json', () {
    final mapVariables = {};
    mapVariables['elem1'] = '24.5';
    mapVariables['elem2'] = '24';

    test('get json of two elements map', () async {
      final result = MapUtils.toJSON(mapVariables);

      expect(result, equals('{"elem1":"24.5","elem2":"24"}'));
    });
  });
}
