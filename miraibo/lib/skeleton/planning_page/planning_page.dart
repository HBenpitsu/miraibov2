import 'package:miraibo/skeleton/planning_page/daily_screen/daily_screen.dart';
import 'package:miraibo/skeleton/planning_page/monthly_screen.dart';

// <interface>
abstract interface class PlanningPagePresenter {
  MonthlyScreenPresenter get monthlyScreenPresenter;
  DailyScreenPresenter get dailyScreenPresenter;
}

abstract interface class PlanningPageController {
  MonthlyScreenController get monthlyScreenController;
  DailyScreenController get dailyScreenController;
}
// </interface>