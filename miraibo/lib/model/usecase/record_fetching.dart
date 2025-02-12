import 'package:miraibo/dto/dto.dart';

/// {@template fetchLoggedReceiptRecords}
/// fetch bunch of logged receipt records from recent ones.
/// [limitOfRecords] is the *maximum* number of records to fetch.
/// (The number of records may be less than [limitOfRecords])
/// [skipFirstRecords] is the number of records to skip from the beginning.
/// For example, when you want to fetch 5 records from the 3rd record,
/// you should call this function with limitOfRecords=5 and skipFirstRecords=2.
/// {@endtemplate}
Future<RawReceiptLog> fetchLoggedReceiptRecords(
    int limitOfRecords, int skipFirstRecords) async {
  throw UnimplementedError();
}
