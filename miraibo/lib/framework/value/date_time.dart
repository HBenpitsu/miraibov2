/*
What is written here:
  - Period
  - RelativeDate
  - Weekday enum
  - DateTimeSequence
*/

// <period>
class Period {
  final DateTime start;
  final DateTime end;

  // <constructors>
  const Period(
    this.start,
    this.end,
  );

  Period.from(this.start, Duration duration) : end = start.add(duration);
  Period.until(this.end, Duration duration) : start = end.subtract(duration);
  // </constructors>

  // <values>
  Duration get duration => end.difference(start);
  bool get valid => end.isAfter(start) || end.isAtSameMomentAs(start);
  bool get empty => end.isAtSameMomentAs(start);
  // </values>

  // <operations>
  Period sharedWith(Period period) {
    var start = this.start.isAfter(period.start) ? this.start : period.start;
    var end = this.end.isBefore(period.end) ? this.end : period.end;
    return Period(start, end);
  }

  Period from(DateTime date) {
    var start = date.isAfter(this.start) ? date : this.start;
    return Period(start, end);
  }

  Period until(DateTime date) {
    var end = date.isBefore(this.end) ? date : this.end;
    return Period(start, end);
  }
  // </operations>

  // <comparisons>
  bool containsDate(DateTime date) {
    var gte = date.isAfter(start) || date.isAtSameMomentAs(start);
    var lte = date.isBefore(end) || date.isAtSameMomentAs(end);
    return gte && lte;
  }

  bool containsPeriod(Period period) {
    var gte = end.isAfter(period.end) || end.isAtSameMomentAs(period.end);
    var lte =
        start.isBefore(period.start) || start.isAtSameMomentAs(period.start);
    return gte && lte;
  }

  bool fitsIn(Period period) {
    return period.containsPeriod(this);
  }

  @override
  bool operator ==(Object other) {
    return other is Period &&
        start.isAtSameMomentAs(other.start) &&
        end.isAtSameMomentAs(other.end);
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
  // </comparisons>
}
// </period>

// <provider>
abstract final class RelativeDate {
  static DateTime today() {
    var date = DateTime.now();
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime tomorrow() {
    return today().add(const Duration(days: 1));
  }

  static DateTime yesterday() {
    return today().subtract(const Duration(days: 1));
  }
}
// </provider>

// <weekday>
enum Weekday {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday;

  int get number => index + 1;
  static Weekday fromInt(int number) => Weekday.values[number - 1];
}
// </weekday>

// <sequence>
class DateTimeSequence extends Iterable<DateTime> {
  late Iterable<DateTime> _innerIterable;

  @override
  Iterator<DateTime> get iterator => _innerIterable.iterator;

  // <constructors>
  DateTimeSequence.daily(Period period) {
    _innerIterable = Iterable<DateTime>.generate(
      period.duration.inDays + 1,
      (index) => period.start.add(Duration(days: index)),
    );
  }

  DateTimeSequence.withInterval(
      Period period, DateTime origin, Duration interval) {
    var current = period.start;

    // Adjusting the current time for the sequence to contain the scheduled time.
    var desiredOffset = origin.millisecondsSinceEpoch % interval.inMilliseconds;
    var currentOffset =
        period.start.millisecondsSinceEpoch % interval.inMilliseconds;
    current = DateTime.fromMillisecondsSinceEpoch(
        current.millisecondsSinceEpoch -
            currentOffset +
            desiredOffset -
            interval.inMilliseconds);
    // now, current is surely before the scheduled time.
    // and ajusted.

    // includes `period.start`
    while (current.isBefore(period.start)) {
      current = current.add(interval);
    }

    _innerIterable = (() sync* {
      while (!current.isAfter(period.end)) {
        yield current;
        current = current.add(interval);
      }
    })();
  }

  DateTimeSequence.monthlyHeadOrigin(Period period, Duration offset) {
    var first = DateTime(period.start.year, period.start.month, 1);
    first = first.add(offset);

    // includes `period.start`
    while (first.isBefore(period.start)) {
      first = DateTime(first.year, first.month + 1, 1);
      first = first.add(offset);
    }

    _innerIterable = (() sync* {
      var current = first;
      while (!current.isAfter(period.end)) {
        yield current;
        current = DateTime(current.year, current.month + 1, 1);
        current = current.add(offset);
      }
    })();
  }

  DateTimeSequence.monthlyTailOrigin(Period period, Duration offset) {
    var current = DateTime(period.start.year, period.start.month + 1, 0);
    current = current.subtract(offset);

    // includes `period.start`
    while (current.isBefore(period.start)) {
      var oldMonth = current.month; // to avoid infinite loop
      current = DateTime(current.year, current.month + 2, 0);
      current = current.subtract(offset);
      if (oldMonth == current.month) {
        current = current.add(const Duration(days: 31));
      }
    }

    _innerIterable = (() sync* {
      while (!current.isAfter(period.end)) {
        yield current;
        var oldMonth = current.month; // to avoid infinite loop
        current = DateTime(current.year, current.month + 2, 0);
        current = current.subtract(offset);
        if (oldMonth == current.month) {
          current = current.add(const Duration(days: 31));
        }
      }
    })();
  }

  DateTimeSequence.weekly(Period period, List<Weekday> weekdays) {
    _innerIterable = (() sync* {
      var current = period.start;
      while (!current.isAfter(period.end)) {
        if (weekdays.contains(Weekday.values[current.weekday])) {
          yield current;
        }
        current = current.add(const Duration(days: 1));
      }
    })();
  }

  DateTimeSequence.annually(Period period, DateTime origin) {
    var current = DateTime(period.start.year, origin.month, origin.day);
    if (current.isBefore(period.start)) {
      current = DateTime(period.start.year + 1, origin.month, origin.day);
    }
    _innerIterable = (() sync* {
      while (!current.isAfter(period.end)) {
        yield current;
        current = DateTime(current.year + 1, current.month, current.day);
      }
    })();
  }
  // </constructors>
}
// </sequence>