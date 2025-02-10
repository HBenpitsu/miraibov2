import 'package:miraibo/skeleton/data_page/data_page.dart';
import 'package:miraibo/skeleton/main_page/main_page.dart';
import 'package:miraibo/skeleton/planning_page/planning_page.dart';
import 'package:miraibo/skeleton/utils_page/utils_page.dart';

// <interface>
abstract interface class RootPresenter {
  PlanningPagePresenter get planningPagePresenter;
  MainPagePresenter get mainPagePresenter;
  DataPagePresenter get dataPagePresenter;
  UtilsPagePresenter get utilsPagePresenter;
}

abstract interface class RootController {
  PlanningPageController get planningPageController;
  MainPageController get mainPageController;
  DataPageController get dataPageController;
  UtilsPageController get utilsPageController;
}
// </interface>
