import 'dart:async';
import 'dart:math' show Random;

import 'package:miraibo/dto/enumration.dart';
import 'package:miraibo/dto/general.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/daily_screen.dart';

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
  Future<Calender> getCalender(int index);
  // </presenters>

  // <navigators>
  /// when the date of the calender is tapped, navigate to the daily screen.
  DailyScreen navigateToDailyScreen(int year, int month, int day);
  // </navigators>
  void dispose();
}
// </interface>

// <view model>
class Calender {
  final int year;
  final int month;

  /// the offset is a weekday of the first day of the month
  /// 0: Sunday, 1: Monday, ..., 6: Saturday
  final int firstWeekday;

  /// the length of the list is the number of days in the month
  /// Each element represents the existence of an event on the day.
  /// Watch out for the index of the list. It starts from 0.
  /// Do not forget to add 1 to the index to get the day.
  final List<EventExistence> events;

  const Calender(this.year, this.month, this.firstWeekday, this.events);
}
// </view model>

// <mock>
class MockMonthlyScreen implements MonthlyScreen {
  @override
  final Date initiallyCenteredDate;
  final Random _random = Random();

  MockMonthlyScreen(this.initiallyCenteredDate);

  @override
  Future<Calender> getCalender(int index) {
    var firstDay = DateTime(
        initiallyCenteredDate.year, initiallyCenteredDate.month + index, 1);
    var lastDay = DateTime(
        initiallyCenteredDate.year, initiallyCenteredDate.month + index + 1, 0);
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
    return MockDailyScreen(year, month, day);
  }

  @override
  void dispose() {}
}
// </mock>