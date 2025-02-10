import 'package:miraibo/skeleton/utils_page/currency_integration_window.dart';
import 'package:miraibo/skeleton/utils_page/category_integration_window.dart';

// <interface>
abstract interface class UtilsPagePresenter {
  CurrencyIntegrationWindowPresenter get currencyIntegrationWindowPresenter;
  CategoryIntegrationWindowPresenter get categoryIntegrationWindowPresenter;
}

abstract interface class UtilsPageController {
  CurrencyIntegrationWindowController get currencyIntegrationWindowController;
  CategoryIntegrationWindowController get categoryIntegrationWindowController;
}
// </interface>