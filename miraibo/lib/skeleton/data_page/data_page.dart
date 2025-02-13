import 'dart:async';

import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/skeleton/data_page/operation_windows.dart';
import 'package:miraibo/skeleton/data_page/receipt_log_edit_window.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/chart_configuration_window.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket_config_window/temporary_ticket_config_window.dart';

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
typedef TableRecord = Stream<ReceiptLogScheme?>;

class TableSegment {
  /// success key is provided from stream.
  /// if there is no segment to fetch, the success key is null.
  final Stream<int?> successKey;

  /// record is a stream of receipt log configs.
  /// it reflects the mutation of the receipt logs.
  /// the stream for each record emits null the record is no longer exists.
  /// the stream for bunch of records emits null when all of the records are no longer exists.
  late final Stream<List<TableRecord>?> records;

  /// when the record is null, the null count is incremented.
  /// when [nullCount] gets equal to the length of the [_records], the segment is no longer needed.
  int nullCount = 0;

  TableSegment(List<TableRecord> records, this.successKey) {
    StreamController<List<TableRecord>?> recordsStream = StreamController();
    int numberOfRecords = records.length;
    for (var record in records) {
      record.asBroadcastStream().listen((record) {
        if (record != null) return;
        nullCount++;
        if (nullCount >= numberOfRecords) {
          recordsStream.add(null);
        }
      });
    }
    recordsStream.add(records);
    this.records = recordsStream.stream;
  }
}

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

sealed class TemporaryTicket {
  const TemporaryTicket();
}

class TemporaryEstimationTicket extends TemporaryTicket {
  final OpenPeriod period;
  final Price price;
  final EstimationDisplayConfig displayConfig;

  /// empty when all categories are counted.
  final List<String> categoryNames;

  const TemporaryEstimationTicket(
      {required this.period,
      required this.price,
      required this.displayConfig,
      required this.categoryNames});
}

class TemporaryMonitorTicket extends TemporaryTicket {
  final OpenPeriod period;
  final Price price;
  final MonitorDisplayConfig displayConfig;

  /// empty when all categories are counted.
  final List<String> categoryNames;

  const TemporaryMonitorTicket(
      {required this.period,
      required this.price,
      required this.displayConfig,
      required this.categoryNames});
}

class TemporaryTicketUnspecified extends TemporaryTicket {}

// </view model>

// <mock>
class MockDataPage implements DataPage {
  StreamController<ChartScheme> chartStream = StreamController();

  late ChartScheme _currentChartScheme;
  @override
  ChartScheme get currentChartScheme => _currentChartScheme;
  @override
  set currentChartScheme(ChartScheme scheme) {
    _currentChartScheme = scheme;
    chartStream.add(scheme);
  }

  void setChartScheme(ChartScheme scheme) {
    currentChartScheme = scheme;
  }

  StreamController<TemporaryTicketScheme> temporaryTicketStream =
      StreamController();

  late TemporaryTicketScheme _currentTicketScheme;
  @override
  TemporaryTicketScheme get currentTicketScheme => _currentTicketScheme;
  @override
  set currentTicketScheme(TemporaryTicketScheme scheme) {
    _currentTicketScheme = scheme;
    temporaryTicketStream.add(scheme);
  }

  void setTicketScheme(TemporaryTicketScheme scheme) {
    currentTicketScheme = scheme;
  }

  final MockReceiptLogVault mockVault = MockReceiptLogVault();

  MockDataPage() {
    currentChartScheme = const ChartSchemeUnspecified();
    currentTicketScheme = const TemporaryTicketSchemeUnspecified();
  }

  @override
  Stream<Chart> getChart() {
    var now = DateTime.now();
    var twoWeeksAgo = now.subtract(const Duration(days: 14));
    var twoWeeksLater = now.add(const Duration(days: 14));
    var thisMonth = Date(now.year, now.month, 1);
    var period = ClosedPeriod(
        begins: Date(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day),
        ends: Date(twoWeeksLater.year, twoWeeksLater.month, twoWeeksLater.day));
    return chartStream.stream.map((scheme) {
      switch (scheme) {
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
        default:
          throw Exception('Illegal chart scheme');
      }
    });
  }

  @override
  Stream<TemporaryTicket> getTemporaryTicket() {
    var period = const OpenPeriod(begins: null, ends: null);
    var price = const Price(amount: 1000, symbol: 'JPY');
    return temporaryTicketStream.stream.map((scheme) {
      switch (scheme) {
        case TemporaryEstimationTicket _:
          return TemporaryEstimationTicket(
              period: period,
              price: price,
              displayConfig: EstimationDisplayConfig.perDay,
              categoryNames: []);
        case TemporaryMonitorTicket _:
          return TemporaryMonitorTicket(
              period: period,
              price: price,
              displayConfig: MonitorDisplayConfig.meanInDays,
              categoryNames: []);
        case TemporaryTicketUnspecified _:
          return TemporaryTicketUnspecified();
        default:
          throw Exception('Illegal ticket scheme');
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
    var (records, successkey) = mockVault.getReceiptLogs(key, limit);
    return Future.value(TableSegment(records, successkey));
  }
}

class MockReceiptLogVault {
  late final List<ReceiptLogScheme> receiptLogs;
  final StreamController<List<ReceiptLogScheme>> receiptLogsStream =
      StreamController();
  final StreamController<ReceiptLogScheme?> firstRecordStream =
      StreamController();
  Stream<int?> get firstKey =>
      firstRecordStream.stream.map((record) => record?.id);
  MockReceiptLogVault() {
    receiptLogs = [
      for (var i = 0; i < 20; i++)
        ReceiptLogScheme(
            id: i,
            price: const PriceConfig(
                amount: 1000, currencySymbol: 'JPY', currencyId: 0),
            date: Date(2021, 1, i + 1),
            category: const Category(id: 0, name: 'category0'),
            description: 'this is a receipt log',
            confirmed: false)
    ];
    receiptLogsStream.add(receiptLogs);
    firstRecordStream.add(receiptLogs.firstOrNull);
  }
  Sink<List<Ticket>> get ticketsSink {
    var ticketSink = StreamController<List<Ticket>>();
    ticketSink.stream.listen((tickets) {
      var newLogs = <ReceiptLogScheme>[];
      for (var ticket in tickets) {
        if (ticket is! ReceiptLogTicket) continue;
        var log = ReceiptLogScheme(
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
      receiptLogs.clear();
      receiptLogs.addAll(newLogs);
      receiptLogsStream.add(receiptLogs);
      firstRecordStream.add(receiptLogs.firstOrNull);
    });
    return ticketSink.sink;
  }

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
  (List<Stream<ReceiptLogScheme?>>, Stream<int?>) getReceiptLogs(
      int key, int limit) {
    var records = receiptLogs.where((log) => log.id >= key).take(limit);
    var recordsBox = records.map((log) {
      var stream = StreamController<ReceiptLogScheme?>();
      stream.add(log);

      receiptLogsStream.stream.asBroadcastStream().listen((logs) {
        ReceiptLogScheme? newLog =
            logs.where((log) => log.id == log.id).firstOrNull;
        stream.add(newLog);
      });

      return stream.stream;
    });
    var successKeyBox = StreamController<int?>();
    receiptLogsStream.stream.asBroadcastStream().listen((logs) {
      if (logs.isEmpty) {
        successKeyBox.add(null);
        return;
      }
      var newKey = logs
          .where((log) => log.id > records.last.id)
          .map((log) => log.id)
          .firstOrNull;
      successKeyBox.add(newKey);
    });

    return (recordsBox.toList(), successKeyBox.stream);
  }
}
// </mock>