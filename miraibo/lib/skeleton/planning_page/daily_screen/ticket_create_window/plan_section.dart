import 'package:miraibo/dto/dto.dart';

// <interface>
/// PlanSection is a section to create a plan.
/// A plan consists of following information:
///
/// - which category the plan belongs to
/// - what the plan is
/// - how much the plan will cost
/// - when the plan will be executed
///

abstract interface class PlanSection {
  // <presenters>
  /// category to which the plan belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the plan costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// initial scheme should be supplied.
  Future<PlanScheme> getInitialScheme();
  // </presenters>

  // <controllers>
  /// create the plan with the specified scheme.
  Future<void> createPlan(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Schedule schedule});
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
