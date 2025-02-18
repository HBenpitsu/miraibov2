import 'package:flutter/material.dart';

class Date {
  final int year;
  final int month;
  final int day;

  const Date(this.year, this.month, this.day);

  DateTime asDateTime() {
    return DateTime(year, month, day);
  }
}

extension CutOffTime on DateTime {
  Date cutOffTime() {
    return Date(year, month, day);
  }
}

/// Open period means that the period whose beginning and ending can be null.
/// If the beginning is null, it means that the period is started from very beginning of time, virtually infinite past.
/// If the ending is null, it means that the period is endless.
class OpenPeriod {
  final Date? begins;
  final Date? ends;

  const OpenPeriod({this.begins, this.ends});
}

/// Closed period means that the period whose beginning and ending are specified for sure.
class ClosedPeriod {
  final Date begins;
  final Date ends;

  const ClosedPeriod({required this.begins, required this.ends});

  DateTimeRange asDateTimeRange() {
    return DateTimeRange(start: begins.asDateTime(), end: ends.asDateTime());
  }
}

extension CutOffTimeOfRange on DateTimeRange {
  ClosedPeriod cutOffTime() {
    return ClosedPeriod(begins: start.cutOffTime(), ends: end.cutOffTime());
  }

  OpenPeriod cutOffTimeAsOpen() {
    return OpenPeriod(begins: start.cutOffTime(), ends: end.cutOffTime());
  }
}

class Price {
  final int amount;
  final String symbol;

  const Price({required this.amount, required this.symbol});
}

class Currency {
  final int id;
  final String symbol;

  const Currency({required this.id, required this.symbol});
}

class Category {
  final int id;
  final String name;

  const Category({required this.id, required this.name});
}
