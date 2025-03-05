import 'package:miraibo/middleware/id_provider.dart';
import 'package:miraibo/model/repository/primitive.dart';
import 'package:miraibo/model/value/period.dart';
import 'package:miraibo/model/value/collection/category_collection.dart';

class Currency {
  static final CurrencyRepository repository = CurrencyRepository.instance;
  static final ReceiptLogRepository _receiptLogRepository =
      ReceiptLogRepository.instance;
  static final PlanRepository _planRepository = PlanRepository.instance;
  static final EstimationSchemeRepository _estimationSchemeRepository =
      EstimationSchemeRepository.instance;
  static final MonitorSchemeRepository _monitorSchemeRepository =
      MonitorSchemeRepository.instance;

  final int id;
  String _symbol;
  String get symbol => _symbol;
  double _ratio;
  double get ratio => _ratio;

  Currency({
    required this.id,
    required String symbol,
    required double ratio,
  })  : _symbol = symbol,
        _ratio = ratio;

  static Future<Currency?> find(String symbol, double ratio) {
    return repository.find(symbol, ratio);
  }

  static Future<Currency> findOrCreate(String symbol, double ratio) async {
    final found = await find(symbol, ratio);
    return found ?? create(symbol, ratio);
  }

  Future<void> integrateWith(Currency currency) async {
    final receiptLogs = _receiptLogRepository.get(
        Period.entirePeriod, CategoryCollection.phantomAll);
    await for (final receiptLog in receiptLogs) {
      receiptLog.update(price: receiptLog.price.exchangeTo(currency));
    }
    final plans =
        _planRepository.get(Period.entirePeriod, CategoryCollection.phantomAll);
    await for (final plan in plans) {
      plan.update(price: plan.price.exchangeTo(currency));
    }
    final estimations = _estimationSchemeRepository.get(
        Period.entirePeriod, CategoryCollection.phantomAll);
    await for (final estimation in estimations) {
      estimation.update(currency: currency);
    }
    final monitors = _monitorSchemeRepository.get(
        Period.entirePeriod, CategoryCollection.phantomAll);
    await for (final monitor in monitors) {
      monitor.update(currency: currency);
    }
    await repository.delete(currency);
  }

  static Future<Currency> create(String symbol, double ratio) async {
    final newEntity =
        Currency(id: IdProvider().get(), symbol: symbol, ratio: ratio);
    await repository.insert(newEntity);
    return newEntity;
  }

  Future<void> update(String sumbol, double ratio) async {
    _symbol = sumbol;
    _ratio = ratio;
    await repository.update(this);
  }

  Future<void> delete() async {
    await repository.delete(this);
  }
}
