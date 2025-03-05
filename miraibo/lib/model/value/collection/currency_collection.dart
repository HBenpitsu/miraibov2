import 'package:miraibo/model/entity/currency.dart';
import 'package:miraibo/model/repository/primitive.dart';

class CurrencyCollection {
  static final CurrencyRepository _repository = CurrencyRepository.instance;

  final List<Currency> _currencies = [];
  List<Currency> get currencies => List.unmodifiable(_currencies);

  static Stream<List<Currency>> watchAll() {
    return _repository.allCurrencies().map((currencies) {
      return List.unmodifiable(currencies);
    });
  }

  static Future<List<Currency>> getAll() async {
    return List.unmodifiable(await _repository.allCurrencies().first);
  }

  static Future<Currency> getDefault() async {
    final defaultCurrency = await _repository.getDefault();
    if (defaultCurrency != null) {
      return defaultCurrency;
    }
    var currencies = await _repository.allCurrencies().first;

    if (currencies.isEmpty) {
      final firstCurrency = await Currency.create('USD', 1);
      _repository.setDefault(firstCurrency);
      return firstCurrency;
    } else {
      currencies = await _repository.allCurrencies().first;
      _repository.setDefault(currencies.first);
      return currencies.first;
    }
  }

  static void setDefault(Currency currency) async {
    await _repository.setDefault(currency);
  }

  @override
  String toString() => _currencies.toString();
}
