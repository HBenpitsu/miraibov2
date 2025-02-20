import 'dart:async';
import 'dart:math' show Random;

import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/daily_screen.dart';

import 'dart:developer' show log;

// <interface>
/// Monthly screen consists of infinite set of monthly calenders.
/// Each date of the calender navigates to the daily screen.
/// Also, each date has an attribute of event existence.
abstract interface class MonthlyScreen {
  // <states>
  /// The [initiallyCenteredDate] serves as a reference point for the monthly screen, determining what index-0 represents.
  Date get initiallyCenteredDate;
  // </states>

  // <presenters>
  /// the origin of the [index] is the month which contains the [initiallyCenteredDate].
  /// That means the [index] of the month which contains the [initiallyCenteredDate] is `0`.
  /// When [initiallyCenteredDate] is 2022-02-01, the [index] of 2022-02 is `0`.
  /// the [index] of 2022-03 is `1`. the [index] of 2022-01 is `-1`.
  Calender getCalender(int index);
  // </presenters>

  // <navigators>
  /// when the date of the calender is tapped, navigate to the daily screen.
  DailyScreen navigateToDailyScreen(int year, int month, int day);

  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>

// <view model>
class Calender {
  final int year;
  final int month;
  final int daysInMonth;

  /// the offset is a weekday of the first day of the month
  /// 0: Sunday, 1: Monday, ..., 6: Saturday
  final int firstDayOfWeek;

  /// the length of the list is the number of days in the month
  /// Each element represents the existence of an event on the day.
  /// Watch out for the index of the list. It starts from 0.
  /// Do not forget to add 1 to the index to get the day.
  final Future<List<EventExistence>> events;

  const Calender(this.year, this.month, this.daysInMonth, this.firstDayOfWeek,
      this.events);

  int get numberOfRow {
    return ((firstDayOfWeek + daysInMonth) / 7).ceil();
  }
}
// </view model>

// <mock>
class MockMonthlyScreen implements MonthlyScreen {
  @override
  final Date initiallyCenteredDate;
  final Random _random = Random();

  MockMonthlyScreen(this.initiallyCenteredDate);

  @override
  Calender getCalender(int index) {
    log('getCalender is called with index: $index');
    final firstDay = DateTime(
        initiallyCenteredDate.year, initiallyCenteredDate.month + index, 1);
    final lastDay = DateTime(
        initiallyCenteredDate.year, initiallyCenteredDate.month + index + 1, 0);
    final firstWeekday = firstDay.weekday % 7; // make Sunday(7) to 0
    final events = List.generate(lastDay.day, (index) {
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
    return Calender(firstDay.year, firstDay.month, lastDay.day, firstWeekday,
        Future.value(events));
  }

  @override
  DailyScreen navigateToDailyScreen(int year, int month, int day) {
    log('navigateToDailyScreen is called with year: $year, month: $month, day: $day');
    return MockDailyScreen(year, month, day);
  }

  @override
  void dispose() {
    log('MonthlyScreen is disposed');
  }
}
// </mock>