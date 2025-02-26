import 'package:miraibo/dto/dto.dart';

// <interface>
/// PlanEditWindow is a window to edit a plan.
/// A plan consists of the following information:
///
/// - which category the plan belongs to
/// - what the plan is
/// - how much the plan will cost
/// - when the plan will be executed
///
abstract interface class PlanEditWindow {
  // <states>
  /// This is used to identify the plan to be edited.
  /// This is not changed during the lifecycle of the window.
  int get targetPlanId;
  // </states>

  // <presenters>
  /// The category to which the plan belongs should be specified.
  /// All categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// The currency in which the plan costs should be specified.
  /// All currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// Get the original plan.
  /// The original scheme of the plan should be supplied when users are editing it.
  Future<PlanScheme> getOriginalPlan();
  // </presenters>

  // <controllers>
  /// Update the plan with the specified parameters.
  /// [targetPlanId] is used to identify the plan to be updated.
  Future<void> updatePlan(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Schedule schedule});

  /// Delete the plan.
  /// [targetPlanId] is used to identify the plan to be deleted.
  Future<void> deletePlan();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
