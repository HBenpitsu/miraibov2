import 'package:miraibo/core-model/value/collection/category_collection.dart';
import 'package:miraibo/core-model/value/receipt_record.dart';
import 'package:miraibo/core-model/value/period.dart';
import 'package:miraibo/core-model/entity/currency.dart';
import 'package:miraibo/core-model/value/price.dart';
import 'package:miraibo/repository/core.dart';

class RecordCollection {
  static final EstimationSchemeRepository _estimationSchemeRepository =
      EstimationSchemeRepository.instance;
  static final ReceiptLogRepository _receiptLogRepository =
      ReceiptLogRepository.instance;
  static final PlanRepository _planRepository = PlanRepository.instance;

  final Period period;
  final CategoryCollection categories;
  final List<ReceiptRecord> _records;

  RecordCollection._(this.period, this.categories, this._records);

  static Future<RecordCollection> get(
      Period period, CategoryCollection categories) async {
    final records = <ReceiptRecord>[];
    final future = period.intersection(Period.future());
    if (future != null) {
      await for (final estimation
          in _estimationSchemeRepository.get(future, categories)) {
        final intersectionPeriod = estimation.period.intersection(future);
        if (intersectionPeriod == null) continue;
        final price =
            await estimation.estimatePerDay(currency: estimation.currency);
        for (final date in intersectionPeriod.dates()) {
          records.add(ReceiptRecord(price: price, date: date));
        }
      }
      await for (final plan in _planRepository.get(future, categories)) {
        for (final date in plan.schedule.getScheduledDates(future)) {
          records.add(ReceiptRecord(price: plan.price, date: date));
        }
      }
    }
    final past = period.intersection(Period.past());
    if (past != null) {
      await for (final log in _receiptLogRepository.get(past, categories)) {
        records.add(ReceiptRecord(price: log.price, date: log.date));
      }
    }
    return RecordCollection._(period, categories, records);
  }

  static Future<RecordCollection> loggedRecords(
      Period period, CategoryCollection categories) async {
    final List<ReceiptRecord> records = [];
    await for (final log in _receiptLogRepository.get(period, categories)) {
      records.add(ReceiptRecord(price: log.price, date: log.date));
    }
    return RecordCollection._(period, categories, records);
  }

  /// O(n)
  Price total(Currency currency) {
    double total = 0;
    for (final record in _records) {
      total += record.price.exchangeTo(currency).amount;
    }
    return Price(currency: currency, amount: total);
  }

  /// O(n)
  Price meanPerDays(Currency currency) {
    double total = 0;
    for (final record in _records) {
      total += record.price.exchangeTo(currency).amount;
    }
    return Price(currency: currency, amount: total / period.durationInDays);
  }

  @override
  String toString() => 'RecordCollection{$period, $categories, $_records}';
}
