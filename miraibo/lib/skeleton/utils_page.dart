import 'dart:async';

import 'package:miraibo/dto/dto.dart';

// <page>
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
// </page>

// <currency integration window>
// <interface>

/// CurrencyIntegrationWindow opens when the user wants to integrate a currency with another currency.
/// When opening the window, the user should specify the currency to be replaced.
/// The specified currency is stored in [replaceeId].
/// Users can select a currency to replace the specified currency from the options.
/// And then, users dispatch the integration process by tapping the integrate button.
abstract interface class CurrencyIntegrationWindow {
  // <states>
  /// The ID of the currency to be replaced.
  /// This is not changed during the lifecycle of the window.
  int get replaceeId;
  // </states>

  // <presenters>
  Future<Currency> getReplacee();

  /// In integration window, all currencies (except replacee) are shown as replacer options.
  Future<List<Currency>> getOptions();
  // </presenters>

  // <controllers>
  /// integrates a currency whose currency is [replacerId] with the currency of [replaceeId].
  Future<void> integrateCurrency(int replacerId);
  // </controllers>

  // <navigators>

  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </currency integration window>

// <category integration window>
// <interface>

/// CategoryIntegrationWindow opens when the user wants to integrate a category with another category.
/// When opening the window, the user should specify the category to be replaced.
/// The specified category is stored in [replaceeId].
/// Users can select a category to replace the specified category from the options.
/// And then, users dispatch the integration process by tapping the integrate button.

abstract interface class CategoryIntegrationWindow {
  // <states>
  /// The ID of the currency to be replaced.
  /// This is not changed during the lifecycle of the window.
  int get replaceeId;
  // </states>

  // <presenters>
  /// In integration window, all categories (except replacee) are shown as replacer options.
  Future<Category> getReplacee();
  Future<List<Category>> getOptions();
  // </presenters>

  // <controllers>
  /// integrates a category whose category is [replacerId] with the category of [replaceeId].
  Future<void> integrateCategory(int replacerId);
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </category integration window>
