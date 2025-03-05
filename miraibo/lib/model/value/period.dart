import 'package:logger/logger.dart';
import 'package:miraibo/model/value/date.dart';

class Period {
  /// null when unbounded
  final Date begins;

  /// null when unbounded
  final Date ends;

  Period({required this.begins, required this.ends}) {
    if (begins > ends) {
      throw ArgumentError('begins must be less than or equal to ends');
    }
  }

  Period.endless({required this.begins}) : ends = Date.latest;
  Period.startless({required this.ends}) : begins = Date.earliest;

  static final Period entirePeriod =
      Period(begins: Date.earliest, ends: Date.latest);

  Period.singleDay(Date date)
      : begins = date,
        ends = date;

  static const int _recentDaysThreshold = 3;
  Period.recentDays()
      : begins = Date.today().withDelta(days: -_recentDaysThreshold),
        ends = Date.today();
  static Period oldDays() => Period.startless(
      ends: Date.today().withDelta(days: -_recentDaysThreshold - 1));

  Period.nextDays(int days)
      : begins = Date.today(),
        ends = Date.today().withDelta(days: days - 1);

  Period.futureOrToday()
      : begins = Date.today(),
        ends = Date.latest;
  Period.future()
      : begins = Date.today().withDelta(days: 1),
        ends = Date.latest;

  Period.pastOrToday()
      : begins = Date.earliest,
        ends = Date.today();
  Period.past()
      : begins = Date.earliest,
        ends = Date.today().withDelta(days: -1);

  bool get isEndless => ends >= Date.latest;
  bool get isStartless => begins <= Date.earliest;

  int get durationInDays => (ends - begins).inDays + 1;

  /// inclusive
  bool contains(Date date) {
    return isStarted(date) && !isOver(date);
  }

  /// inclusive
  bool isStarted(Date date) {
    return begins <= date;
  }

  /// exclusive
  bool isOver(Date date) {
    return date < ends;
  }

  Period? intersection(Period other) {
    final Date begins = this.begins > other.begins ? this.begins : other.begins;
    final Date ends = this.ends < other.ends ? this.ends : other.ends;
    if (begins <= ends) {
      return Period(begins: begins, ends: ends);
    }
    return null;
  }

  Iterable<Date> dates() sync* {
    if (isStartless || isEndless) {
      Logger().w('dates for infinite period are iterated.');
    }
    for (var date = begins; date <= ends; date = date.withDelta(days: 1)) {
      yield date;
    }
  }

  @override
  String toString() => '$begins - $ends';
}
