import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';

// <fetchTicketsOn>
/// {@macro fetchTicketsOn}
Future<List<Ticket>> fetchTicketsOn(Date date) {
  return compute(usecase.fetchTicketsOn, date);
}
// </fetchTicketsOn

// <fetchReceiptLogsAndMonitorsForToday>
Future<List<Ticket>> __fetchReceiptLogsAndMonitorsForToday(() param) {
  return usecase.fetchReceiptLogsAndMonitorsForToday();
}

/// {@macro fetchReceiptLogsAndMonitorsForToday}
Future<List<Ticket>> fetchReceiptLogsAndMonitorsForToday() async {
  return compute(__fetchReceiptLogsAndMonitorsForToday, ());
}
// </fetchReceiptLogsAndMonitorsForToday>
