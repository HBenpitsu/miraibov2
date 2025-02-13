import 'dart:async';

import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/utils_page/currency_integration_window.dart';
import 'package:miraibo/skeleton/utils_page/category_integration_window.dart';

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
  // </navigators>

  void dispose();
}

// </interface>

// <view model>
typedef CategorySection = Stream<List<Category>>;
typedef CurrencySection = Stream<List<CurrencyConfig>>;
// </view model>

// <mock>
typedef MockCategoryMap = Map<int, String>;
typedef MockCurrencyMap = Map<int, (String, double)>;

class MockUtilsPage implements UtilsPage {
  final StreamController<MockCategoryMap> _categoryStream = StreamController();
  late MockCategoryMap _categories;
  final StreamController<MockCurrencyMap> _currencyStream = StreamController();
  late MockCurrencyMap _currencies;
  late int _defaultCurrency;

  MockUtilsPage() {
    _categories = {for (int i = 0; i < 20; i++) i: 'category $i'};
    _categoryStream.add(_categories);

    _currencies = {
      for (int i = 0; i < 5; i++) i: ('currency $i', i.toDouble())
    };
    _currencyStream.add(_currencies);

    _defaultCurrency = 0;
  }

  @override
  CategorySection categorySection() {
    return _categoryStream.stream.map((data) => data.entries
        .map((entry) => Category(id: entry.key, name: entry.value))
        .toList());
  }

  @override
  CurrencySection currencySection() {
    return _currencyStream.stream.map((data) => data.entries
        .map((entry) => CurrencyConfig(
            id: entry.key,
            symbol: entry.value.$1,
            ratio: entry.value.$2,
            isDefault: _defaultCurrency == entry.key))
        .toList());
  }

  @override
  Future<void> editCategory(int categoryId, String categoryName) async {
    _categories[categoryId] = categoryName;
    _categoryStream.add(_categories);
  }

  @override
  Future<void> newCategory(String categoryName) async {
    _categories[_categories.length] = categoryName;
    _categoryStream.add(_categories);
  }

  @override
  Future<void> editCurrency(
      int currencyId, String currencyName, double currencyRatio) async {
    _currencies[currencyId] = (currencyName, currencyRatio);
    _currencyStream.add(_currencies);
  }

  @override
  Future<void> newCurrency(String currencyName, double currencyRatio) async {
    _currencies[_currencies.length] = (currencyName, currencyRatio);
    _currencyStream.add(_currencies);
  }

  @override
  Future<void> setDefaultCurrency(int currencyId) async {
    _defaultCurrency = currencyId;
  }

  @override
  CurrencyIntegrationWindow openCurrencyIntegrationWindow(int replaceeId) {
    return MockCurrencyIntegrationWindow(
        replaceeId, _currencyStream.sink, _currencies);
  }

  @override
  CategoryIntegrationWindow openCategoryIntegrationWindow(int replaceeId) {
    return MockCategoryIntegrationWindow(
        replaceeId, _categoryStream.sink, _categories);
  }

  @override
  void dispose() {
    _categoryStream.close();
    _currencyStream.close();
  }
}
// </mock>
