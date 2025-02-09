/// Contains the data to 'show' currency.
class Currency {
  final int id;
  final String name;
  // there is no need to have ratio of the currency because the price conversion should not be done in the usecase or upper layer.

  const Currency(this.id, this.name);
}

/// Contains the data to 'manage' currency.
class CurrencyInfo {
  final int id;
  final String name;
  final double ratio;

  const CurrencyInfo(this.id, this.name, this.ratio);
}
