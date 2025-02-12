import 'package:miraibo/dto/general.dart';

// <interface>

abstract interface class CurrencyIntegrationWindow {
  // <states>
  abstract int replaceeId;
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

