import 'package:flutter_test/flutter_test.dart';
import 'package:miraibo/framework/value/date_time.dart';

void main() {
  test('Period', () {
    var now = DateTime.now();
    var period = Period.from(now, const Duration(days: 1));
    var period2 = Period.from(now, const Duration(days: 2));
    expect(period.duration, const Duration(days: 1));
    expect(period.valid, true);
    expect(period.fitsIn(period2), true);
    expect(period.containsDate(now), true);
    expect(period.containsPeriod(period2), false);
    var invalidPeriod = Period.from(now, const Duration(days: -1));
    expect(invalidPeriod.valid, false);
  });
}
