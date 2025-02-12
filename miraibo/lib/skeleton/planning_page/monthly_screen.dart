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
  abstract Date centeredDate;
  // </states>

  // <presenters>
  /// the origin of the [index] is the month which contains the [centeredDate].
  /// That means the [index] of the month which contains the [centeredDate] is `0`.
  /// When [centeredDate] is 2022-02-01, the [index] of 2022-02 is `0`.
  /// the [index] of 2022-03 is `1`. the [index] of 2022-01 is `-1`.
  Future<Calender> getCalender(index);
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
