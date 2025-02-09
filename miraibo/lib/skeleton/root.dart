import 'package:miraibo/skeleton/data_page/data_page.dart';
import 'package:miraibo/skeleton/main_page/main_page.dart';
import 'package:miraibo/skeleton/planning_page/planning_page.dart';
import 'package:miraibo/skeleton/utils_page/utils_page.dart';

class RootPresenter {
  final DataPagePresenter dataPagePresenter = DataPagePresenter();
  final MainPagePresenter mainPagePresenter = MainPagePresenter();
  final PlanningPagePresenter planningPagePresenter = PlanningPagePresenter();
  final UtilsPagePresenter utilsPagePresenter = UtilsPagePresenter();
}

class RootController {
  final DataPageController dataPageController = DataPageController();
  final MainPageController mainPageController = MainPageController();
  final PlanningPageController planningPageController =
      PlanningPageController();
  final UtilsPageController utilsPageController = UtilsPageController();
}
