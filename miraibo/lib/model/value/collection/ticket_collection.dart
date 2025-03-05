import 'package:miraibo/model/entity/estimation_scheme.dart';
import 'package:miraibo/model/entity/monitor_scheme.dart';
import 'package:miraibo/model/entity/plan.dart';
import 'package:miraibo/model/entity/receipt_log.dart';
import 'package:miraibo/model/value/collection/category_collection.dart';
import 'package:miraibo/model/value/date.dart';
import 'package:miraibo/model/value/period.dart';
import 'package:miraibo/model/repository/primitive.dart';

class TicketCollection {
  static final PlanRepository _planRepository = PlanRepository.instance;
  static final ReceiptLogRepository _receiptLogRepository =
      ReceiptLogRepository.instance;
  static final EstimationSchemeRepository _estimationSchemeRepository =
      EstimationSchemeRepository.instance;
  static final MonitorSchemeRepository _monitorSchemeRepository =
      MonitorSchemeRepository.instance;

  final List<Plan> plans;
  final List<ReceiptLog> receiptLogs;
  final List<EstimationScheme> estimationSchemes;
  final List<MonitorScheme> monitorSchemes;

  TicketCollection({
    this.plans = const [],
    this.receiptLogs = const [],
    this.estimationSchemes = const [],
    this.monitorSchemes = const [],
  });

  static Future<TicketCollection> ticketsOn(Date date) async {
    final plans = _planRepository.get(
        Period.singleDay(date), CategoryCollection.phantomAll);
    final receiptLogs = _receiptLogRepository.get(
        Period.singleDay(date), CategoryCollection.phantomAll);
    final estimationSchemes = _estimationSchemeRepository.get(
        Period.singleDay(date), CategoryCollection.phantomAll);
    final monitorSchemes = _monitorSchemeRepository.get(
        Period.singleDay(date), CategoryCollection.phantomAll);
    return TicketCollection(
      plans: await plans.toList(),
      receiptLogs: await receiptLogs.toList(),
      estimationSchemes: await estimationSchemes.toList(),
      monitorSchemes: await monitorSchemes.toList(),
    );
  }

  static Future<TicketCollection> ticketsForToday() async {
    final today = Date.today();
    final monitors = _monitorSchemeRepository.get(
        Period.singleDay(today), CategoryCollection.phantomAll);
    final confirmedReceiptLogsOfRecentDays = _receiptLogRepository.get(
        Period.recentDays(), CategoryCollection.phantomAll,
        confirmed: true);
    final unconfirmedReceiptLogs = _receiptLogRepository.get(
        Period.entirePeriod, CategoryCollection.phantomAll,
        confirmed: false);
    final receiptLogs = await unconfirmedReceiptLogs.toList();
    await for (final log in confirmedReceiptLogsOfRecentDays) {
      receiptLogs.add(log);
    }
    return TicketCollection(
      monitorSchemes: await monitors.toList(),
      receiptLogs: receiptLogs,
    );
  }
}
