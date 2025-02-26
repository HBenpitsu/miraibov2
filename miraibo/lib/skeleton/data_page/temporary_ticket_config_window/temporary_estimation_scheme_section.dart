import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// EstimationSchemeSection is a section to create an estimation scheme.
/// An estimation scheme consists of the following information:
///
/// - which categories should be counted
/// - what period should be counted
/// - how to display the estimation
///    - which display config does the ticket follow
///    - which currency does the ticket use
///

abstract interface class TemporaryEstimationSchemeSection {
  // <states>
  /// The initial temporary ticket scheme.
  /// This will not be changed while the section is alive.
  TemporaryTicketScheme get initialScheme;

  /// The current temporary ticket scheme.
  /// This will be changed on the end of the section-lifecycle.
  set currentScheme(TemporaryTicketScheme value);
  // </states>

  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// Get the initial configuration of the temporary estimation scheme.
  /// If [initialScheme] is not [TemporaryEstimationScheme], this method provides a default scheme.
  Future<TemporaryEstimationScheme> getInitialScheme();
  // </presenters>

  // <actions>
  Future<void> applyMonitorScheme(List<int> categoryIds, OpenPeriod period,
      EstimationDisplayOption displayOption, int currencyId);
  // </actions>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
