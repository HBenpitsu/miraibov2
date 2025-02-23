import 'dart:async';
import 'dart:developer' show log;

import 'package:miraibo/dto/dto.dart';

// <interface>

/// CurrencyIntegrationWindow opens when the user wants to integrate a currency with another currency.
/// When opening the window, the user should specify the currency to be replaced.
/// The specified currency is stored in [replaceeId].
/// Users can select a currency to replace the specified currency from the options.
/// And then, users dispatch the integration process by tapping the integrate button.
abstract interface class CurrencyIntegrationWindow {
  // <states>
  /// The ID of the currency to be replaced.
  /// This is not changed during the lifecycle of the window.
  int get replaceeId;
  // </states>

  // <presenters>
  Future<Currency> getReplacee();

  /// In integration window, all currencies (except replacee) are shown as replacer options.
  Future<List<Currency>> getOptions();
  // </presenters>

  // <controllers>
  /// integrates a currency whose currency is [replacerId] with the currency of [replaceeId].
  Future<void> integrateCurrency(int replacerId);
  // </controllers>

  // <navigators>

  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
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
  Future<Currency> getReplacee() async {
    log('getReplacee is called with replaceeId: $replaceeId');
    return Currency(id: replaceeId, symbol: _currencies[replaceeId]?.$1 ?? '');
  }

  @override
  Future<List<Currency>> getOptions() async {
    log('getOptions is called');
    return _currencies.entries
        .where((entry) => entry.key != replaceeId)
        .map((entry) => Currency(id: entry.key, symbol: entry.value.$1))
        .toList(growable: false);
  }

  @override
  Future<void> integrateCurrency(int replacerId) async {
    log('integrateCurrency is called with replacerId: $replacerId');
    _currencies.remove(replaceeId);
    _currencyStream.add(_currencies);
  }

  @override
  void dispose() {
    log('CurrencyIntegrationWindow is disposed');
  }
}
