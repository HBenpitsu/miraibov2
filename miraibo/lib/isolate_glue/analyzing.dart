import 'dart:isolate';
import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/shared/enumeration.dart';
import 'package:miraibo/repository/impl.dart' as repository;

Future<EstimationTicket> __estimateWithScheme(
    (int, int, EstimationDisplayOption) param) {
  repository.bind();
  return usecase.estimateWithScheme(param.$1, param.$2, param.$3);
}

/// {@macro estimateWithScheme}
Future<EstimationTicket> estimateWithScheme(
    int categoryId, int currencyId, EstimationDisplayOption displayOption) {
  return usecase.estimateWithScheme(categoryId, currencyId, displayOption);
  // return compute(
  //     __estimateWithScheme, (categoryIds, currencyId, displayOption));
}

__estimateFor((int, SendPort) params) async {
  repository.bind();
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
  yield* usecase.estimateFor(estimationSchemeId);
  // final receivePort = ReceivePort();
  // final isolate = await Isolate.spawn(
  //     __estimateFor, (estimationSchemeId, receivePort.sendPort));
  // await for (final log in receivePort) {
  //   if (log == null) {
  //     receivePort.close();
  //     return;
  //   }
  //   yield log;
  // }
  // isolate.kill();
}

Future<MonitorTicket> __monitorWithScheme(
    (OpenPeriod, List<int>, MonitorDisplayOption, int) param) {
  repository.bind();
  return usecase.monitorWithScheme(param.$1, param.$2, param.$3, param.$4);
}

/// {@macro monitorWithScheme}
Future<MonitorTicket> monitorWithScheme(OpenPeriod period,
    List<int> categoryIds, MonitorDisplayOption displayOption, int currencyId) {
  return usecase.monitorWithScheme(
      period, categoryIds, displayOption, currencyId);
  // return compute(
  //     __monitorWithScheme, (period, categoryIds, displayOption, currencyId));
}

__monitorFor((int, SendPort) params) async {
  repository.bind();
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
  yield* usecase.monitorFor(monitorSchemeId);
  // final receivePort = ReceivePort();
  // final isolate = await Isolate.spawn(
  //     __monitorFor, (monitorSchemeId, receivePort.sendPort));
  // await for (final log in receivePort) {
  //   if (log == null) {
  //     receivePort.close();
  //     return;
  //   }
  //   yield log;
  // }
  // isolate.kill();
}
