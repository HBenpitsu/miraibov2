import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/estimation_scheme_section.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/monitor_scheme_section.dart';

// <interface>
abstract interface class TemporaryTicketConfigWindowPresenter {
  EstimationSchemeSectionPresenter get estimationSchemeSectionPresenter;
  MonitorSchemeSectionPresenter get monitorSchemeSectionPresenter;
}

abstract interface class TemporaryTicketConfigWindowController {
  EstimationSchemeSectionController get estimationSchemeSectionController;
  MonitorSchemeSectionController get monitorSchemeSectionController;
}
// </interface>