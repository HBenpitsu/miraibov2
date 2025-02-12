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

  const ClosedPeriod(this.begins, this.ends);
}

/// Open period means that the period whose beginning and ending can be null.
/// If the beginning is null, it means that the period is started from very beginning of time, virtually infinite past.
/// If the ending is null, it means that the period is endless.
class OpenPeriod {
  final Date? begins;
  final Date? ends;

  const OpenPeriod(this.begins, this.ends);
}

/// Contains the data to 'show' price.
class Price {
  final int amount;
  final String currencyName;

  const Price(this.amount, this.currencyName);
}

/// Contains the data to 'manage' price.
class PriceInfo {
  final int amount;
  final int currencyId;
  final String currencyName;

  const PriceInfo(this.amount, this.currencyId, this.currencyName);
}

class Currency {
  final int id;
  final String symbol;

  const Currency(this.id, this.symbol);
}

class CurrencyInfo {
  final int id;
  final String symbol;
  final double ratio;

  const CurrencyInfo(this.id, this.symbol, this.ratio);
}

class Category {
  final int id;
  final String name;

  const Category(this.id, this.name);
}
