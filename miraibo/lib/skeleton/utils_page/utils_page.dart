import 'dart:async';

import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/utils_page/currency_integration_window.dart';
export 'package:miraibo/skeleton/utils_page/currency_integration_window.dart';
import 'package:miraibo/skeleton/utils_page/category_integration_window.dart';
export 'package:miraibo/skeleton/utils_page/category_integration_window.dart';

import 'dart:developer' show log;

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

// <mock>
typedef MockCategoryMap = Map<int, String>;
typedef MockCurrencyMap = Map<int, (String, double)>;

class MockUtilsPage implements UtilsPage {
  late final Stream<MockCategoryMap> categoryStream;
  late final Sink<MockCategoryMap> categorySink;
  late MockCategoryMap categories;
  late final Stream<MockCurrencyMap> currencyStream;
  late final Sink<MockCurrencyMap> currencySink;
  late MockCurrencyMap currencies;
  late int defaultCurrency;

  MockUtilsPage() {
    log('MockUtilsPage is constructed');
    categories = {for (int i = 0; i < 20; i++) i: 'category $i'};

    currencies = {for (int i = 0; i < 5; i++) i: ('currency $i', i.toDouble())};

    defaultCurrency = 0;

    // <initialize stream>
    final categoryController = StreamController<MockCategoryMap>.broadcast();
    categoryStream = categoryController.stream;
    categorySink = categoryController.sink;
    final currencyController = StreamController<MockCurrencyMap>.broadcast();
    currencyStream = currencyController.stream;
    currencySink = currencyController.sink;
    // </initialize stream>
  }

  @override
  CategorySection categorySection() {
    log('categorySection is called');
    final returnStreamController = StreamController<List<Category>>();
    returnStreamController.add(categories.entries
        .map((entry) => Category(id: entry.key, name: entry.value))
        .toList());
    returnStreamController.addStream(categoryStream.map((data) => data.entries
        .map((entry) => Category(id: entry.key, name: entry.value))
        .toList()));
    return returnStreamController.stream;
  }

  @override
  CurrencySection currencySection() {
    log('currencySection is called');
    final returnStreamController = StreamController<List<CurrencyInstance>>();
    returnStreamController.add(currencies.entries
        .map((entry) => CurrencyInstance(
            id: entry.key,
            symbol: entry.value.$1,
            ratio: entry.value.$2,
            isDefault: defaultCurrency == entry.key))
        .toList());
    returnStreamController.addStream(currencyStream.map((data) => data.entries
        .map((entry) => CurrencyInstance(
            id: entry.key,
            symbol: entry.value.$1,
            ratio: entry.value.$2,
            isDefault: defaultCurrency == entry.key))
        .toList()));
    return returnStreamController.stream;
  }

  @override
  Future<void> editCategory(int categoryId, String categoryName) async {
    log('editCategory is called with categoryId: $categoryId, categoryName: $categoryName');
    categories[categoryId] = categoryName;
    categorySink.add(categories);
  }

  @override
  Future<void> newCategory(String categoryName) async {
    log('newCategory is called with categoryName: $categoryName');
    categories[categories.length] = categoryName;
    categorySink.add(categories);
  }

  @override
  Future<void> editCurrency(
      int currencyId, String currencyName, double currencyRatio) async {
    log('editCurrency is called with currencyId: $currencyId, currencyName: $currencyName, currencyRatio: $currencyRatio');
    currencies[currencyId] = (currencyName, currencyRatio);
    currencySink.add(currencies);
  }

  @override
  Future<void> newCurrency(String currencyName, double currencyRatio) async {
    log('newCurrency is called with currencyName: $currencyName, currencyRatio: $currencyRatio');
    currencies[currencies.length] = (currencyName, currencyRatio);
    currencySink.add(currencies);
  }

  @override
  Future<void> setDefaultCurrency(int currencyId) async {
    log('setDefaultCurrency is called with currencyId: $currencyId');
    defaultCurrency = currencyId;
    currencySink.add(currencies);
  }

  @override
  CurrencyIntegrationWindow openCurrencyIntegrationWindow(int replaceeId) {
    log('openCurrencyIntegrationWindow is called with replaceeId: $replaceeId');
    return MockCurrencyIntegrationWindow(replaceeId, currencySink, currencies);
  }

  @override
  CategoryIntegrationWindow openCategoryIntegrationWindow(int replaceeId) {
    log('openCategoryIntegrationWindow is called with replaceeId: $replaceeId');
    return MockCategoryIntegrationWindow(replaceeId, categorySink, categories);
  }

  @override
  void dispose() {
    log('UtilsPage is disposed');
    categorySink.close();
    currencySink.close();
  }
}
// </mock>
