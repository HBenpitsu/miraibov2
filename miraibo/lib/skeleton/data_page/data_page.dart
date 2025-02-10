import 'package:miraibo/skeleton/data_page/exportation_window.dart';
import 'package:miraibo/skeleton/data_page/importation_window.dart';
import 'package:miraibo/skeleton/data_page/overwrite_window.dart';
import 'package:miraibo/skeleton/data_page/receipt_log_edit_window.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/chart_configuration_window.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/temporary_ticket_config_window.dart';

// <interface>
abstract interface class DataPagePresenter {
  ExportationWindowPresenter get exportationWindowPresenter;
  ImportationWindowPresenter get importationWindowPresenter;
  OverwriteWindowPresenter get overwriteWindowPresenter;
  ReceiptLogEditWindowPresenter get receiptLogEditWindowPresenter;
  ChartConfigurationWindowPresenter get chartConfigurationWindowPresenter;
  TemporaryTicketConfigWindowPresenter get temporaryTicketConfigWindowPresenter;
}

abstract interface class DataPageController {
  ExportationWindowController get exportationWindowController;
  ImportationWindowController get importationWindowController;
  OverwriteWindowController get overwriteWindowController;
  ReceiptLogEditWindowController get receiptLogEditWindowController;
  ChartConfigurationWindowController get chartConfigurationWindowController;
  TemporaryTicketConfigWindowController
      get temporaryTicketConfigWindowController;
}
// </interface>