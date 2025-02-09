import 'package:miraibo/skeleton/data_page/info_section.dart';
import 'package:miraibo/skeleton/data_page/table_section.dart';

class DataPagePresenter {
  final InfoSectionPresenter infoSectionPresenter = InfoSectionPresenter();
  final TableSectionPresenter tableSectionPresenter = TableSectionPresenter();
}

class DataPageController {
  final InfoSectionController infoSectionController = InfoSectionController();
  final TableSectionController tableSectionController =
      TableSectionController();
}
