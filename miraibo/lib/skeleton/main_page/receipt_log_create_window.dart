import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class ReceiptLogCreateWindow {
  /// ReceiptLogSection is a section to create a receipt log.
  /// A receipt log consists of the following information:
  ///
  /// - which category the receipt log belongs to
  /// - what the receipt log is
  /// - how much the receipt log costs
  /// - when the receipt log was created
  /// - whether the receipt log is confirmed
  ///

  // <presenters>
  /// category to which the receipt log belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the receipt log costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// for convenience, default currency should be supplied.
  Future<Currency> getDefaultCurrency();
  // </presenters>

  // <controllers>
  Future<void> createReceiptLog(int categoryId, String description, Price price,
      Date date, bool confirmed);
  // </controllers>
}
// </interface>
