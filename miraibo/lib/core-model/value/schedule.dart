import 'package:miraibo/core-model/value/date.dart';
import 'package:miraibo/core-model/value/period.dart';

sealed class Schedule {
  const Schedule();

  Iterable<Date> getScheduledDates(Period period);
  bool isScheduled(Date date);
}

class OneshotSchedule extends Schedule {
  final Date date;

  const OneshotSchedule({required this.date});

  OneshotSchedule copyWith({Date? date}) {
    return OneshotSchedule(date: date ?? this.date);
  }

  @override
  bool isScheduled(Date date) {
    return this.date == date;
  }

  @override
  Iterable<Date> getScheduledDates(Period period) {
    if (period.contains(date)) {
      return [date];
    } else {
      return [];
    }
  }

  @override
  String toString() => 'oneshot($date)';
}

class IntervalSchedule extends Schedule {
  final Date originDate;
  final Period period;
  final int interval;

  const IntervalSchedule(
      {required this.originDate, required this.period, required this.interval});

  IntervalSchedule copyWith({Date? originDate, Period? period, int? interval}) {
    return IntervalSchedule(
        originDate: originDate ?? this.originDate,
        period: period ?? this.period,
        interval: interval ?? this.interval);
  }

  @override
  Iterable<Date> getScheduledDates(Period period) sync* {
    final periodIntersection = period.intersection(this.period);
    if (periodIntersection == null) return;
    var current = originDate;
    while (periodIntersection.isStarted(current)) {
      current = current.withDelta(days: -interval);
    }
    while (!periodIntersection.isStarted(current)) {
      current = current.withDelta(days: interval);
    }
    while (!periodIntersection.isOver(current)) {
      yield current;
      current = current.withDelta(days: interval);
    }
  }

  @override
  bool isScheduled(Date date) {
    if (!period.contains(date)) return false;
    return (originDate - date).inDays % interval == 0;
  }

  @override
  String toString() => 'interval($originDate, $period, $interval days)';
}

class WeeklySchedule extends Schedule {
  final Period period;
  final bool sunday;
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;

  const WeeklySchedule(
      {required this.period,
      required this.sunday,
      required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday});
  factory WeeklySchedule.fromList(
      {required Period period, required List<Weekday> weekdays}) {
    return WeeklySchedule(
      period: period,
      sunday: weekdays.contains(Weekday.sunday),
      monday: weekdays.contains(Weekday.monday),
      tuesday: weekdays.contains(Weekday.tuesday),
      wednesday: weekdays.contains(Weekday.wednesday),
      thursday: weekdays.contains(Weekday.thursday),
      friday: weekdays.contains(Weekday.friday),
      saturday: weekdays.contains(Weekday.saturday),
    );
  }

  Iterable<Weekday> get weekdays => Weekday.values.where(_isWeekdayScheduled);

  WeeklySchedule copyWith(
      {Period? period,
      bool? sunday,
      bool? monday,
      bool? tuesday,
      bool? wednesday,
      bool? thursday,
      bool? friday,
      bool? saturday}) {
    return WeeklySchedule(
        period: period ?? this.period,
        sunday: sunday ?? this.sunday,
        monday: monday ?? this.monday,
        tuesday: tuesday ?? this.tuesday,
        wednesday: wednesday ?? this.wednesday,
        thursday: thursday ?? this.thursday,
        friday: friday ?? this.friday,
        saturday: saturday ?? this.saturday);
  }

  bool _isWeekdayScheduled(Weekday weekday) {
    switch (weekday) {
      case Weekday.sunday:
        return sunday;
      case Weekday.monday:
        return monday;
      case Weekday.tuesday:
        return tuesday;
      case Weekday.wednesday:
        return wednesday;
      case Weekday.thursday:
        return thursday;
      case Weekday.friday:
        return friday;
      case Weekday.saturday:
        return saturday;
    }
  }

  @override
  Iterable<Date> getScheduledDates(Period period) sync* {
    final periodIntersection = period.intersection(this.period);
    if (periodIntersection == null) return;
    for (final date in period.dates()) {
      if (_isWeekdayScheduled(date.weekday)) {
        yield date;
      }
    }
  }

  @override
  bool isScheduled(Date date) {
    if (!period.contains(date)) return false;
    return _isWeekdayScheduled(date.weekday);
  }

  @override
  String toString() {
    final weekdays = Weekday.values.where(_isWeekdayScheduled);
    return 'weekly($period, $weekdays)';
  }
}

class MonthlySchedule extends Schedule {
  final Period period;
  final int offset;

  const MonthlySchedule({required this.period, required this.offset});

  MonthlySchedule copyWith({Period? period, int? offset}) {
    return MonthlySchedule(
        period: period ?? this.period, offset: offset ?? this.offset);
  }

  @override
  Iterable<Date> getScheduledDates(Period period) sync* {
    final periodIntersection = period.intersection(this.period);
    if (periodIntersection == null) return;
    var axis = periodIntersection.begins.copyWith(day: 1);
    while (!periodIntersection.isStarted(axis.withDelta(days: offset))) {
      axis = axis.withDelta(months: 1);
    }
    while (!periodIntersection.isOver(axis.withDelta(days: offset))) {
      yield axis.withDelta(days: offset);
      axis = axis.withDelta(months: 1);
    }
  }

  @override
  bool isScheduled(Date date) {
    if (!period.contains(date)) return false;
    return date.withDelta(days: -offset).day == 1;
  }

  @override
  String toString() => 'monthly($period, $offset days)';
}

class AnnualSchedule extends Schedule {
  final Date originDate;
  final Period period;

  const AnnualSchedule({required this.originDate, required this.period});

  AnnualSchedule copyWith({Date? originDate, Period? period}) {
    return AnnualSchedule(
        originDate: originDate ?? this.originDate,
        period: period ?? this.period);
  }

  @override
  Iterable<Date> getScheduledDates(Period period) sync* {
    final periodIntersection = period.intersection(this.period);
    if (periodIntersection == null) return;
    var current = originDate;
    while (periodIntersection.isStarted(current)) {
      current = current.withDelta(years: -1);
    }
    while (!periodIntersection.isStarted(current)) {
      current = current.withDelta(years: 1);
    }
    while (!periodIntersection.isOver(current)) {
      yield current;
      current = current.withDelta(years: 1);
    }
  }

  @override
  bool isScheduled(Date date) {
    if (!period.contains(date)) return false;
    return originDate.month == date.month && originDate.day == date.day;
  }

  @override
  String toString() => 'annual($originDate, $period)';
}
