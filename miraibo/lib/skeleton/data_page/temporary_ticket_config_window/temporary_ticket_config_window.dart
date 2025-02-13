import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/estimation_scheme_section.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/monitor_scheme_section.dart';

// <interface>
/// There are two types of instances of temporary tickets: estimation and monitor.
/// This window is shown when user wants to configure the temporary ticket.
/// There are two sections for each type of temporary ticket.

abstract interface class TemporaryTicketConfigWindow {
  // <states>
  TemporaryTicketScheme get initialScheme;
  set currentScheme(TemporaryTicketScheme value);
  // </states>

  // <navigators>
  EstimationSchemeSection get estimationSchemeSection;
  MonitorSchemeSection get monitorSchemeSection;
  // </navigators>
}

// </interface>

// <mock>
class MockTemporaryTicketConfigWindow implements TemporaryTicketConfigWindow {
  @override
  final TemporaryTicketScheme initialScheme;
  final Function(TemporaryTicketScheme) schemeSetter;
  @override
  set currentScheme(TemporaryTicketScheme value) => schemeSetter(value);

  @override
  late final EstimationSchemeSection estimationSchemeSection;
  @override
  late final MonitorSchemeSection monitorSchemeSection;

  MockTemporaryTicketConfigWindow(this.initialScheme, this.schemeSetter) {
    estimationSchemeSection =
        MockEstimationSchemeSection(initialScheme, schemeSetter);
    monitorSchemeSection =
        MockMonitorSchemeSection(initialScheme, schemeSetter);
  }
}
// </mock>