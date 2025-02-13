import 'package:miraibo/skeleton/planning_page/monthly_screen.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// plannning page consists of two screens: monthly screen and daily screen.
/// initially, monthly screen centered on today's month is shown.
abstract interface class PlanningPage {
  // <navigators>
  /// show initial screen.
  /// the initial screen is the monthly screen centered on today's month.
  MonthlyScreen showInitialScreen();
  // </navigators>
  void dispose();
}

// </interface>

// <mock>
class MockPlanningPage implements PlanningPage {
  @override
  MonthlyScreen showInitialScreen() {
    var now = DateTime.now();
    var today = Date(now.year, now.month, now.day);
    return MockMonthlyScreen(today);
  }

  @override
  void dispose() {}
}
// </mock>
