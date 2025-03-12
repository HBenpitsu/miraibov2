import 'package:flutter_test/flutter_test.dart';
import 'package:miraibo/middleware/csv_parser.dart';

void main() {
  test('csv parser', () {
    final csv = CSVLineParser.encode([1, 2, 3, 4, '5,9', '"6, 7"', 8, '9,']);
    final parsed = CSVLineParser.parse(csv);
    expect(parsed, ['1', '2', '3', '4', '5,9', '"6, 7"', '8', '9,']);
  });
}
