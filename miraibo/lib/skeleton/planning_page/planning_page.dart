import 'package:miraibo/skeleton/planning_page/daily_screen.dart';
import 'package:miraibo/skeleton/planning_page/monthly_screen.dart';

class PlanningPagePresenter {
  final DailyScreenPresenter dailyScreenPresenter = DailyScreenPresenter();
  final MonthlyScreenPresenter monthlyScreenPresenter =
      MonthlyScreenPresenter();
}

class PlanningPageController {
  final DailyScreenController dailyScreenController = DailyScreenController();
  final MonthlyScreenController monthlyScreenController =
      MonthlyScreenController();
}
