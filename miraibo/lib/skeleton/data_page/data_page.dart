import 'dart:async';

import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/shared/enumeration.dart';
export 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window.dart';
export 'package:miraibo/skeleton/data_page/chart_configuration_window.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window.dart';
export 'package:miraibo/skeleton/data_page/temporary_ticket_config_window.dart';

// <shared skeleton>
// receipt log edit window is used from the data page.
import 'package:miraibo/skeleton/shared.dart';
export 'package:miraibo/skeleton/shared.dart';
// </shared skeleton>

// <page>
// <interface>
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

abstract interface class DataPage {
  // <states>
  abstract TemporaryTicketScheme currentTicketScheme;
  abstract ChartScheme currentChartScheme;
  // </states>

  // <presenters>
  Stream<Chart> getChart();
  Stream<TemporaryTicket> getTemporaryTicket();

  // table section
  Stream<ReceiptLogSchemeInstance?> getReceiptLog(int index);
  Stream<int> getTableSize();
  // </presenters>

  // <navigators>
  // chart section
  /// on tapping the chart section, open the chart configuration window.
  ChartConfigurationWindow openChartConfigurationWindow();
  // temporary ticket section
  /// on tapping the temporary ticket, open the temporary ticket configuration window.
  TemporaryTicketConfigWindow openTemporaryTicketConfigWindow();
  // operation section
  /// on tapping the import button, open the importation window.
  ExportationWindow openExportationWindow();

  /// on tapping the export button, open the exportation window.
  ImportationWindow openImportationWindow();

  /// on tapping the overwrite button, open the overwrite window.
  OverwriteWindow openOverwriteWindow();

  /// on tapping the backup button, open the backup window.
  BackupWindow openBackupWindow();

  /// on tapping the restore button, open the restore window.
  RestoreWindow openRestoreWindow();

  // table section
  /// on tapping a row of the table, open the receipt log edit window
  /// that edits the receipt log of the row.
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetReceiptLogId);

  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

// </interface>

// <view model>
/// Chart is a view model that represents a chart.
/// It contains the all data to draw the chart.
/// It does not contain any data not to draw the chart.
sealed class Chart {
  const Chart();
}

class PieChart extends Chart {
  final String currencySymbol;
  final OpenPeriod analysisRange;
  final double gross;
  final List<RatioValue> chips;

  const PieChart(
      {required this.currencySymbol,
      required this.analysisRange,
      required this.gross,
      required this.chips});
}

class SubtotalChart extends Chart {
  final String currencySymbol;
  final ClosedPeriod viewportRange;
  final List<String> categoryNames;
  final List<SubtotalValue> bars;
  final int intervalInDays;
  final int yAxisExtent;
  final double maxScale;
  final int todaysIndex;

  const SubtotalChart(
      {required this.currencySymbol,
      required this.categoryNames,
      required this.viewportRange,
      required this.bars,
      required this.intervalInDays,
      required this.yAxisExtent,
      required this.maxScale,
      required this.todaysIndex});

  int get maxXIndex => bars.length;
}

class AccumulationChart extends Chart {
  final String currencySymbol;
  final List<String> categoryNames;
  final OpenPeriod analysisRange;
  final ClosedPeriod viewportRange;
  final List<AccumulatedValue> bars;
  final int yAxisExtent;
  final double maxScale;
  final int todaysIndex;

  const AccumulationChart(
      {required this.currencySymbol,
      required this.categoryNames,
      required this.analysisRange,
      required this.viewportRange,
      required this.bars,
      required this.yAxisExtent,
      required this.maxScale,
      required this.todaysIndex});

  int get maxXIndex => bars.length;
}

class ChartUnspecified extends Chart {
  const ChartUnspecified();
}

/// TemporaryTicket is a view model that represents a temporary ticket.
/// It contains the all data to show the ticket.
/// It does not contain any data not to show the ticket.
sealed class TemporaryTicket {
  const TemporaryTicket();
}

class TemporaryEstimationTicket extends TemporaryTicket {
  final OpenPeriod period;
  final Price price;
  final EstimationDisplayOption displayOption;

  /// empty when all categories are counted.
  final String categoryName;

  const TemporaryEstimationTicket(
      {required this.period,
      required this.price,
      required this.displayOption,
      required this.categoryName});
}

class TemporaryMonitorTicket extends TemporaryTicket {
  final OpenPeriod period;
  final Price price;
  final MonitorDisplayOption displayOption;

  /// empty when all categories are counted.
  final List<String> categoryNames;

  const TemporaryMonitorTicket(
      {required this.period,
      required this.price,
      required this.displayOption,
      required this.categoryNames});
}

class TemporaryTicketUnspecified extends TemporaryTicket {}

// </view model>
// </page>

// <operation windows>

// <interface>
/// exportation window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to export receipt log data to external environment.
abstract interface class ExportationWindow {
  // <controllers>
  Future<bool> exportDataTo(String path);
  // </controllers>
  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

/// overwrite window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to overwrite receipt logs with external data.
/// That means that all of the current receipt logs in app will be deleted and replaced with the external data.
abstract interface class OverwriteWindow {
  // <controllers>
  Future<bool> overwriteDataWith(String path);
  // </controllers>
  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

/// import window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to import receipt log data from external environment.
abstract interface class ImportationWindow {
  // <controllers>
  Future<bool> importDataFrom(String path);
  // </controllers>
  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

/// backup window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to backup receipt log data to external environment.
/// The backup data contains all of app data. That means that the backup-file contains:
///
/// - all of the receipt logs
/// - all of the plans
/// - all of the estimation schemes
/// - all of the monitor schemes
/// - all of the categories
/// - all of the currencies
///
/// and so on.
/// The backup-file can be used to restore the app data later.
abstract interface class BackupWindow {
  // <controllers>
  Future<bool> backupDataTo(String path);
  // </controllers>
  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

/// restore window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to restore app data from external environment.
/// Restoration resets all of current database and replaces with the external data.
abstract interface class RestoreWindow {
  // <controllers>
  Future<bool> restoreDataFrom(String path);
  // </controllers>
  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </operation windows>
