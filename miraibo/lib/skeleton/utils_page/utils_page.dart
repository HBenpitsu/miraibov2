import 'package:miraibo/skeleton/utils_page/category_section.dart';
import 'package:miraibo/skeleton/utils_page/currency_section.dart';
import 'package:miraibo/skeleton/utils_page/modal_window/category_edit_window.dart';
import 'package:miraibo/skeleton/utils_page/modal_window/currency_edit_window.dart';

class UtilsPagePresenter {
  final CategorySectionPresenter categorySectionPresenter =
      CategorySectionPresenter();
  final CurrencySectionPresenter currencySectionPresenter =
      CurrencySectionPresenter();
  final CategoryEditWindowPresenter categoryEditWindowPresenter =
      CategoryEditWindowPresenter();
  final CurrencyEditWindowPresenter currencyEditWindowPresenter =
      CurrencyEditWindowPresenter();
}

class UtilsPageController {
  final CategorySectionController categorySectionController =
      CategorySectionController();
  final CurrencySectionController currencySectionController =
      CurrencySectionController();
  final CategoryEditWindowController categoryEditWindowController =
      CategoryEditWindowController();
  final CurrencyEditWindowController currencyEditWindowController =
      CurrencyEditWindowController();
}
