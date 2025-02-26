import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// MonitorSchemeSection is a section to create a monitor scheme.
/// A monitor scheme consists of the following information:
///
/// - which categories should be counted
/// - what period should be counted
/// - how to display the monitor
///    - which display config the ticket follows
///    - which currency the ticket uses
///
abstract interface class TemporaryMonitorSchemeSection {
  // <states>
  /// The initial temporary ticket scheme.
  /// This will not be changed while the section is alive.
  TemporaryTicketScheme get initialScheme;

  /// The current temporary ticket scheme.
  /// This will be changed on the end of the section-lifecycle.
  set currentScheme(TemporaryTicketScheme value);
  // </states>

  // <presenters>
  /// Categories counted should be specified.
  /// All categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// The currency in which the ticket is shown should be specified.
  /// All currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// Get the initial configuration of the temporary monitor scheme.
  /// If [initialScheme] is not [TemporaryMonitorScheme], this method provides a default scheme.
  Future<TemporaryMonitorScheme> getInitialScheme();
  // </presenters>

  // <actions>
  /// Apply the specified monitor scheme to [currentScheme].
  Future<void> applyMonitorScheme(List<int> categoryIds, OpenPeriod period,
      MonitorDisplayOption displayOption, int currencyId);
  // </actions>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
