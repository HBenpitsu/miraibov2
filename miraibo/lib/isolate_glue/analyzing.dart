import 'dart:isolate';
import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/shared/enumeration.dart';

Future<EstimationTicket> __estimateWithScheme(
    (int, int, EstimationDisplayOption) param) {
  return usecase.estimateWithScheme(param.$1, param.$2, param.$3);
}

/// {@macro estimateWithScheme}
Future<EstimationTicket> estimateWithScheme(
    int categoryIds, int currencyId, EstimationDisplayOption displayOption) {
  return compute(
      __estimateWithScheme, (categoryIds, currencyId, displayOption));
}

__estimateFor((int, SendPort) params) async {
  final estimationSchemeId = params.$1;
  final sendPort = params.$2;
  final logStream = usecase.estimateFor(estimationSchemeId);
  await for (final log in logStream) {
    sendPort.send(log);
  }
  sendPort.send(null);
}

/// {@macro estimateFor}
Stream<EstimationTicket> estimateFor(int estimationSchemeId) async* {
  final receivePort = ReceivePort();
  final isolate = await Isolate.spawn(
      __estimateFor, (estimationSchemeId, receivePort.sendPort));
  await for (final log in receivePort) {
    if (log == null) {
      receivePort.close();
      return;
    }
    yield log;
  }
  isolate.kill();
}

Future<MonitorTicket> __monitorWithScheme(
    (OpenPeriod, List<int>, MonitorDisplayOption, int) param) {
  return usecase.monitorWithScheme(param.$1, param.$2, param.$3, param.$4);
}

/// {@macro monitorWithScheme}
Future<MonitorTicket> monitorWithScheme(OpenPeriod period,
    List<int> categoryIds, MonitorDisplayOption displayOption, int currencyId) {
  return compute(
      __monitorWithScheme, (period, categoryIds, displayOption, currencyId));
}

__monitorFor((int, SendPort) params) async {
  final monitorSchemeId = params.$1;
  final sendPort = params.$2;
  final logStream = usecase.monitorFor(monitorSchemeId);
  await for (final log in logStream) {
    sendPort.send(log);
  }
  sendPort.send(null);
}

/// {@macro monitorFor}
Stream<MonitorTicket?> monitorFor(int monitorSchemeId) async* {
  final receivePort = ReceivePort();
  final isolate = await Isolate.spawn(
      __monitorFor, (monitorSchemeId, receivePort.sendPort));
  await for (final log in receivePort) {
    if (log == null) {
      receivePort.close();
      return;
    }
    yield log;
  }
  isolate.kill();
}
