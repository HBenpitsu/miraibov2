class Date {
  final int year;
  final int month;
  final int day;

  const Date(this.year, this.month, this.day);
}

/// Closed period means that the period whose beginning and ending are specified for sure.
class ClosedPeriod {
  final Date begins;
  final Date ends;

  const ClosedPeriod({required this.begins, required this.ends});
}

/// Open period means that the period whose beginning and ending can be null.
/// If the beginning is null, it means that the period is started from very beginning of time, virtually infinite past.
/// If the ending is null, it means that the period is endless.
class OpenPeriod {
  final Date? begins;
  final Date? ends;

  const OpenPeriod({this.begins, this.ends});
}

/// Contains the data to 'show' price.
class Price {
  final int amount;
  final String symbol;

  const Price({required this.amount, required this.symbol});
}

/// Contains the data to 'manage' price.
class PriceInfo {
  final int amount;
  final int currencyId;
  final String currencySymbol;

  const PriceInfo(
      {required this.amount,
      required this.currencyId,
      required this.currencySymbol});
}

class Currency {
  final int id;
  final String symbol;

  const Currency({required this.id, required this.symbol});
}

class CurrencyInfo {
  final int id;
  final String symbol;
  final double ratio;

  const CurrencyInfo(
      {required this.id, required this.symbol, required this.ratio});
}

class Category {
  final int id;
  final String name;

  const Category({required this.id, required this.name});
}
