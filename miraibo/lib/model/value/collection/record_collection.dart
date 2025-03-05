import 'package:miraibo/model/value/collection/category_collection.dart';
import 'package:miraibo/model/value/receipt_record.dart';
import 'package:miraibo/model/value/period.dart';
import 'package:miraibo/model/entity/currency.dart';
import 'package:miraibo/model/value/price.dart';
import 'package:miraibo/model/repository/primitive.dart';
import 'package:miraibo/model/value/date.dart';

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
    await for (final estimation
        in _estimationSchemeRepository.get(period, categories)) {
      final intersectionPeriod = estimation.period.intersection(period);
      if (intersectionPeriod == null) continue;
      final price =
          await estimation.estimatePerDay(currency: estimation.currency);
      for (final date in intersectionPeriod.dates()) {
        records.add(ReceiptRecord(price: price, date: date));
      }
    }
    await for (final log in _receiptLogRepository.get(period, categories)) {
      records.add(ReceiptRecord(price: log.price, date: log.date));
    }
    await for (final plan in _planRepository.get(period, categories)) {
      final dates = plan.schedule.getScheduledDates(period);
      for (final date in dates) {
        records.add(ReceiptRecord(price: plan.price, date: date));
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
    Date latest = Date.earliest;
    for (final record in _records) {
      total += record.price.exchangeTo(currency).amount;
      latest = Date.later(latest, record.date);
    }
    return Price(currency: currency, amount: total / period.durationInDays);
  }
}
