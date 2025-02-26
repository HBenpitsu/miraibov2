import 'package:miraibo/dto/dto.dart';

// <interface>
/// receipt log edit window is shown when user wants to edit receipt log.
///
/// receipt log consists of following information:
///
/// - which category the receipt log belongs to
/// - what the receipt log is
/// - how much the receipt log costs
/// - when the receipt log was created
/// - whether the receipt log is confirmed
///
abstract interface class ReceiptLogEditWindow {
  // <state>
  /// The ID of the receipt log to be edited.
  /// This is not changed during the lifecycle of the window.
  int get targetLogId;
  // </state>

  // <presenters>
  /// category to which the receipt log belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the receipt log costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  // here, we do not need default currency, because original receipt log already has currency.

  /// get original receipt log. original configuration should be supplied when users editing it.
  Future<ReceiptLogScheme> getOriginalReceiptLog();
  // </presenters>

  // <controllers>
  /// update the receipt log with the specified parameters.
  /// [targetLogId] is used to identify the receipt log to be updated.
  Future<void> updateReceiptLog(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Date date});

  /// delete the receipt log.
  /// [targetLogId] is used to identify the receipt log to be deleted.
  Future<void> deleteReceiptLog();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
