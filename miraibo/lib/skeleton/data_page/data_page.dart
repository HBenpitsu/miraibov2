import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/skeleton/data_page/operation_windows.dart';
import 'package:miraibo/skeleton/data_page/receipt_log_edit_window.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/chart_configuration_window.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/temporary_ticket_config_window.dart';

// <interface>
abstract interface class DataPage {
  /// data page consists of 4 sections:
  ///
  /// - chart section
  /// - temporary ticket section
  /// - operation section
  /// - table section
  ///
  /// tap the chart section navigates to the chart configuration window.
  /// tap the temporary ticket section navigates to the temporary ticket configuration window.
  ///
  /// operation section have 3 buttons:
  ///
  /// - import button: navigates to the importation window.
  /// - export button: navigates to the exportation window.
  /// - overwrite button: navigates to the overwrite window.
  /// - backup button: navigates to the backup window.
  /// - restore button: navigates to the restore window.
  ///
  /// table section shows virtually all of the receipt logs.
  /// each row of the table navigates to the receipt log edit window.

  // <states>
  abstract TicketScheme currentTicketScheme;
  abstract ChartScheme currentChartScheme;
  // </states>

  // <presenters>
  Stream<List<ChartChip>> getChart();
  Stream<MonitorAndEstimationTicket?> getTemporaryTicket();
  Stream<TableRebuildingNotification> listenToTableRebuildingNotification();
  Stream<TableSegment> getTableSegment();
  // </presenters>

  // <navigators>
  // chart section
  ChartConfigurationWindow openChartConfigurationWindow();
  // temporary ticket section
  TemporaryTicketConfigWindow openTemporaryTicketConfigWindow();
  // operation section
  ExportationWindow openExportationWindow();
  ImportationWindow openImportationWindow();
  OverwriteWindow openOverwriteWindow();
  BackupWindow openBackupWindow();
  RestoreWindow openRestoreWindow();
  // table section
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetReceiptLogId);
  // </navigators>
}

// </interface>

// <view model>

class TableRebuildingNotification {
  final DateTime timestamp;
  const TableRebuildingNotification(this.timestamp);

  bool rebuildRequired(TableRebuildingNotification lastNotification) {
    return timestamp.isAfter(lastNotification.timestamp);
  }
}

class TableSegment {
  final int topIndex;
  final int bottomIndex;
  final List<RawReceiptLog> records;
  const TableSegment(this.records, this.topIndex, this.bottomIndex);
}
// </view model>
