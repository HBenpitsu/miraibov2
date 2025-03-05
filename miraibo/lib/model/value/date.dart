enum Weekday {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}

// wrapper of DateTime
class Date {
  final int year;
  final int month;
  final int day;

  static const int earlisestYear = 1000;
  static const int latestYear = 4000;

  static final Date earliest = Date(earlisestYear, 1, 1);
  static final Date latest = Date(latestYear, 12, 31);

  Date(this.year, this.month, this.day);

  Date.clamp(int year, int month, int day)
      : year = year.clamp(earlisestYear, latestYear),
        month = month.clamp(1, 12),
        day = day.clamp(1, 31);

  Date.fromJson(Map<String, dynamic> json)
      : year = json['year'] as int,
        month = json['month'] as int,
        day = json['day'] as int;

  Map<String, dynamic> toJson() => {
        'year': year,
        'month': month,
        'day': day,
      };

  Date.fromDateTime(DateTime dateTime)
      : year = dateTime.year,
        month = dateTime.month,
        day = dateTime.day;

  DateTime toDateTime() => DateTime(year, month, day);

  static Date earlier(Date a, Date b) {
    return a < b ? a : b;
  }

  static Date later(Date a, Date b) {
    return a > b ? a : b;
  }

  factory Date.today() {
    final now = DateTime.now();
    return Date(now.year, now.month, now.day);
  }

  Weekday get weekday {
    return Weekday.values[DateTime(year, month, day).weekday - 1];
  }

  Date withDelta({int days = 0, int months = 0, int years = 0}) {
    final date = DateTime(year + years, month + months, day + days);
    return Date(date.year, date.month, date.day);
  }

  Date copyWith({int? year, int? month, int? day}) {
    return Date(year ?? this.year, month ?? this.month, day ?? this.day);
  }

  bool operator <=(Date other) {
    if (year < other.year) return true;
    if (year > other.year) return false;
    if (month < other.month) return true;
    if (month > other.month) return false;
    return day <= other.day;
  }

  bool operator >=(Date other) {
    return other <= this;
  }

  bool operator <(Date other) {
    if (year < other.year) return true;
    if (year > other.year) return false;
    if (month < other.month) return true;
    if (month > other.month) return false;
    return day < other.day;
  }

  bool operator >(Date other) {
    return other < this;
  }

  Duration operator -(Date other) {
    return toDateTime().difference(other.toDateTime());
  }

  @override
  bool operator ==(Object other) {
    if (other is! Date) {
      return false;
    }
    return year == other.year && month == other.month && day == other.day;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;

  @override
  String toString() => '$year-$month-$day';
}
