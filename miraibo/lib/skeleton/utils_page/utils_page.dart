import 'dart:async';

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
}

// </interface>

// <view model>
typedef CategorySection = List<Category>;

class CurrencySection {
  /// List of currency id, currency name, and currency ratio
  final Stream<List<CurrencyInfo>> currencies;
  final Stream<int> defaultId;
  const CurrencySection({required this.currencies, required this.defaultId});
}
// </view model>

// <mock>
typedef MockCategoryMap = Map<int, String>;
typedef MockCurrencyMap = Map<int, (String, double)>;

class MockUtilsPage implements UtilsPage {
  final StreamController<MockCategoryMap> _categoryStream = StreamController();
  late MockCategoryMap _categories;
  final StreamController<MockCurrencyMap> _currencyStream = StreamController();
  late MockCurrencyMap _currencies;
  final StreamController<int> _defaultCurrencyStream = StreamController();
  late int _defaultCurrency;

  MockUtilsPage() {
    _categories = {for (int i = 0; i < 20; i++) i: 'category $i'};
    _categoryStream.add(_categories);

    _currencies = {
      for (int i = 0; i < 5; i++) i: ('currency $i', i.toDouble())
    };
    _currencyStream.add(_currencies);

    _defaultCurrency = 0;
    _defaultCurrencyStream.add(_defaultCurrency);
  }

  @override
  Stream<CategorySection> categorySection() {
    return _categoryStream.stream.map((data) => data.entries
        .map((entry) => Category(id: entry.key, name: entry.value))
        .toList());
  }

  @override
  CurrencySection currencySection() {
    return CurrencySection(
        currencies: _currencyStream.stream.map((data) => data.entries
            .map((entry) => CurrencyInfo(
                id: entry.key, symbol: entry.value.$1, ratio: entry.value.$2))
            .toList()),
        defaultId: _defaultCurrencyStream.stream);
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
    _defaultCurrencyStream.add(currencyId);
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
}
// </mock>
