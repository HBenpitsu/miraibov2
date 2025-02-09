/// return the id of the created currency
Future<int> createCurrency(String name, double ratio) {
  throw UnimplementedError();
}

Future<void> editCurrency(int id, String name, double ratio) {
  throw UnimplementedError();
}

Future<void> integrateCurrency(int replaceeId, int replacerId) {
  throw UnimplementedError();
}

/// default currency set by this function can be fetched by [fetchDefaultCurrency]
Future<void> setCurrencyAsDefault(int id) {
  throw UnimplementedError();
}

// for now, [fetchDefaultCurrency] is only needed by ticket_managing, however,
// when currency_managing needs it, it should be moved to the right place.
