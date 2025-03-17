import 'package:miraibo/repository/core.dart';
import 'package:miraibo/core-model/value/collection/category_collection.dart';
import 'package:miraibo/core-model/value/date.dart';
import 'package:miraibo/core-model/value/period.dart';
import 'package:miraibo/shared/enumeration.dart';

class EventExistenceCheckingService {
  static final EstimationSchemeRepository _estimationSchemeRepository =
      EstimationSchemeRepository.instance;
  static final ReceiptLogRepository _receiptLogRepository =
      ReceiptLogRepository.instance;
  static final PlanRepository _planRepository = PlanRepository.instance;
  static final MonitorSchemeRepository _monitorSchemeRepository =
      MonitorSchemeRepository.instance;
  static const _cacheSize = 200;

  static EventExistenceCheckingService? _instance;

  EventExistenceCheckingService._();

  factory EventExistenceCheckingService.getInstance() {
    if (_instance == null || _instance!.busy) {
      _instance = EventExistenceCheckingService._();
    }
    return _instance!;
  }

  _Cache _cache = _Cache.empty();
  bool busy = false;
  Future<EventExistence> get(Date date) async {
    final cachedValue = _cache.get(date);
    if (cachedValue != null) {
      return cachedValue;
    }

    busy = true;

    final firstDate = date.withDelta(days: -(_cacheSize ~/ 2));
    final lastDate = firstDate.withDelta(days: _cacheSize - 1);
    final cachingPeriod = Period(begins: firstDate, ends: lastDate);

    _cache = _Cache(
      period: cachingPeriod,
      events: List.filled(_cacheSize, EventExistence.none),
    );

    await for (final estimation in _estimationSchemeRepository.get(
        cachingPeriod, CategoryCollection.phantomAll)) {
      if (cachingPeriod.contains(estimation.period.begins)) {
        _cache.markUpAsImportant(estimation.period.begins);
      }
      if (cachingPeriod.contains(estimation.period.ends)) {
        _cache.markUpAsImportant(estimation.period.ends);
      }
      final intersection = estimation.period.intersection(cachingPeriod);
      if (intersection == null) continue;
      for (final date in intersection.dates()) {
        _cache.markUpAsTrivial(date);
      }
    }

    await for (final log in _receiptLogRepository.get(
        cachingPeriod, CategoryCollection.phantomAll)) {
      _cache.markUpAsTrivial(log.date);
    }

    await for (final plan
        in _planRepository.get(cachingPeriod, CategoryCollection.phantomAll)) {
      final dates = plan.schedule.getScheduledDates(cachingPeriod);
      if (dates.isEmpty) continue;
      for (final date in dates) {
        _cache.markUpAsTrivial(date);
      }
    }

    await for (final monitorScheme in _monitorSchemeRepository.get(
        cachingPeriod, CategoryCollection.phantomAll)) {
      if (cachingPeriod.contains(monitorScheme.period.begins)) {
        _cache.markUpAsImportant(monitorScheme.period.begins);
      }
      if (cachingPeriod.contains(monitorScheme.period.ends)) {
        _cache.markUpAsImportant(monitorScheme.period.ends);
      }
      final intersection = monitorScheme.period.intersection(cachingPeriod);
      if (intersection == null) continue;
      for (final date in intersection.dates()) {
        _cache.markUpAsTrivial(date);
      }
    }

    busy = false;

    return _cache.get(date)!;
  }
}

class _Cache {
  late final Period? period;
  late final List<EventExistence> events;
  _Cache.empty() {
    // first is more than last, that means "someDate < firstDate || lastDate < someDate" is always true
    period = null;
    events = [];
  }
  _Cache({required this.period, required this.events});

  EventExistence? get(Date date) {
    if (period == null || !period!.contains(date)) {
      return null;
    }
    return events[(date - period!.begins).inDays];
  }

  void markUpAsTrivial(Date date) {
    if (period == null || !period!.contains(date)) {
      throw ArgumentError(
          'date must be in period (date: $date, period: $period)');
    }
    if (events[(date - period!.begins).inDays] == EventExistence.none) {
      events[(date - period!.begins).inDays] = EventExistence.trivial;
    }
  }

  void markUpAsImportant(Date date) {
    if (period == null || !period!.contains(date)) {
      throw ArgumentError(
          'date must be in period (date: $date, period: $period)');
    }
    events[(date - period!.begins).inDays] = EventExistence.important;
  }
}
