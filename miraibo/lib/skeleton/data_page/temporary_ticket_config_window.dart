import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/shared/enumeration.dart';
import 'package:miraibo/skeleton/data_page/shared.dart';
export 'package:miraibo/skeleton/data_page/shared.dart';

// <window>
// <interface>
/// There are two types of instances of temporary tickets: estimation and monitor.
/// This window is shown when user wants to configure the temporary ticket.
/// There are two sections for each type of temporary ticket.

abstract interface class TemporaryTicketConfigWindow {
  // <states>
  /// The initial temporary ticket scheme.
  /// 'initial' means the time when the window is opened.
  /// This will not be changed while the window is alive.
  TemporaryTicketScheme get initialScheme;

  /// The current temporary ticket scheme.
  /// This will be changed on the end of the window-lifecycle.
  set currentScheme(TemporaryTicketScheme value);
  // </states>

  // <presenters>
  Future<TemporaryTicketScheme> getInitialScheme();
  // </presenters>

  // <navigators>
  /// A tab of the window.
  TemporaryEstimationSchemeSection get estimationSchemeSection;

  /// A tab of the window.
  TemporaryMonitorSchemeSection get monitorSchemeSection;

  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

// </interface>
// </window>

// <sections>
// <estimation scheme section>

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
  Future<void> applyMonitorScheme(int categoryId, OpenPeriod period,
      EstimationDisplayOption displayOption, int currencyId);
  // </actions>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>

// </estimation scheme section>
// <monitor scheme section>
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
  Future<void> applyMonitorScheme(
    List<int> categoryIds,
    OpenPeriod period,
    MonitorDisplayOption displayOption,
    int currencyId,
    bool isAllCategoriesIncluded,
  );
  // </actions>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </monitor scheme section>
// </sections>
