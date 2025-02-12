import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/estimation_scheme_section.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/monitor_scheme_section.dart';

// <interface>
abstract interface class TemporaryTicketConfigWindow {
  /// There are two types of instances of temporary tickets: estimation and monitor.
  /// This window is shown when user wants to configure the temporary ticket.
  /// There are two sections for each type of temporary ticket.

  // <states>
  abstract TicketScheme currentTicketScheme;
  // </states>

  // <navigators>
  EstimationSchemeSection get estimationSchemeSection;
  MonitorSchemeSection get monitorSchemeSection;
  // </navigators>
}

// </interface>
