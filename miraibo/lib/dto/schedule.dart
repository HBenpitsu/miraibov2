import 'package:miraibo/dto/general.dart';

sealed class Schedule {
  const Schedule();
}

class OneshotSchedule extends Schedule {
  final Date date;

  const OneshotSchedule(this.date);
}

class IntervalSchedule extends Schedule {
  final Date originDate;
  final OpenPeriod period;
  final int interval; // interval

  const IntervalSchedule(this.originDate, this.period, this.interval);
}

class WeeklySchedule extends Schedule {
  final OpenPeriod period;
  final bool sunday; // weekdays
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;

  const WeeklySchedule(this.period, this.sunday, this.monday, this.tuesday,
      this.wednesday, this.thursday, this.friday, this.saturday);
}

class MonthlySchedule extends Schedule {
  final OpenPeriod period;
  final int offset; // offset

  const MonthlySchedule(this.period, this.offset);
}

class AnnualSchedule extends Schedule {
  final Date originDate;
  final OpenPeriod period;

  const AnnualSchedule(
    this.originDate,
    this.period,
  );
}
