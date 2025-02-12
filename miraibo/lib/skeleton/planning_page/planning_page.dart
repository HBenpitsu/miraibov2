import 'package:miraibo/skeleton/planning_page/monthly_screen.dart';

// <interface>
abstract interface class PlanningPage {
  /// plannning page consists of two screens: monthly screen and daily screen.
  /// initially, monthly screen centered on today's month is shown.

  // <navigators>
  MonthlyScreen showInitialScreen();
  // </navigators>
}

// </interface>
