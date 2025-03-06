import 'package:miraibo/middleware/id_provider.dart';
import 'package:miraibo/repository/core.dart';

class Currency {
  static final CurrencyRepository _repository = CurrencyRepository.instance;
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
    return _repository.find(symbol, ratio);
  }

  static Future<Currency> findOrCreate(String symbol, double ratio) async {
    final found = await find(symbol, ratio);
    return found ?? create(symbol, ratio);
  }

  Future<void> integrateWith(Currency currency) async {
    final receiptLogs = _receiptLogRepository.savedIn(this);
    await for (final log in receiptLogs) {
      await log.update(price: log.price.exchangeTo(currency));
    }
    final plans = _planRepository.savedIn(this);
    await for (final plan in plans) {
      await plan.update(price: plan.price.exchangeTo(currency));
    }
    final estimations = _estimationSchemeRepository.savedIn(this);
    await for (final estimation in estimations) {
      await estimation.update(currency: currency);
    }
    final monitors = _monitorSchemeRepository.savedIn(this);
    await for (final monitor in monitors) {
      await monitor.update(currency: currency);
    }
    await _repository.delete(this);
  }

  static Future<Currency> create(String symbol, double ratio) async {
    final newEntity =
        Currency(id: IdProvider().get(), symbol: symbol, ratio: ratio);
    await _repository.insert(newEntity);
    return newEntity;
  }

  Future<void> update(String sumbol, double ratio) async {
    _symbol = sumbol;
    _ratio = ratio;
    await _repository.update(this);
  }

  @override
  String toString() => '$symbol($ratio, Currency)';
}
