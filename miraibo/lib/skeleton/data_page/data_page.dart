import 'dart:async';
import 'dart:developer' show log;
import 'dart:math' show Random;

import 'package:collection/collection.dart';
import 'package:miraibo/dto/dto.dart';
// import 'package:miraibo/skeleton/data_page/shared.dart';
export 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/skeleton/data_page/operation_windows.dart';
export 'package:miraibo/skeleton/data_page/operation_windows.dart';
import 'package:miraibo/skeleton/data_page/receipt_log_edit_window.dart';
export 'package:miraibo/skeleton/data_page/receipt_log_edit_window.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/chart_configuration_window.dart';
export 'package:miraibo/skeleton/data_page/chart_configuration_window/chart_configuration_window.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/temporary_ticket_config_window.dart';
export 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/temporary_ticket_config_window.dart';

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
  final List<String> categoryNames;

  const TemporaryEstimationTicket(
      {required this.period,
      required this.price,
      required this.displayOption,
      required this.categoryNames});
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

// <mock>
class MockDataPage implements DataPage {
  late final Stream<ChartScheme> chartStream;
  late final Sink<ChartScheme> chartSink;

  /// the inner field to implement currentChartScheme
  late ChartScheme _currentChartScheme;
  @override
  ChartScheme get currentChartScheme => _currentChartScheme;
  @override
  set currentChartScheme(ChartScheme scheme) {
    _currentChartScheme = scheme;
    chartSink.add(scheme);
  }

  /// this method is defined to be passed to the chart configuration window.
  void setChartScheme(ChartScheme scheme) {
    currentChartScheme = scheme;
  }

  late final Stream<TemporaryTicketScheme> temporaryTicketStream;
  late final Sink<TemporaryTicketScheme> temporaryTicketSink;

  /// the inner field to implement currentTicketScheme
  late TemporaryTicketScheme _currentTicketScheme;
  @override
  TemporaryTicketScheme get currentTicketScheme => _currentTicketScheme;
  @override
  set currentTicketScheme(TemporaryTicketScheme scheme) {
    _currentTicketScheme = scheme;
    temporaryTicketSink.add(scheme);
  }

  /// this method is defined to be passed to the temporary ticket configuration window.
  void setTicketScheme(TemporaryTicketScheme scheme) {
    currentTicketScheme = scheme;
  }

  /// the mock vault to store the receipt logs.
  /// it is separated from the data page mock to make the data page mock simple.
  final MockReceiptLogVault mockVault = MockReceiptLogVault();

  MockDataPage() {
    log('MockDataPage: constructed');
    final chartStreamController = StreamController<ChartScheme>.broadcast();
    chartStream = chartStreamController.stream;
    chartSink = chartStreamController.sink;

    currentChartScheme = const ChartSchemeUnspecified();

    final temporaryTicketStreamController =
        StreamController<TemporaryTicketScheme>.broadcast();
    temporaryTicketStream = temporaryTicketStreamController.stream;
    temporaryTicketSink = temporaryTicketStreamController.sink;

    currentTicketScheme = const TemporaryTicketSchemeUnspecified();
  }

  Random random = Random();

