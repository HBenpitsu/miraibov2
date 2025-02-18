import 'dart:async';

import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/data_page/shared.dart';
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

  /// the first key is provided from the stream.
  /// if new key is provided from the stream, insert the 1 record segment in front of the table.
  /// 1 record segment can be fetched by calling [getTableSegment] with [limit]=1
  Stream<int?> generateFirstKey();

  /// to get the first segment, call [generateFirstKey] and pass the generated [key] to [getTableSegment].
  /// the limit is the number of records in the segment.
  /// the [key] of the next segment is provided from the stream of the segment.
  Future<TableSegment> getTableSegment(int key, int limit);
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
typedef TableRecord = Stream<ReceiptLogSchemeInstance?>;

/// Table segment is a set of table rows.
/// It provides some features to show the table efficiently.
class TableSegment {
  /// success key is provided from stream. It represents the key of the next segment.
  /// if there is no segment to fetch, the success key is null.
  final Stream<int?> successKey;

  /// record is a stream of receipt log configs.
  /// it reflects the mutation of the receipt logs.
  /// the stream for each record emits null the receipt log is no longer exists.
  /// the stream for bunch of records emits null when all of the records are no longer exists.
  late final Stream<List<TableRecord>?> records;
  late int numberOfRecords;

  /// when records get null, the [nullCount] is incremented.
  /// when [nullCount] gets equal to the length of the [numberOfRecords],
  /// there is no meaning for the segment to exist any more.
  int nullCount = 0;

  TableSegment(List<TableRecord> records, this.successKey) {
    // make a stream that emits null (that is [this.records]) when all of the records are null.

    // to make that complex stream, we need:
    // - to count up the number of null records.
    // - compare the number of null records with the number of records on each record update.
    // - emit null on the check if the condition is satisfied.
    // this can be achieved by using StreamController.
    StreamController<List<TableRecord>?> recordsStream =
        StreamController.broadcast();
    numberOfRecords = records.length;
    for (var record in records) {
      // listen to every record update.
      record.listen((record) {
        if (record != null) return;
        // count up the number of null records.
        nullCount++;
        if (nullCount >= numberOfRecords) {
          // emit null when all of the records are null.
          recordsStream.add(null);
        }
      });
    }
    // we could implement 'null emitting'.

    // also, [this.records] should orovide the stream of the records
    // if there is some non-null records.
    // initially, it is expected that all of the records are non-null.
    recordsStream.add(records);

    // after initialization above, we can provide the stream of the records.
    this.records = recordsStream.stream;
  }
}

/// Chart is a view model that represents a chart.
/// It contains the all data to draw the chart.
/// It does not contain any data not to draw the chart.
sealed class Chart {
  const Chart();
}

class PieChart extends Chart {
  final String currencyName;
  final OpenPeriod analysisRange;
  final List<PieChartChip> chips;

  const PieChart(
      {required this.currencyName,
      required this.analysisRange,
      required this.chips});
}

class SubtotalChart extends Chart {
  final String currencyName;
  final ClosedPeriod viewportRange;
  final List<String> categoryNames;
  final List<SubtotalBar> bars;

  const SubtotalChart(
      {required this.currencyName,
      required this.categoryNames,
      required this.viewportRange,
      required this.bars});
}

class AccumulationChart extends Chart {
  final String currencyName;
  final List<String> categoryNames;
  final OpenPeriod analysisRange;
  final ClosedPeriod viewportRange;
  final List<AccumulatedBar> bars;

  const AccumulationChart(
      {required this.currencyName,
      required this.categoryNames,
      required this.analysisRange,
      required this.viewportRange,
      required this.bars});
}

