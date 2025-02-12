import 'package:miraibo/skeleton/data_page/data_page.dart';
import 'package:miraibo/skeleton/main_page/main_page.dart';
import 'package:miraibo/skeleton/planning_page/planning_page.dart';
import 'package:miraibo/skeleton/utils_page/utils_page.dart';

// <interface>
abstract interface class Root {
  /// root consists of four pages: planning page, main page, data page, and utils page.

  //<navigators>
  PlanningPage get planningPage;
  MainPage get mainPage;
  DataPage get dataPage;
  UtilsPage get utilsPage;
  //</navigators>
}
// </interface>
