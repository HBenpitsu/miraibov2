import 'dart:async';

import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/utils_page/currency_integration_window.dart';
export 'package:miraibo/skeleton/utils_page/currency_integration_window.dart';
import 'package:miraibo/skeleton/utils_page/category_integration_window.dart';
export 'package:miraibo/skeleton/utils_page/category_integration_window.dart';

// <interface>
/// Utils page have two sections: category section and currency section.
/// Each section is exists to edit categories and currencies.
abstract interface class UtilsPage {
  // <presenters>
  /// It returns a stream of categories.
  /// categorySection is updated upon category change. So, they come from a stream.
  CategorySection categorySection();

  /// It returns a stream of currencies.
  /// currencySection is updated upon currency change. So, they come from a stream.
  CurrencySection currencySection();
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

  // <navigators>
  /// to integrate a currency with another currency, open currency integration window.
  CurrencyIntegrationWindow openCurrencyIntegrationWindow(int replaceeId);

  /// to integrate a category with another category, open category integration window.
  CategoryIntegrationWindow openCategoryIntegrationWindow(int replaceeId);

  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

// </interface>

// <view model>
typedef CategorySection = Stream<List<Category>>;
typedef CurrencySection = Stream<List<CurrencyInstance>>;
// </view model>
