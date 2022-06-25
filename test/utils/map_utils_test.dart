import 'dart:io';

import 'package:easypedv3/utils/map_utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  dotenv.testLoad(fileInput: File('.env').readAsStringSync());

  group('test map to json', () {
    var mapVariables = {};
    mapVariables["elem1"] = "24.5";
    mapVariables["elem2"] = "24";

    test('get json of two elements map', () async {
      var result = MapUtils.toJSON(mapVariables);

      expect(result, equals("{\"elem1\":\"24.5\",\"elem2\":\"24\"}"));
    });
  });
}
