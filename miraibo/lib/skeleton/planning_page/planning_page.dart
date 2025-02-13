import 'package:miraibo/skeleton/planning_page/monthly_screen.dart';

// <interface>
/// plannning page consists of two screens: monthly screen and daily screen.
/// initially, monthly screen centered on today's month is shown.
abstract interface class PlanningPage {
  // <navigators>
  MonthlyScreen showInitialScreen();
  // </navigators>
}

// </interface>

// <mock>
class MockPlanningPage implements PlanningPage {
  @override
  MonthlyScreen showInitialScreen() {
    throw UnimplementedError();
  }
}
// </mock>