class ChartUnspecified extends Chart {}

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
    currentChartScheme = const ChartSchemeUnspecified();
    currentTicketScheme = const TemporaryTicketSchemeUnspecified();
    final chartStreamController = StreamController<ChartScheme>();
    chartStream = chartStreamController.stream;
    chartSink = chartStreamController.sink;
    final temporaryTicketStreamController =
        StreamController<TemporaryTicketScheme>();
    temporaryTicketStream = temporaryTicketStreamController.stream;
    temporaryTicketSink = temporaryTicketStreamController.sink;
  }

  @override
  Stream<Chart> getChart() {
    // <prepare parameters>
    final now = DateTime.now();
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    final twoWeeksLater = now.add(const Duration(days: 14));
    final thisMonth = Date(now.year, now.month, 1);
    final period = ClosedPeriod(
        begins: Date(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day),
        ends: Date(twoWeeksLater.year, twoWeeksLater.month, twoWeeksLater.day));
    // </prepare parameters>
    return chartStream.map((scheme) {
      switch (scheme) {
        // provide mock chart based on the scheme.
        case PieChartScheme _:
          return const PieChart(
              currencyName: 'JPY',
              analysisRange: OpenPeriod(begins: null, ends: null),
              chips: [
                PieChartChip(categoryName: 'category1', amount: 300),
                PieChartChip(categoryName: 'category2', amount: 400),
                PieChartChip(categoryName: 'category3', amount: 500)
              ]);
        case SubtotalChartScheme _:
          return SubtotalChart(
              currencyName: 'JPY',
              viewportRange: period,
              categoryNames: [
                'category1',
                'category2',
                'category3'
              ],
              bars: [
                for (var i = 1; i < 20; i++)
                  SubtotalBar(
                      amount: 100,
                      date: Date(thisMonth.year, thisMonth.month, i))
              ]);
        case AccumulationChartScheme _:
          return AccumulationChart(
              currencyName: 'JPY',
              analysisRange: const OpenPeriod(begins: null, ends: null),
              viewportRange: period,
              categoryNames: [],
              bars: [
                for (var i = 1; i < 20; i++)
                  AccumulatedBar(
                      amount: 100,
                      date: Date(thisMonth.year, thisMonth.month, i))
              ]);
        case ChartSchemeUnspecified _:
          return ChartUnspecified();
      }
    });
  }

  @override
  Stream<TemporaryTicket> getTemporaryTicket() {
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
    return MockChartConfigurationWindow(currentChartScheme, setChartScheme);
  }

  @override
  TemporaryTicketConfigWindow openTemporaryTicketConfigWindow() {
    return MockTemporaryTicketConfigWindow(
        currentTicketScheme, setTicketScheme);
  }

  @override
  ExportationWindow openExportationWindow() {
    return MockExportationWindow();
  }

  @override
  ImportationWindow openImportationWindow() {
    return MockImportationWindow();
  }

  @override
  OverwriteWindow openOverwriteWindow() {
    return MockOverwriteWindow();
  }

  @override
  BackupWindow openBackupWindow() {
    return MockBackupWindow();
  }

  @override
  RestoreWindow openRestoreWindow() {
    return MockRestoreWindow();
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetReceiptLogId) {
    return MockReceiptLogEditWindow(
        targetReceiptLogId, mockVault.ticketsSink, mockVault.tickets);
  }

  @override
  Stream<int?> generateFirstKey() {
    return mockVault.firstKey;
  }

  @override
  Future<TableSegment> getTableSegment(int key, int limit) {
    final (records, successkey) = mockVault.getReceiptLogs(key, limit);
    return Future.value(TableSegment(records, successkey));
  }

  @override
  void dispose() {
    chartSink.close();
    temporaryTicketSink.close();
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
  late final Sink<ReceiptLogSchemeInstance?> firstRecordSink;
  Stream<int?> get firstKey => firstRecordStream.map((record) => record?.id);
  // </valut fields>
  MockReceiptLogVault() {
    // <mock receipt logs>
    receiptLogs = [
      for (var i = 0; i < 20; i++)
        ReceiptLogSchemeInstance(
            id: i,
            price: const PriceConfig(
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
    firstRecordStream = firstRecordStreamController.stream;
    firstRecordSink = firstRecordStreamController.sink;
    firstRecordSink.add(receiptLogs.firstOrNull);
    // </initialize stream>
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
            price: PriceConfig(
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
      firstRecordSink.add(receiptLogs.firstOrNull);
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
            confirmed: logContent.confirmed))
        .toList();
  }

  /// returns a list of streams of receipt logs and a stream of the key for the next record.
  (List<Stream<ReceiptLogSchemeInstance?>>, Stream<int?>) getReceiptLogs(
      int key, int limit) {
    // records to be returned
    final records = receiptLogs.where((log) => log.id >= key).take(limit);
    // wrap the records with stream
    final recordsBox = records.map((record) {
      final stream = StreamController<ReceiptLogSchemeInstance?>();
      stream.add(record); // the stream is fed with the record at this point.

      // the stream tracks the updates of the receipt logs.
      receiptLogsStream.listen((logs) {
        ReceiptLogSchemeInstance? newRecord =
            logs.where((log) => record.id == log.id).firstOrNull;
        stream.add(newRecord);
      });

      return stream.stream;
    });
    // success key can be changed when new record is added/deleted
    final successKeyBox = StreamController<int?>();
    // listen to the updates of the receipt logs and find the new key on each update.
    receiptLogsStream.listen((logs) {
      if (logs.isEmpty) {
        successKeyBox.add(null);
        return;
      }
      final newKey =
          logs.where((log) => log.id > records.last.id).firstOrNull?.id;
      successKeyBox.add(newKey);
    });

    return (recordsBox.toList(), successKeyBox.stream);
  }

  void dispose() {
    receiptLogsSink.close();
    firstRecordSink.close();
  }
}
// </mock>
