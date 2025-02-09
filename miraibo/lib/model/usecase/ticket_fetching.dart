import 'package:miraibo/dto/dto.dart';

/// {@template fetchTicketsOn}
/// fetches tickets on the given date
/// returns the list of ticket
/// {@endtemplate}
Future<List<Ticket>> fetchTicketsOn(Date date) async {
  throw UnimplementedError();
}

/// {@template fetchReceiptLogsAndMonitorsForToday}
/// fetches tickets for today
/// {@endtemplate}
Future<List<ReceiptLogAndMonitorTicket>>
    fetchReceiptLogsAndMonitorsForToday() async {
  throw UnimplementedError();
}

/// {@template fetchReceiptLogs}
/// fetches tickets for this week
/// {@endtemplate}
Future<ReceiptLogTicket> fetchReceiptLogs(
    int limitOfRecords, int skipFirstRecords) async {
  throw UnimplementedError();
}
