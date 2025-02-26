import 'package:miraibo/dto/dto.dart';

// <interface>
/// ReceiptLogSection is a section to create a receipt log.
/// A receipt log consists of the following information:
///
/// - which category the receipt log belongs to
/// - what the receipt log is
/// - how much the receipt log costs
/// - when the receipt log was created
/// - whether the receipt log is confirmed
///
/// Although this window is virtually the same as [ReceiptLogCreateWindow],
/// the difference is that they are window and section(not window).
/// This difference keep [ReceiptLogSection] and [ReceiptLogCreateWindow] separate.
abstract interface class ReceiptLogSection {
  // <presenters>
  /// category to which the receipt log belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the receipt log costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// initial scheme should be supplied.
  Future<ReceiptLogScheme> getInitialScheme();

  /// for convenience, presets for the receipt log should be supplied.
  Future<List<ReceiptLogSchemePreset>> getPresets();
  // </presenters>

  // <controllers>
  /// create the receipt log with the specified scheme.
  Future<void> createReceiptLog(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Date date});
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
