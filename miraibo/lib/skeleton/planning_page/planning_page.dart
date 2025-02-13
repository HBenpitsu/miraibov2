import 'package:miraibo/skeleton/planning_page/monthly_screen.dart';
export 'package:miraibo/skeleton/planning_page/monthly_screen.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/daily_screen.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// plannning page consists of two screens: monthly screen and daily screen.
/// initially, monthly screen centered on today's month is shown.
abstract interface class PlanningPage {
  // <navigators>
  /// show initial screen.
  /// the initial screen is the monthly screen centered on today's month.
  MonthlyScreen showInitialScreen();

  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

// </interface>

// <mock>
class MockPlanningPage implements PlanningPage {
  @override
  MonthlyScreen showInitialScreen() {
    final now = DateTime.now();
    final today = Date(now.year, now.month, now.day);
    return MockMonthlyScreen(today);
  }

  @override
  void dispose() {}
}
// </mock>
