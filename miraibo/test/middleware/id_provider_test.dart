import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

import 'package:miraibo/middleware/id_provider.dart';

void main() {
  final logger = Logger();
  final idProvider = IdProvider();
  test('id provider', () {
    for (var i = 0; i < 5; i++) {
      logger.i('$i: ${idProvider.get()}');
    }
  });
}
