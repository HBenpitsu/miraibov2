import 'package:miraibo/dto/dto.dart';

/// {@template createCurrency}
/// return the id of the created currency
/// {@endtemplate}
Future<int> createCurrency(String name, double ratio) {
  throw UnimplementedError();
}

Future<void> editCurrency(int id, String name, double ratio) {
  throw UnimplementedError();
}

Future<void> integrateCurrency(int replaceeId, int replacerId) {
  throw UnimplementedError();
}

/// {@template setCurrencyAsDefault}
/// default currency set by this function can be fetched by [fetchDefaultCurrency]
/// {@endtemplate}
Future<void> setCurrencyAsDefault(int id) {
  throw UnimplementedError();
}

/// {@template fetchAllCurrencies}
/// returns the list of all currencies (list of pairs of name and id of currency)
/// {@endtemplate}
Future<List<Currency>> fetchAllCurrencies() async {
  throw UnimplementedError();
}

/// {@template fetchDefaultCurrency}
/// returns the default currency (list of pairs of name and id of currency)
/// {@endtemplate}
Future<Currency> fetchDefaultCurrency() async {
  throw UnimplementedError();
}
