import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';

Future<ReceiptLogSchemeInstance> __fetchLoggedReceiptRecords((int, int) param) {
  return usecase.fetchLoggedReceiptRecords(param.$1, param.$2);
}

/// {@macro fetchLoggedReceiptRecords}
Future<ReceiptLogSchemeInstance> fetchLoggedReceiptRecords(
    int limitOfRecords, int skipFirstRecords) async {
  return compute(
      __fetchLoggedReceiptRecords, (limitOfRecords, skipFirstRecords));
}
