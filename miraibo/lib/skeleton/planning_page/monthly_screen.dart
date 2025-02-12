import 'dart:async';
import 'dart:math' show Random;

import 'package:miraibo/dto/enumration.dart';
import 'package:miraibo/dto/general.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/daily_screen.dart';

// <interface>
abstract interface class MonthlyScreen {
  /// Monthly screen consists of infinite set of monthly calenders.
  /// Each date of the calender navigates to the daily screen.
  /// Also, each date has an attribute of event existence.

  // <states>
  /// The [centeredDate] serves as a reference point for the monthly screen, determining what index-0 represents.
  Date get centeredDate;
  // </states>

  // <presenters>
  /// the origin of the [index] is the month which contains the [centeredDate].
  /// That means the [index] of the month which contains the [centeredDate] is `0`.
  /// When [centeredDate] is 2022-02-01, the [index] of 2022-02 is `0`.
  /// the [index] of 2022-03 is `1`. the [index] of 2022-01 is `-1`.
  Future<Calender> getCalender(int index);
  // </presenters>

  // <navigators>
  DailyScreen navigateToDailyScreen(int year, int month, int day);
  // </navigators>
}
// </interface>

// <view model>
class Calender {
  final int year;
  final int month;

  /// the offset is a weekday of the first day of the month
  /// 0: Sunday, 1: Monday, ..., 6: Saturday
  final int firstWeekday;
  final List<EventExistence> events;

  const Calender(this.year, this.month, this.firstWeekday, this.events);
}
// </view model>

// <mock>
class MockMonthlyScreen implements MonthlyScreen {
  @override
  final Date centeredDate;
  final Random _random = Random();

  MockMonthlyScreen(this.centeredDate);

  @override
  Future<Calender> getCalender(int index) {
    var firstDay = DateTime(centeredDate.year, centeredDate.month + index, 1);
    var lastDay =
        DateTime(centeredDate.year, centeredDate.month + index + 1, 0);
    var firstWeekday = firstDay.weekday % 7; // make Sunday(7) to 0
    var events = List.generate(lastDay.day, (index) {
      switch (_random.nextInt(3)) {
        case 0:
          return EventExistence.none;
        case 1:
          return EventExistence.important;
        case 2:
          return EventExistence.trivial;
        default:
          throw Exception('Invalid random number occurred');
      }
    });
    return Future.value(
        Calender(firstDay.year, firstDay.month, firstWeekday, events));
  }

  @override
  DailyScreen navigateToDailyScreen(int year, int month, int day) {
    throw UnimplementedError();
  }
}
// </mock>