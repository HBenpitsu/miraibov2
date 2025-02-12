import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';

Future<RawReceiptLog> __fetchLoggedReceiptRecords((int, int) param) {
  return usecase.fetchLoggedReceiptRecords(param.$1, param.$2);
}

/// {@macro fetchLoggedReceiptRecords}
Future<RawReceiptLog> fetchLoggedReceiptRecords(
    int limitOfRecords, int skipFirstRecords) async {
  return compute(
      __fetchLoggedReceiptRecords, (limitOfRecords, skipFirstRecords));
}
