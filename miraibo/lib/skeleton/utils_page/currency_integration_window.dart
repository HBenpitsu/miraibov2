import 'dart:async';

import 'package:miraibo/dto/general.dart';

// <interface>

abstract interface class CurrencyIntegrationWindow {
  /// CurrencyIntegrationWindow opens when the user wants to integrate a currency with another currency.
  /// When opening the window, the user should specify the currency to be replaced.
  /// The specified currency is stored in [replaceeId].
  /// Users can select a currency to replace the specified currency from the options.
  /// And then, users dispatch the integration process by tapping the integrate button.

  // <states>
  int get replaceeId;
  // </states>

  // <presenters>
  /// In integration window, all currencies (except replacee) are shown as replacer options.
  Future<List<Currency>> getOptions();
  // </presenters>

  // <controllers>
  /// integrates a currency whose currency is [replacerId] with the currency of [replaceeId].
  Future<void> integrateCurrency(int replacerId);
  // </controllers>
}
// </interface>

// <mock>
typedef MockCurrencyMap = Map<int, (String, double)>;

class MockCurrencyIntegrationWindow implements CurrencyIntegrationWindow {
  @override
  final int replaceeId;
  final Sink<MockCurrencyMap> _currencyStream;
  final MockCurrencyMap _currencies;
  MockCurrencyIntegrationWindow(
      this.replaceeId, this._currencyStream, this._currencies);

  @override
  Future<List<Currency>> getOptions() async {
    return _currencies.entries
        .where((entry) => entry.key != replaceeId)
        .map((entry) => Currency(id: entry.key, symbol: entry.value.$1))
        .toList();
  }

  @override
  Future<void> integrateCurrency(int replacerId) async {
    _currencies.remove(replaceeId);
    _currencyStream.add(_currencies);
  }
}
