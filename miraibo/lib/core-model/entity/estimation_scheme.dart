import 'package:miraibo/core-model/value/collection/category_collection.dart';
import 'package:miraibo/core-model/value/period.dart';
import 'package:miraibo/core-model/entity/currency.dart';
import 'package:miraibo/core-model/entity/category.dart';
import 'package:miraibo/core-model/value/collection/record_collection.dart';
import 'package:miraibo/core-model/value/price.dart';
import 'package:miraibo/repository/core.dart';
import 'package:miraibo/middleware/id_provider.dart';
import 'package:miraibo/core-model/value/date.dart';
import 'package:miraibo/shared/enumeration.dart';

extension EstimationDisplayOptionScaleFactors on EstimationDisplayOption {
  int get scaler {
    switch (this) {
      case EstimationDisplayOption.perDay:
        return 1;
      case EstimationDisplayOption.perWeek:
        return 7;
      case EstimationDisplayOption.perMonth:
        return 30;
      case EstimationDisplayOption.perYear:
        return 365;
    }
  }
}

class EstimationScheme {
  static final EstimationSchemeRepository repository =
      EstimationSchemeRepository.instance;

  final int id;
  Period _period;
  Period get period => _period;
  Currency _currency;
  Currency get currency => _currency;
  EstimationDisplayOption _displayOption;
  EstimationDisplayOption get displayOption => _displayOption;
  Category _category;
  Category get category => _category;

  EstimationScheme({
    required this.id,
    required Period period,
    required Currency currency,
    required EstimationDisplayOption displayOption,
    required Category category,
  })  : _period = period,
        _currency = currency,
        _displayOption = displayOption,
        _category = category;

  Future<Price> estimatePerDay({Currency? currency}) async {
    final today = Date.today();
    final estimationRange =
        Period(begins: today.withDelta(months: -1), ends: today);
    final records = await RecordCollection.loggedRecords(
        estimationRange, CategoryCollection.single(category));
    return records.meanPerDays(currency ?? this.currency);
  }

  Future<Price> scaledEstimation({Currency? currency}) async {
    final price = await estimatePerDay(currency: currency);
    return price.exchangeOrKeep(currency) * displayOption.scaler;
  }

  static Future<EstimationScheme> create(
    Period period,
    Currency currency,
    EstimationDisplayOption displayOption,
    Category category,
  ) async {
    final newEntity = EstimationScheme(
      id: IdProvider().get(),
      period: period,
      currency: currency,
      displayOption: displayOption,
      category: category,
    );
    await repository.insert(newEntity);
    return newEntity;
  }

  Future<void> update({
    Period? period,
    Currency? currency,
    EstimationDisplayOption? displayOption,
    Category? category,
  }) async {
    _period = period ?? _period;
    _currency = currency ?? _currency;
    _displayOption = displayOption ?? _displayOption;
    _category = category ?? _category;
    repository.update(this);
  }

  Future<void> delete() async {
    repository.delete(this);
  }

  @override
  String toString() =>
      'EstimationScheme{ $period, $displayOption, $currency, $category }';
}