  @override
  Stream<Chart> getChart() {
    log('MockDataPage: getChart called');
    // <prepare parameters>
    final now = DateTime.now();
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    final twoWeeksLater = now.add(const Duration(days: 14));
    final thisMonth = Date(now.year, now.month, 1);
    final period = ClosedPeriod(
        begins: twoWeeksAgo.cutOffTime(), ends: twoWeeksLater.cutOffTime());
    // </prepare parameters>
    return chartStream.map((scheme) {
      switch (scheme) {
        // provide mock chart based on the scheme.
        case PieChartScheme _:
          final numberOfChips = 10;
          double gross = 0;
          final List<RatioValue> chips = [];
          for (var i = 1; i <= numberOfChips; i++) {
            final amount = (numberOfChips - i.toDouble()) * 100000;
            gross += amount;
          }
          for (var i = 1; i <= numberOfChips; i++) {
            final amount = (numberOfChips - i.toDouble()) * 100000;
            chips.add(RatioValue(
                categoryName: 'category $i',
                amount: amount,
                ratio: amount / gross));
          }
          if (gross == 0) {
            return PieChart(
                currencySymbol: 'JPY',
                analysisRange: OpenPeriod(begins: null, ends: null),
                gross: 0,
                chips: []);
          }
          return PieChart(
              currencySymbol: 'JPY',
              analysisRange: OpenPeriod(begins: null, ends: null),
              gross: gross,
              chips: chips);
        case SubtotalChartScheme _:
          return SubtotalChart(
              currencySymbol: 'JPY',
              viewportRange: period,
              categoryNames: ['category1', 'category2', 'category3'],
              bars: [
                for (var i = 1; i < 50; i++)
                  SubtotalValue(
                      amount: 100.0 * random.nextDouble() + 500,
                      date: Date(thisMonth.year, thisMonth.month, i))
              ],
              intervalInDays: 7,
              yAxisExtent: 600,
              maxScale: 5,
              todaysIndex: 10);
        case AccumulationChartScheme _:
          return AccumulationChart(
              currencySymbol: 'JPY',
              analysisRange: const OpenPeriod(begins: null, ends: null),
              viewportRange: period,
              categoryNames: ['category1', 'category2', 'category3'],
              bars: [
                for (var i = 1; i < 50; i++)
                  AccumulatedValue(
                      amount: 100.0 * i, date: Date(thisMonth.year, 12, i))
              ],
              yAxisExtent: 5000,
              maxScale: 5,
              todaysIndex: 10);
        case ChartSchemeUnspecified _:
          return ChartUnspecified();
      }
    });
  }

  @override
  Stream<TemporaryTicket> getTemporaryTicket() {
    log('MockDataPage: getTemporaryTicket called');
    // <prepare parameters>
    const period = OpenPeriod(begins: null, ends: null);
    const price = Price(amount: 1000, symbol: 'JPY');
    // </prepare parameters>
    return temporaryTicketStream.map((scheme) {
      switch (scheme) {
        // provide mock ticket based on the scheme.
        case TemporaryEstimationScheme _:
          return const TemporaryEstimationTicket(
              period: period,
              price: price,
              displayOption: EstimationDisplayOption.perDay,
              categoryNames: []);
        case TemporaryMonitorScheme _:
          return const TemporaryMonitorTicket(
              period: period,
              price: price,
              displayOption: MonitorDisplayOption.meanInDays,
              categoryNames: []);
        case TemporaryTicketSchemeUnspecified _:
          return TemporaryTicketUnspecified();
      }
    });
  }

  @override
  ChartConfigurationWindow openChartConfigurationWindow() {
    log('MockDataPage: openChartConfigurationWindow called');
    return MockChartConfigurationWindow(currentChartScheme, setChartScheme);
  }

  @override
  TemporaryTicketConfigWindow openTemporaryTicketConfigWindow() {
    log('MockDataPage: openTemporaryTicketConfigWindow called');
    return MockTemporaryTicketConfigWindow(
        currentTicketScheme, setTicketScheme);
  }

  @override
  ExportationWindow openExportationWindow() {
    log('MockDataPage: openExportationWindow called');
    return MockExportationWindow();
  }

  @override
  ImportationWindow openImportationWindow() {
    log('MockDataPage: openImportationWindow called');
    return MockImportationWindow();
  }

  @override
  OverwriteWindow openOverwriteWindow() {
    log('MockDataPage: openOverwriteWindow called');
    return MockOverwriteWindow();
  }

  @override
  BackupWindow openBackupWindow() {
    log('MockDataPage: openBackupWindow called');
    return MockBackupWindow();
  }

  @override
  RestoreWindow openRestoreWindow() {
    log('MockDataPage: openRestoreWindow called');
    return MockRestoreWindow();
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetReceiptLogId) {
    log('MockDataPage: openReceiptLogEditWindow called with targetReceiptLogId: $targetReceiptLogId');
    return MockReceiptLogEditWindow(
        targetReceiptLogId, mockVault.ticketsSink, mockVault.tickets);
  }

  @override
  Stream<ReceiptLogSchemeInstance?> getReceiptLog(int index) {
    log('MockDataPage: getReceiptLog called with index: $index');
    return mockVault.recordStreamFor(index);
  }

