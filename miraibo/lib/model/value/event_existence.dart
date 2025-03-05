import 'package:miraibo/model/repository/primitive.dart';
import 'package:miraibo/model/value/collection/category_collection.dart';
import 'package:miraibo/model/value/date.dart';
import 'package:miraibo/model/value/period.dart';
import 'package:miraibo/shared/enumeration.dart' as enumeration;

class EventExistence {
  static final EstimationSchemeRepository _estimationSchemeRepository =
      EstimationSchemeRepository.instance;
  static final ReceiptLogRepository _receiptLogRepository =
      ReceiptLogRepository.instance;
  static final PlanRepository _planRepository = PlanRepository.instance;
  static final MonitorSchemeRepository _monitorSchemeRepository =
      MonitorSchemeRepository.instance;
  static const _cacheSize = 200;
  static _Cache _cache = _Cache.empty();
  static Future<enumeration.EventExistence> get(Date date) async {
    final cachedValue = EventExistence._cache.get(date);
    if (cachedValue != null) {
      return cachedValue;
    }

    final firstDate = date.withDelta(days: -(_cacheSize ~/ 2));
    final lastDate = firstDate.withDelta(days: _cacheSize - 1);
    final period = Period(begins: firstDate, ends: lastDate);

    _cache = _Cache(
      period: period,
      events: List.filled(_cacheSize, enumeration.EventExistence.none),
    );

    await for (final estimation in _estimationSchemeRepository.get(
        period, CategoryCollection.phantomAll)) {
      _cache.markUpAsImportant(estimation.period.begins);
      _cache.markUpAsImportant(estimation.period.ends);
      for (final date in estimation.period.dates()) {
        _cache.markUpAsTrivial(date);
      }
    }

    await for (final log
        in _receiptLogRepository.get(period, CategoryCollection.phantomAll)) {
      _cache.markUpAsTrivial(log.date);
    }

    await for (final plan
        in _planRepository.get(period, CategoryCollection.phantomAll)) {
      final dates = plan.schedule.getScheduledDates(period);
      if (dates.isEmpty) continue;
      _cache.markUpAsImportant(dates.first);
      Date last = dates.first;
      for (final date in dates) {
        _cache.markUpAsTrivial(date);
        last = date;
      }
      _cache.markUpAsImportant(last);
    }

    await for (final monitorScheme in _monitorSchemeRepository.get(
        period, CategoryCollection.phantomAll)) {
      _cache.markUpAsImportant(monitorScheme.period.begins);
      _cache.markUpAsImportant(monitorScheme.period.ends);
      for (final date in monitorScheme.period.dates()) {
        _cache.markUpAsTrivial(date);
      }
    }

    return _cache.get(date)!;
  }
}

class _Cache {
  late final Period? period;
  late final List<enumeration.EventExistence> events;
  _Cache.empty() {
    // first is more than last, that means "someDate < firstDate || lastDate < someDate" is always true
    period = null;
    events = [];
  }
  _Cache({required this.period, required this.events});

  enumeration.EventExistence? get(Date date) {
    if (period == null || !period!.contains(date)) {
      return null;
    }
    return events[(date - period!.begins).inDays];
  }

  void markUpAsTrivial(Date date) {
    if (period == null || !period!.contains(date)) {
      throw ArgumentError('date must be in period');
    }
    if (events[(date - period!.begins).inDays] ==
        enumeration.EventExistence.none) {
      events[(date - period!.begins).inDays] =
          enumeration.EventExistence.trivial;
    }
  }

  void markUpAsImportant(Date date) {
    if (period == null || !period!.contains(date)) {
      throw ArgumentError('date must be in period');
    }
    events[(date - period!.begins).inDays] =
        enumeration.EventExistence.important;
  }
}
