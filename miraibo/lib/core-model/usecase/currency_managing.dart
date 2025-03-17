import 'package:logger/web.dart';
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/core-model/entity/currency.dart' as model;
import 'package:miraibo/core-model/value/collection/currency_collection.dart'
    as model;

/// {@template createCurrency}
/// return the id of the created currency
/// {@endtemplate}
Future<int> createCurrency(String name, double ratio) async {
  final currency = await model.Currency.create(name, ratio);
  return currency.id;
}

Future<void> editCurrency(int id, String name, double ratio) async {
  final currency = await model.Currency.get(id);
  if (currency == null) {
    throw ArgumentError('Currency with id $id does not exist');
  }
  await currency.update(name, ratio);
}

Future<void> integrateCurrency(int replaceeId, int replacerId) async {
  final replacee = await model.Currency.get(replaceeId);
  final replacer = await model.Currency.get(replacerId);
  if (replacee == null) {
    throw ArgumentError('Currency with id $replaceeId does not exist');
  }
  if (replacer == null) {
    throw ArgumentError('Currency with id $replacerId does not exist');
  }
  await replacee.integrateWith(replacer);
}

/// {@template setCurrencyAsDefault}
/// default currency set by this function can be fetched by [fetchDefaultCurrency]
/// {@endtemplate}
Future<void> setCurrencyAsDefault(int id) async {
  final currency = await model.Currency.get(id);
  if (currency == null) {
    throw ArgumentError('Currency with id $id does not exist');
  }
  model.CurrencyCollection.setDefault(currency);
}

/// {@template fetchAllCurrencies}
/// returns the list of all currencies (list of pairs of name and id of currency)
/// {@endtemplate}
Future<List<Currency>> fetchAllCurrencies() async {
  final currencies = await model.CurrencyCollection.getAll();
  return currencies
      .map((currency) => Currency(id: currency.id, symbol: currency.symbol))
      .toList();
}

Future<List<CurrencyInstance>> fetchAllConfiguableCurrencies() async {
  final currencies = await model.CurrencyCollection.getAll();
  final defaultCurrency = await model.CurrencyCollection.getDefault();
  return currencies
      .map((currency) => CurrencyInstance(
          id: currency.id,
          symbol: currency.symbol,
          ratio: currency.ratio,
          isDefault: currency.id == defaultCurrency.id))
      .toList();
}

/// {@template fetchDefaultCurrency}
/// returns the default currency (list of pairs of name and id of currency)
/// {@endtemplate}
Future<Currency> fetchDefaultCurrency() async {
  final currency = await model.CurrencyCollection.getDefault();
  return Currency(id: currency.id, symbol: currency.symbol);
}
