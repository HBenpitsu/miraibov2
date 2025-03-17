import 'package:logger/logger.dart';
import 'package:miraibo/core-model/value/collection/category_collection.dart';
import 'package:miraibo/core-model/value/period.dart';
import 'package:miraibo/core-model/entity/currency.dart';
import 'package:miraibo/repository/core.dart';
import 'package:miraibo/core-model/value/price.dart';
import 'package:miraibo/core-model/value/collection/record_collection.dart';
import 'package:miraibo/middleware/id_provider.dart';
import 'package:miraibo/shared/enumeration.dart';

enum MonitorDisplayStatisticsKind {
  summation,
  mean, // arithmetic mean
}

extension MonitorDisplayOptionInfo on MonitorDisplayOption {
  MonitorDisplayStatisticsKind get statisticsKind {
    switch (this) {
      case MonitorDisplayOption.summation:
        return MonitorDisplayStatisticsKind.summation;
      case MonitorDisplayOption.meanInDays:
      case MonitorDisplayOption.meanInWeeks:
      case MonitorDisplayOption.meanInMonths:
      case MonitorDisplayOption.meanInYears:
        return MonitorDisplayStatisticsKind.mean;
    }
  }

  int get scaler {
    switch (this) {
      case MonitorDisplayOption.summation:
        return 1;
      case MonitorDisplayOption.meanInDays:
        return 1;
      case MonitorDisplayOption.meanInWeeks:
        return 7;
      case MonitorDisplayOption.meanInMonths:
        return 30;
      case MonitorDisplayOption.meanInYears:
        return 365;
    }
  }
}

class MonitorScheme {
  static final MonitorSchemeRepository repository =
      MonitorSchemeRepository.instance;

  final int id;
  Period _period;
  Period get period => _period;
  Currency _currency;
  Currency get currency => _currency;
  MonitorDisplayOption _displayOption;
  MonitorDisplayOption get displayOption => _displayOption;
  CategoryCollection _categories;
  CategoryCollection get categories => _categories;

  MonitorScheme({
    required this.id,
    required Period period,
    required Currency currency,
    required MonitorDisplayOption displayOption,
    required CategoryCollection categories,
  })  : _period = period,
        _currency = currency,
        _displayOption = displayOption,
        _categories = categories;

  Future<Price> getValue() async {
    final records = await RecordCollection.get(period, categories);
    Price price;
    switch (displayOption.statisticsKind) {
      case MonitorDisplayStatisticsKind.summation:
        price = records.total(currency);
      case MonitorDisplayStatisticsKind.mean:
        price = records.meanPerDays(currency);
    }
    return price * displayOption.scaler;
  }

  static Future<MonitorScheme> create(
    Period period,
    Currency currency,
    MonitorDisplayOption displayOption,
    CategoryCollection categories,
  ) async {
    final newEntity = MonitorScheme(
      id: IdProvider().get(),
      period: period,
      currency: currency,
      displayOption: displayOption,
      categories: categories,
    );
    await repository.insert(newEntity);
    return newEntity;
  }

  static Stream<MonitorScheme?> watch(int id) {
    return repository.watchById(id);
  }

  Future<void> update({
    Period? period,
    Currency? currency,
    MonitorDisplayOption? displayOption,
    CategoryCollection? categories,
  }) async {
    _period = period ?? _period;
    _currency = currency ?? _currency;
    _displayOption = displayOption ?? _displayOption;
    _categories = categories ?? _categories;
    repository.update(this);
  }

  Future<void> delete() async {
    repository.delete(this);
  }

  @override
  String toString() =>
      'MonitorScheme{$period, $displayOption, $categories, $currency}';
}
