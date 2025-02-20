import 'package:miraibo/dto/general.dart';

sealed class Schedule {
  const Schedule();
}

class OneshotSchedule extends Schedule {
  final Date date;

  const OneshotSchedule({required this.date});

  OneshotSchedule copyWith({Date? date}) {
    return OneshotSchedule(date: date ?? this.date);
  }
}

class IntervalSchedule extends Schedule {
  final Date originDate;
  final OpenPeriod period;
  final int interval; // interval

  const IntervalSchedule(
      {required this.originDate, required this.period, required this.interval});

  IntervalSchedule copyWith(
      {Date? originDate, OpenPeriod? period, int? interval}) {
    return IntervalSchedule(
        originDate: originDate ?? this.originDate,
        period: period ?? this.period,
        interval: interval ?? this.interval);
  }
}

/// watch out: at least one of the weekdays should be true.
/// Otherwise, it can not be shown anywhere.
class WeeklySchedule extends Schedule {
  final OpenPeriod period;
  final bool sunday; // weekdays
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

  WeeklySchedule copyWith(
      {OpenPeriod? period,
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
}

class MonthlySchedule extends Schedule {
  final OpenPeriod period;
  final int offset; // offset

  const MonthlySchedule({required this.period, required this.offset});

  MonthlySchedule copyWith({OpenPeriod? period, int? offset}) {
    return MonthlySchedule(
        period: period ?? this.period, offset: offset ?? this.offset);
  }
}

class AnnualSchedule extends Schedule {
  final Date originDate;
  final OpenPeriod period;

  const AnnualSchedule({required this.originDate, required this.period});

  AnnualSchedule copyWith({Date? originDate, OpenPeriod? period}) {
    return AnnualSchedule(
        originDate: originDate ?? this.originDate,
        period: period ?? this.period);
  }
}
