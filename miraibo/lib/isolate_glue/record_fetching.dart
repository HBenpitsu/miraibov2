import 'dart:isolate';

import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';

__fetchLoggedReceiptRecord((int, SendPort) params) async {
  final index = params.$1;
  final sendPort = params.$2;
  final logStream = usecase.fetchLoggedReceiptRecord(index);
  await for (final log in logStream) {
    sendPort.send(log);
  }
}

/// {@macro fetchLoggedReceiptRecords}
Stream<ReceiptLogSchemeInstance?> fetchLoggedReceiptRecord(int index) async* {
  final receivePort = ReceivePort();
  final isolate = await Isolate.spawn(
      __fetchLoggedReceiptRecord, (index, receivePort.sendPort));
  await for (final log in receivePort) {
    if (log == null) {
      receivePort.close();
    }
    yield log;
  }
  isolate.kill();
}
