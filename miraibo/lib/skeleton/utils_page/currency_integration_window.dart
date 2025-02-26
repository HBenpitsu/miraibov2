import 'dart:async';

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
