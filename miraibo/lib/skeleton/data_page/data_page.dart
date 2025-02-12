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
  Stream<List<ChartChip>?> getChart();
  Stream<MonitorAndEstimationTicket?> getTemporaryTicket();
  Future<TableSegment> getTableSegment();
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
class TableSegment {
  final int minimumIndexInSegment;
  final int maximumIndexInSegment;

  /// broadcast true when there are more records than the segment can show.
  /// when there are 25 records in database and two segments show 10 records each,
  /// each segment's overflow stream will broadcast true.
  /// when there are 25 records in database and three segments show at most 10 records each,
  /// the first two segments' overflow stream will broadcast true.
  /// the last segment's overflow stream will broadcast false.
  final Stream<bool> overflow;

  /// stream of records becomes null when rebuilding is needed.
  final Stream<List<Stream<RawReceiptLog>>?> records;
  const TableSegment(this.records, this.overflow, this.minimumIndexInSegment,
      this.maximumIndexInSegment);
}
// </view model>
