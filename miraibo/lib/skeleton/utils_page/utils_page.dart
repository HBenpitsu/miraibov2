import 'package:miraibo/dto/general.dart';
import 'package:miraibo/skeleton/utils_page/currency_integration_window.dart';
import 'package:miraibo/skeleton/utils_page/category_integration_window.dart';

// <interface>
abstract interface class UtilsPage {
  /// Utils page have two sections: category section and currency section.
  /// Each section is exists to edit categories and currencies.

  // <navigators>
  CurrencyIntegrationWindow openCurrencyIntegrationWindow(int replaceeId);
  CategoryIntegrationWindow openCategoryIntegrationWindow(int replaceeId);
  // </navigators>

  // <presenters>
  /// categorySection is updated upon category change. So, it is a stream.
  Stream<CategorySection> categorySection();

  /// currencySection is updated upon currency change. So, it is a stream.
  Stream<CurrencySection> currencySection();
  // </presenters>

  // <controllers>
  /// In category section, category can be edited
  Future<void> editCategory(int categoryId, String categoryName);

  /// In category section, category can be added
  Future<void> newCategory(String categoryName);

  /// In currency section, currency can be edited
  Future<void> editCurrency(
      int currencyId, String currencyName, double currencyRatio);

  /// In currency section, currency can be added
  Future<void> newCurrency(String currencyName, double currencyRatio);

  /// In currency section, default currency can be set
  Future<void> setDefaultCurrency(int currencyId);
  // </controllers>
}

// </interface>

// <view model>
class CategorySection {
  /// List of category id and category name
  final List<Category> categories;
  const CategorySection(this.categories);
}

class CurrencySection {
  /// List of currency id, currency name, and currency ratio
  final List<CurrencyInfo> currencies;
  final int defaultCurrencyId;
  const CurrencySection(this.currencies, this.defaultCurrencyId);
}
// </view model>
