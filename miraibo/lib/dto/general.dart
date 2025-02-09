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

class Price {
  final int amount;
  final int currencyId;

  const Price(this.amount, this.currencyId);
}
