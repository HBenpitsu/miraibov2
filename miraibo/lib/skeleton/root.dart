import 'package:miraibo/skeleton/data_page/data_page.dart';
export 'package:miraibo/skeleton/data_page/data_page.dart';
import 'package:miraibo/skeleton/main_page/main_page.dart';
export 'package:miraibo/skeleton/main_page/main_page.dart';
import 'package:miraibo/skeleton/planning_page/planning_page.dart';
export 'package:miraibo/skeleton/planning_page/planning_page.dart';
import 'package:miraibo/skeleton/utils_page/utils_page.dart';
export 'package:miraibo/skeleton/utils_page/utils_page.dart';

import 'dart:developer' show log;

// <interface>
/// root consists of four pages: planning page, main page, data page, and utils page.
abstract interface class Root {
  //<navigators>
  /// a tab of the root.
  PlanningPage get planningPage;

  /// a tab of the root.
  MainPage get mainPage;

  /// a tab of the root.
  DataPage get dataPage;

  /// a tab of the root.
  UtilsPage get utilsPage;

  /// should be called when this skeleton is no longer needed.
  void dispose();
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

  @override
  void dispose() {
    planningPage.dispose();
    mainPage.dispose();
    dataPage.dispose();
    utilsPage.dispose();
    log('MockRoot disposed');
  }
}
// </mock>