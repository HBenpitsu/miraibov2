import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class PlanSection {
  /// PlanSection is a section to create a plan.
  /// A plan consists of following information:
  ///
  /// - which category the plan belongs to
  /// - what the plan is
  /// - how much the plan will cost
  /// - when the plan will be executed
  ///

  // <presenters>
  /// category to which the plan belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the plan costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// for convenience, default currency should be supplied.
  Future<Currency> getDefaultCurrency();
  // </presenters>

  // <controllers>
  Future<void> createPlan(
      int categoryId, String description, Price price, Schedule schedule);
  // </controllers>
}
// </interface>
