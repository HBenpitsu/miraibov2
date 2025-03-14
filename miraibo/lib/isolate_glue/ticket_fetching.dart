import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/repository/impl.dart' as repository;

// <fetchTicketsOn>
Future<List<Ticket>> __fetchTicketsOn(Date date) {
  repository.bind();
  return usecase.fetchTicketsOn(date);
}

/// {@macro fetchTicketsOn}
Future<List<Ticket>> fetchTicketsOn(Date date) {
  return usecase.fetchTicketsOn(date);
  // return compute(__fetchTicketsOn, date);
}
// </fetchTicketsOn

// <fetchReceiptLogsAndMonitorsForToday>
Future<List<Ticket>> __fetchReceiptLogsAndMonitorsForToday(() param) {
  repository.bind();
  return usecase.fetchReceiptLogsAndMonitorsForToday();
}

/// {@macro fetchReceiptLogsAndMonitorsForToday}
Future<List<Ticket>> fetchReceiptLogsAndMonitorsForToday() async {
  return usecase.fetchReceiptLogsAndMonitorsForToday();
  // return compute(__fetchReceiptLogsAndMonitorsForToday, ());
}
// </fetchReceiptLogsAndMonitorsForToday>
