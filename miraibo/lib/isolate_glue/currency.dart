import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';

// <createCurrency>
Future<int> __createCurrency((String, double) param) {
  return usecase.createCurrency(param.$1, param.$2);
}

/// {@macro createCurrency}
Future<int> createCurrency(String name, double ratio) {
  return compute(__createCurrency, (name, ratio));
}
// </createCurrency>

// <editCurrency>
Future<void> __editCurrency((int, String, double) param) {
  return usecase.editCurrency(param.$1, param.$2, param.$3);
}

Future<void> editCurrency(int id, String name, double ratio) {
  return compute(__editCurrency, (id, name, ratio));
}
// </editCurrency>

// <integrateCurrency>
Future<void> __integrateCurrency((int, int) param) {
  return usecase.integrateCurrency(param.$1, param.$2);
}

Future<void> integrateCurrency(int replaceeId, int replacerId) {
  return compute(__integrateCurrency, (replaceeId, replacerId));
}
// </integrateCurrency>

// <setCurrencyAsDefault>
/// {@macro setCurrencyAsDefault}
Future<void> setCurrencyAsDefault(int id) {
  return compute(usecase.setCurrencyAsDefault, id);
}
// </setCurrencyAsDefault>

// <fetchAllCurrencies>
Future<List<Currency>> __fetchAllCurrencies(() param) {
  return usecase.fetchAllCurrencies();
}

/// {@macro fetchAllCurrencies}
Future<List<Currency>> fetchAllCurrencies() {
  return compute(__fetchAllCurrencies, ());
}
// </fetchAllCurrencies>

// <fetchDefaultCurrency>
Future<Currency> __fetchDefaultCurrency(() param) {
  return usecase.fetchDefaultCurrency();
}
// </fetchDefaultCurrency>

// <fetchDefaultCurrency>
/// {@macro fetchDefaultCurrency}
Future<Currency> fetchDefaultCurrency() {
  return compute(__fetchDefaultCurrency, ());
}
// </fetchDefaultCurrency>
