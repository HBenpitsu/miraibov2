import 'package:miraibo/dto/general.dart';

sealed class Schedule {
  const Schedule();
}

class OneshotSchedule extends Schedule {
  final Date date;

  const OneshotSchedule({required this.date});
}

class IntervalSchedule extends Schedule {
  final Date originDate;
  final OpenPeriod period;
  final int interval; // interval

  const IntervalSchedule(
      {required this.originDate, required this.period, required this.interval});
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
}

class MonthlySchedule extends Schedule {
  final OpenPeriod period;
  final int offset; // offset

  const MonthlySchedule({required this.period, required this.offset});
}

class AnnualSchedule extends Schedule {
  final Date originDate;
  final OpenPeriod period;

  const AnnualSchedule({required this.originDate, required this.period});
}
