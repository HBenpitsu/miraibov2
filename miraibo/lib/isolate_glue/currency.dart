import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/repository/impl.dart' as repository;

// <createCurrency>
Future<int> __createCurrency((String, double) param) {
  repository.bind();
  return usecase.createCurrency(param.$1, param.$2);
}

/// {@macro createCurrency}
Future<int> createCurrency(String name, double ratio) {
  return usecase.createCurrency(name, ratio);
  // return compute(__createCurrency, (name, ratio));
}
// </createCurrency>

// <editCurrency>
Future<void> __editCurrency((int, String, double) param) {
  repository.bind();
  return usecase.editCurrency(param.$1, param.$2, param.$3);
}

Future<void> editCurrency(int id, String name, double ratio) {
  return usecase.editCurrency(id, name, ratio);
  // return compute(__editCurrency, (id, name, ratio));
}
// </editCurrency>

// <integrateCurrency>
Future<void> __integrateCurrency((int, int) param) {
  repository.bind();
  return usecase.integrateCurrency(param.$1, param.$2);
}

Future<void> integrateCurrency(int replaceeId, int replacerId) {
  return usecase.integrateCurrency(replaceeId, replacerId);
  // return compute(__integrateCurrency, (replaceeId, replacerId));
}
// </integrateCurrency>

// <setCurrencyAsDefault>

Future<void> __setCurrencyAsDefault(int id) {
  repository.bind();
  return usecase.setCurrencyAsDefault(id);
}

/// {@macro setCurrencyAsDefault}
Future<void> setCurrencyAsDefault(int id) {
  return usecase.setCurrencyAsDefault(id);
  // return compute(__setCurrencyAsDefault, id);
}
// </setCurrencyAsDefault>

// <fetchAllCurrencies>
Future<List<Currency>> __fetchAllCurrencies(() param) {
  repository.bind();
  return usecase.fetchAllCurrencies();
}

/// {@macro fetchAllCurrencies}
Future<List<Currency>> fetchAllCurrencies() {
  return usecase.fetchAllCurrencies();
  // return compute(__fetchAllCurrencies, ());
}
// </fetchAllCurrencies>

// <fetchDefaultCurrency>
Future<Currency> __fetchDefaultCurrency(() param) {
  repository.bind();
  return usecase.fetchDefaultCurrency();
}

/// {@macro fetchDefaultCurrency}
Future<Currency> fetchDefaultCurrency() {
  return usecase.fetchDefaultCurrency();
  // return compute(__fetchDefaultCurrency, ());
}
// </fetchDefaultCurrency>
