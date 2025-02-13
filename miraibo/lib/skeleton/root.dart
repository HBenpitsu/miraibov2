import 'package:miraibo/skeleton/data_page/data_page.dart';
import 'package:miraibo/skeleton/main_page/main_page.dart';
import 'package:miraibo/skeleton/planning_page/planning_page.dart';
import 'package:miraibo/skeleton/utils_page/utils_page.dart';

// <interface>
/// root consists of four pages: planning page, main page, data page, and utils page.
abstract interface class Root {
  //<navigators>
  PlanningPage get planningPage;
  MainPage get mainPage;
  DataPage get dataPage;
  UtilsPage get utilsPage;
  //</navigators>
}
// </interface>

// <mock>
class MockRoot implements Root {
  @override
  PlanningPage get planningPage => MockPlanningPage();

  @override
  MainPage get mainPage => MockMainPage();

  @override
  DataPage get dataPage => MockDataPage();

  @override
  UtilsPage get utilsPage => MockUtilsPage();
}
// </mock>