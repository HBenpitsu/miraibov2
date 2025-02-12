import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class ReceiptLogEditWindow {
  /// receipt log edit window is shown when user wants to edit receipt log.
  ///
  /// receipt log consists of following information:
  ///
  /// - which category do the receipt belongs to
  /// - what really is the receipt
  /// - how much do items in the receipt cost
  /// - when the receipt log was created
  /// - whether the receipt is confirmed
  ///

  // <states>
  abstract int targetLogId;
  // </states>

  // <presenters>
  /// category to which the receipt log belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the receipt log costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  // here, we do not need default currency, because original receipt log already has currency.

  /// get original receipt log. original configuration should be supplied when users editing it.
  Future<RawReceiptLog> getOriginalReceiptLog();
  // </presenters>

  // <controllers>
  Future<void> updateReceiptLog(int categoryId, String description, Price price,
      Date date, bool confirmed);

  Future<void> deleteReceiptLog();
  // </controllers>
}
// </interface>