  @override
  Stream<int> getTableSize() {
    log('MockDataPage: getTableSize called');
    final returnStream = StreamController<int>();
    returnStream.add(mockVault.receiptLogs.length);
    returnStream
        .addStream(mockVault.receiptLogsStream.map((logs) => logs.length));
    return returnStream.stream;
  }

  @override
  void dispose() {
    log('MockDataPage: dispose called');
    mockVault.dispose();
  }
}

class MockReceiptLogVault {
  // <valut fields>
  /// the mock vault to store the receipt logs.
  late final List<ReceiptLogSchemeInstance> receiptLogs;
  // it listens to updates of the receipt logs.
  late final Stream<List<ReceiptLogSchemeInstance>> receiptLogsStream;
  late final Sink<List<ReceiptLogSchemeInstance>> receiptLogsSink;
  // it provides the first record of the receipt logs.
  late final Stream<ReceiptLogSchemeInstance?> firstRecordStream;
  Stream<int?> get firstKey => firstRecordStream.map((record) => record?.id);
  // </valut fields>
  MockReceiptLogVault() {
    // <mock receipt logs>
    receiptLogs = [
      for (var i = 0; i < 2000; i++)
        ReceiptLogSchemeInstance(
            id: i,
            price: const ConfigureblePrice(
                amount: 1000, currencySymbol: 'JPY', currencyId: 0),
            date: Date(2021, 1, i + 1),
            category: const Category(id: 0, name: 'category0'),
            description: 'this is a receipt log',
            confirmed: false)
    ];
    // </mock receipt logs>
    // <initialize stream>
    final receiptLogsStreamController =
        StreamController<List<ReceiptLogSchemeInstance>>.broadcast();
    receiptLogsStream = receiptLogsStreamController.stream;
    receiptLogsSink = receiptLogsStreamController.sink;
    receiptLogsSink.add(receiptLogs);
    final firstRecordStreamController =
        StreamController<ReceiptLogSchemeInstance?>.broadcast();
    firstRecordStreamController
        .addStream(receiptLogsStream.map((logs) => logs.firstOrNull));
    firstRecordStream = firstRecordStreamController.stream;
    // </initialize stream>
  }

  Stream<ReceiptLogSchemeInstance?> recordStreamFor(int index) {
    if (index < 0 || index >= receiptLogs.length) {
      return Stream.value(null);
    }
    final returnStream = StreamController<ReceiptLogSchemeInstance?>();
    returnStream.add(receiptLogs[index]);
    returnStream.addStream(receiptLogsStream.map((logs) {
      if (index < 0 || index >= receiptLogs.length) return null;
      return logs[index];
    }));
    return returnStream.stream;
  }

  /// provides a sink which can receive the data in ticket format.
  /// The format is not essential. Because this is mere mock, type-system is not so sophisticated.
  Sink<List<Ticket>> get ticketsSink {
    final ticketSink = StreamController<List<Ticket>>();
    ticketSink.stream.listen((tickets) {
      // update the receipt logs with new tickets everytime.
      final newLogs = <ReceiptLogSchemeInstance>[];
      for (var ticket in tickets) {
        if (ticket is! ReceiptLogTicket) continue;
        final log = ReceiptLogSchemeInstance(
            id: ticket.id,
            price: ConfigureblePrice(
                amount: ticket.price.amount,
                currencySymbol: ticket.price.symbol,
                currencyId: 0),
            date: ticket.date,
            category: Category(id: 0, name: ticket.categoryName),
            description: ticket.description,
            confirmed: ticket.confirmed);
        newLogs.add(log);
      }
      // vault fields are updated on every ticket update.
      receiptLogs.clear();
      receiptLogs.addAll(newLogs);
      receiptLogsSink.add(receiptLogs);
    });
    return ticketSink.sink;
  }

  /// provides a list of receipt logs in ticket format.
  /// The format is not essential. Because this is mere mock, type-system is not so sophisticated.
  List<Ticket> get tickets {
    return receiptLogs
        .map((logContent) => ReceiptLogTicket(
            id: logContent.id,
            price: Price(
                amount: logContent.price.amount,
                symbol: logContent.price.currencySymbol),
            date: logContent.date,
            categoryName: logContent.category.name,
            description: logContent.description,
            confirmed: logContent.confirmed) as Ticket)
        .toList();
  }

  void dispose() {}
}
// </mock>
