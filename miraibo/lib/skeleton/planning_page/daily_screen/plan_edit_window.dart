import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class PlanEditWindow {
  /// PlanEditWindow is a window to edit a plan.
  /// A plan consists of following information:
  ///
  /// - which category the plan belongs to
  /// - what the plan is
  /// - how much the plan will cost
  /// - when the plan will be executed
  ///

  // <states>
  abstract int targetPlanId;
  // </states>

  // <presenters>
  /// category to which the plan belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the plan costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  // here, we do not need default currency, because original plan already has currency.

  /// get original plan. original configuration should be supplied when users editing it.
  Future<RawPlan> getOriginalPlan();
  // </presenters>

  // <controllers>
  Future<void> updatePlan(
      int categoryId, String description, Price price, Schedule schedule);

  Future<void> deletePlan();
  // </controllers>
}
// </interface>
