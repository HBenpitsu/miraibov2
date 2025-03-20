import 'dart:async';

import 'package:logger/logger.dart';
import 'package:miraibo/skeleton/root.dart';
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/shared/enumeration.dart';
import 'package:miraibo/isolate_glue/isolate_glue.dart' as model;

void dispatchEvents() async {
  await model.initializeApp();
  await model.instanciateScheduleUntilToday();
  await model.autoConfirmIgnoredReceiptLogs();
  Timer.periodic(Duration(seconds: 5), (_) async {
    await model.instanciateScheduleUntilToday();
    await model.autoConfirmIgnoredReceiptLogs();
    ticketMutationNotifier.add(null);
  });
}

final ticketMutationNotifier = StreamController<void>.broadcast();

class RootImpl implements Root {
  @override
  PlanningPage get planningPage => PlanningPageImpl();

  @override
  MainPage get mainPage => MainPageImpl();

  @override
  DataPage get dataPage => DataPageImpl();

  @override
  UtilsPage get utilsPage => UtilsPageImpl();

  @override
  void dispose() {}
}

class PlanningPageImpl implements PlanningPage {
  @override
  MonthlyScreen showInitialScreen() {
    final now = DateTime.now();
    return MonthlyScreenImpl(now.cutOffTime());
  }

  @override
  void dispose() {}
}

class MonthlyScreenImpl implements MonthlyScreen {
  @override
  final Date initiallyCenteredDate;

  MonthlyScreenImpl(this.initiallyCenteredDate);

  Future<List<EventExistence>> calenderEvents(int year, int month) async {
    final buffer = <EventExistence>[];
    for (var cur = DateTime(year, month, 1);
        cur.month == month;
        cur = cur.add(const Duration(days: 1))) {
      final existence = await model.fetchEventExistenceOn(cur.cutOffTime());
      buffer.add(existence);
    }
    return buffer;
  }

  @override
  Calender getCalender(int index) {
    final target = DateTime(
      initiallyCenteredDate.year,
      initiallyCenteredDate.month + index,
    );
    final lastDayOfTheMonth = DateTime(target.year, target.month + 1, 0);
    return Calender(
      target.year,
      target.month,
      lastDayOfTheMonth.day,
      target.weekday % 7,
      () async => calenderEvents(target.year, target.month),
    );
  }

  @override
  DailyScreen navigateToDailyScreen(int year, int month, int day) {
    return DailyScreenImpl(Date(year, month, day));
  }

  @override
  void dispose() {}
}

class DailyScreenImpl implements DailyScreen {
  @override
  final Date initiallyCenteredDate;
  @override
  int offset = 0;

  DailyScreenImpl(this.initiallyCenteredDate);

  Sink<Date>? labelSink;

  @override
  Stream<Date> getLabel() {
    labelSink?.close();
    final controller = StreamController<Date>();
    labelSink = controller.sink;
    controller.add(initiallyCenteredDate);
    return controller.stream;
  }

  @override
  Stream<List<Ticket>> getTicketsOn(int index) async* {
    final target = initiallyCenteredDate.asDateTime().add(
          Duration(days: index),
        );
    yield await model.fetchTicketsOn(target.cutOffTime());
    await for (final _ in ticketMutationNotifier.stream) {
      yield await model.fetchTicketsOn(target.cutOffTime());
    }
  }

  @override
  Future<void> setOffset(int offset) async {
    this.offset = offset;
    labelSink?.add(
      initiallyCenteredDate
          .asDateTime()
          .add(Duration(days: offset))
          .cutOffTime(),
    );
  }

  @override
  MonthlyScreen navigateToMonthlyScreen() {
    return MonthlyScreenImpl(
      initiallyCenteredDate
          .asDateTime()
          .add(Duration(days: offset))
          .cutOffTime(),
    );
  }

  @override
  EstimationSchemeEditWindow openEstimationSchemeEditWindow(
    int targetTicketId,
  ) {
    return EstimationSchemeEditWindowImpl(targetTicketId);
  }

  @override
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId) {
    return MonitorSchemeEditWindowImpl(targetTicketId);
  }

  @override
  PlanEditWindow openPlanEditWindow(int targetTicketId) {
    return PlanEditWindowImpl(targetTicketId);
  }

  @override
  ReceiptLogConfirmationWindow openReceiptLogConfirmationWindow(
    int targetTicketId,
  ) {
    return ReceiptLogConfirmationWindowImpl(targetTicketId);
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId) {
    return ReceiptLogEditWindowImpl(targetTicketId);
  }

  @override
  TicketCreateWindow openTicketCreateWindow() {
    return TicketCreateWindowImpl(
      initiallyCenteredDate
          .asDateTime()
          .add(Duration(days: offset))
          .cutOffTime(),
    );
  }

  @override
  void dispose() {}
}

class EstimationSchemeEditWindowImpl implements EstimationSchemeEditWindow {
  @override
  final int targetSchemeId;

  EstimationSchemeEditWindowImpl(this.targetSchemeId);

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<void> deleteEstimationScheme() async {
    await model.deleteEstimationScheme(targetSchemeId);
    ticketMutationNotifier.add(null);
  }

  @override
  Future<void> updateEstimationScheme({
    required int categoryId,
    required OpenPeriod period,
    required EstimationDisplayOption displayOption,
    required int currencyId,
  }) async {
    await model.editEstimationScheme(
      id: targetSchemeId,
      period: period,
      displayOption: displayOption,
      categoryId: categoryId,
      currencyId: currencyId,
    );
    ticketMutationNotifier.add(null);
  }

  @override
  Future<EstimationScheme> getOriginalEstimationScheme() {
    return model.fetchEstimationScheme(targetSchemeId);
  }

  @override
  void dispose() {}
}

class MonitorSchemeEditWindowImpl implements MonitorSchemeEditWindow {
  @override
  final int targetTicketId;

  MonitorSchemeEditWindowImpl(this.targetTicketId);

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<MonitorScheme> getOriginalMonitorScheme() {
    return model.fetchMonitorScheme(targetTicketId);
  }

  @override
  Future<void> updateMonitorScheme({
    required List<int> categoryIds,
    required bool isAllCategoriesIncluded,
    required OpenPeriod period,
    required MonitorDisplayOption displayOption,
    required int currencyId,
  }) async {
    await model.editMonitorScheme(
      targetTicketId,
      period,
      isAllCategoriesIncluded ? [] : categoryIds,
      displayOption,
      currencyId,
    );
    ticketMutationNotifier.add(null);
  }

  @override
  Future<void> deleteMonitorScheme() async {
    await model.deleteMonitorScheme(targetTicketId);
    ticketMutationNotifier.add(null);
  }

  @override
  void dispose() {}
}

class PlanEditWindowImpl implements PlanEditWindow {
  @override
  final int targetPlanId;

  PlanEditWindowImpl(this.targetPlanId);

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<PlanScheme> getOriginalPlan() {
    return model.fetchPlanScheme(targetPlanId);
  }

  @override
  Future<void> updatePlan({
    required int categoryId,
    required String description,
    required int amount,
    required int currencyId,
    required Schedule schedule,
  }) async {
    await model.editPlan(
      id: targetPlanId,
      categoryId: categoryId,
      description: description,
      amount: amount,
      currencyId: currencyId,
      schedule: schedule,
    );
    ticketMutationNotifier.add(null);
  }

  @override
  Future<void> deletePlan() async {
    await model.deletePlan(targetPlanId);
    ticketMutationNotifier.add(null);
  }

  @override
  void dispose() {}
}

class ReceiptLogConfirmationWindowImpl implements ReceiptLogConfirmationWindow {
  @override
  final int targetReceiptLogId;

  ReceiptLogConfirmationWindowImpl(this.targetReceiptLogId);

  @override
  Future<void> confirmReceiptLog() async {
    final original = await model.fetchReceiptLogScheme(targetReceiptLogId);
    await model.editReceiptLog(
      id: targetReceiptLogId,
      originDate: original.date,
      amount: original.price.amount,
      currencyId: original.price.currencyId,
      categoryId: original.category.id,
      description: original.description,
      confirmed: original.confirmed,
    );
    ticketMutationNotifier.add(null);
  }

  @override
  Future<ReceiptLogTicket> getLogContent() async {
    final originalScheme = await model.fetchReceiptLogScheme(
      targetReceiptLogId,
    );
    return ReceiptLogTicket(
      id: targetReceiptLogId,
      categoryName: originalScheme.category.name,
      description: originalScheme.description,
      price: Price(
        amount: originalScheme.price.amount,
        symbol: originalScheme.price.currencySymbol,
      ),
      date: originalScheme.date,
      confirmed: originalScheme.confirmed,
    );
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow() {
    return ReceiptLogEditWindowImpl(targetReceiptLogId);
  }

  @override
  void dispose() {}
}

class ReceiptLogEditWindowImpl implements ReceiptLogEditWindow {
  @override
  final int targetLogId;

  ReceiptLogEditWindowImpl(this.targetLogId);

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<void> updateReceiptLog({
    required int categoryId,
    required String description,
    required int amount,
    required int currencyId,
    required Date date,
  }) async {
    await model.editReceiptLog(
      id: targetLogId,
      categoryId: categoryId,
      description: description,
      amount: amount,
      currencyId: currencyId,
      originDate: date,
      confirmed: true,
    );
    ticketMutationNotifier.add(null);
  }

  @override
  Future<void> deleteReceiptLog() async {
    await model.deleteReceiptLog(targetLogId);
    ticketMutationNotifier.add(null);
  }

  @override
  Future<ReceiptLogScheme> getOriginalReceiptLog() {
    return model.fetchReceiptLogScheme(targetLogId);
  }

  @override
  void dispose() {}
}

class TicketCreateWindowImpl implements TicketCreateWindow {
  @override
  EstimationSchemeSection get estimationSchemeSection =>
      EstimationSchemeSectionImpl(axisDate);

  @override
  MonitorSchemeSection get monitorSchemeSection =>
      MonitorSchemeSectionImpl(axisDate);

  @override
  PlanSection get planSection => PlanSectionImpl(axisDate);

  @override
  ReceiptLogSection get receiptLogSection => ReceiptLogSectionImpl(axisDate);

  final model.Date axisDate;
  TicketCreateWindowImpl(this.axisDate);

  @override
  void dispose() {}
}

class EstimationSchemeSectionImpl implements EstimationSchemeSection {
  final model.Date axisDate;
  EstimationSchemeSectionImpl(this.axisDate);

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<void> createEstimationScheme({
    required int categoryId,
    required OpenPeriod period,
    required EstimationDisplayOption displayOption,
    required int currencyId,
  }) async {
    await model.createEstimationScheme(
      categoryId: categoryId,
      period: period,
      displayOption: displayOption,
      currencyId: currencyId,
    );
    ticketMutationNotifier.add(null);
  }

  @override
  Future<EstimationScheme> getInitialScheme() async {
    final currency = await model.fetchDefaultCurrency();
    final recentLog = await model.fetchLoggedReceiptRecord(0).first;
    final Category category;
    if (recentLog == null) {
      category = (await model.fetchAllCategories()).first;
    } else {
      category = recentLog.category;
    }
    return EstimationScheme(
      period: OpenPeriod(begins: axisDate, ends: null),
      currency: currency,
      displayOption: EstimationDisplayOption.perDay,
      category: category,
    );
  }

  @override
  void dispose() {}
}

class MonitorSchemeSectionImpl implements MonitorSchemeSection {
  final model.Date axisDate;
  MonitorSchemeSectionImpl(this.axisDate);

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<void> createMonitorScheme({
    required List<int> categoryIds,
    required bool isAllCategoriesIncluded,
    required OpenPeriod period,
    required MonitorDisplayOption displayOption,
    required int currencyId,
  }) async {
    await model.createMonitorScheme(
      period,
      isAllCategoriesIncluded ? [] : categoryIds,
      displayOption,
      currencyId,
    );
    ticketMutationNotifier.add(null);
  }

  @override
  Future<MonitorScheme> getInitialScheme() async {
    return MonitorScheme(
      period: OpenPeriod(begins: axisDate, ends: axisDate),
      currency: await model.fetchDefaultCurrency(),
      displayOption: MonitorDisplayOption.summation,
      categories: [],
      isAllCategoriesIncluded: true,
    );
  }

  @override
  void dispose() {}
}

class ReceiptLogSectionImpl implements ReceiptLogSection {
  final model.Date axisDate;
  ReceiptLogSectionImpl(this.axisDate);

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<void> createReceiptLog({
    required int categoryId,
    required String description,
    required int amount,
    required int currencyId,
    required Date date,
  }) async {
    await model.createReceiptLog(
      categoryId: categoryId,
      description: description,
      amount: amount,
      currencyId: currencyId,
      originDate: date,
      confirmed: true,
    );
    ticketMutationNotifier.add(null);
  }

  @override
  Future<ReceiptLogScheme> getInitialScheme() async {
    final Category category;
    final recentLog = await model.fetchLoggedReceiptRecord(0).first;
    if (recentLog == null) {
      category = (await model.fetchAllCategories()).first;
    } else {
      category = recentLog.category;
    }
    final currency = await model.fetchDefaultCurrency();
    return ReceiptLogScheme(
      date: axisDate,
      price: ConfigureblePrice(
        amount: 0,
        currencyId: currency.id,
        currencySymbol: currency.symbol,
      ),
      description: '',
      category: category,
      confirmed: true,
    );
  }

  @override
  Future<List<ReceiptLogSchemePreset>> getPresets() async {
    final buffer = <ReceiptLogSchemePreset>[];
    for (var i = 0; i < 5; i++) {
      final recentLog = await model.fetchLoggedReceiptRecord(i).first;
      if (recentLog == null) return buffer;
      buffer.add(
        ReceiptLogSchemePreset(
          price: ConfigureblePrice(
            amount: recentLog.price.amount,
            currencyId: recentLog.price.currencyId,
            currencySymbol: recentLog.price.currencySymbol,
          ),
          description: recentLog.description,
          category: recentLog.category,
        ),
      );
    }
    return buffer;
  }

  @override
  void dispose() {}
}

class PlanSectionImpl implements PlanSection {
  final model.Date axisDate;
  PlanSectionImpl(this.axisDate);

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<void> createPlan({
    required int categoryId,
    required String description,
    required int amount,
    required int currencyId,
    required Schedule schedule,
  }) async {
    await model.createPlan(
      categoryId: categoryId,
      description: description,
      amount: amount,
      currencyId: currencyId,
      schedule: schedule,
    );
    ticketMutationNotifier.add(null);
  }

  @override
  Future<PlanScheme> getInitialScheme() async {
    final currency = await model.fetchDefaultCurrency();
    final category = (await model.fetchAllCategories()).first;
    return PlanScheme(
      schedule: OneshotSchedule(date: axisDate),
      price: ConfigureblePrice(
        amount: 0,
        currencyId: currency.id,
        currencySymbol: currency.symbol,
      ),
      description: '',
      category: category,
    );
  }

  @override
  void dispose() {}
}

class MainPageImpl implements MainPage {
  @override
  Date get today {
    final now = DateTime.now();
    return Date(now.year, now.year, now.year);
  }

  @override
  Stream<List<Ticket>> getTickets() async* {
    yield await model.fetchReceiptLogsAndMonitorsForToday();
    await for (final _ in ticketMutationNotifier.stream) {
      yield await model.fetchReceiptLogsAndMonitorsForToday();
    }
  }

  @override
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId) {
    return MonitorSchemeEditWindowImpl(targetTicketId);
  }

  @override
  ReceiptLogConfirmationWindow openReceiptLogConfirmationWindow(
    int targetTicketId,
  ) {
    return ReceiptLogConfirmationWindowImpl(targetTicketId);
  }

  @override
  ReceiptLogCreateWindow openReceiptLogCreateWindow() {
    return ReceiptLogCreateWindowImpl();
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId) {
    return ReceiptLogEditWindowImpl(targetTicketId);
  }

  @override
  void dispose() {}
}

class ReceiptLogCreateWindowImpl implements ReceiptLogCreateWindow {
  @override
  Future<void> createReceiptLog({
    required int categoryId,
    required String description,
    required int amount,
    required int currencyId,
    required Date date,
  }) async {
    await model.createReceiptLog(
      categoryId: categoryId,
      description: description,
      amount: amount,
      currencyId: currencyId,
      originDate: date,
      confirmed: true,
    );
    ticketMutationNotifier.add(null);
  }

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<ReceiptLogScheme> getInitialScheme() async {
    final Category category;
    final recentLog = await model.fetchLoggedReceiptRecord(0).first;
    if (recentLog == null) {
      category = (await model.fetchAllCategories()).first;
    } else {
      category = recentLog.category;
    }
    final currency = await model.fetchDefaultCurrency();
    final now = DateTime.now();
    return ReceiptLogScheme(
      date: Date(now.year, now.month, now.day),
      price: ConfigureblePrice(
        amount: 0,
        currencyId: currency.id,
        currencySymbol: currency.symbol,
      ),
      description: '',
      category: category,
      confirmed: true,
    );
  }

  @override
  Future<List<ReceiptLogSchemePreset>> getPresets() async {
    final buffer = <ReceiptLogSchemePreset>[];
    for (var i = 0; i < 5; i++) {
      final recentLog = await model.fetchLoggedReceiptRecord(i).first;
      if (recentLog == null) return buffer;
      buffer.add(
        ReceiptLogSchemePreset(
          price: ConfigureblePrice(
            amount: recentLog.price.amount,
            currencyId: recentLog.price.currencyId,
            currencySymbol: recentLog.price.currencySymbol,
          ),
          description: recentLog.description,
          category: recentLog.category,
        ),
      );
    }
    return buffer;
  }

  @override
  void dispose() {}
}

final chartSchemeMutationNotifier = StreamController<void>.broadcast();
final temporaryTicketMutationNotifier = StreamController<void>.broadcast();
final tableMutationNotifier = StreamController<void>.broadcast();

class DataPageImpl implements DataPage {
  @override
  ChartScheme currentChartScheme = ChartSchemeUnspecified();
  void chartSchemeSetter(ChartScheme value) {
    currentChartScheme = value;
    chartSchemeMutationNotifier.add(null);
  }

  @override
  TemporaryTicketScheme currentTicketScheme =
      TemporaryTicketSchemeUnspecified();
  void ticketSchemeSetter(TemporaryTicketScheme value) {
    currentTicketScheme = value;
    temporaryTicketMutationNotifier.add(null);
  }

  makeChartFromScheme() async {
    switch (currentChartScheme) {
      case ChartSchemeUnspecified _:
        return ChartUnspecified();
      case SubtotalChartScheme scheme:
        final bars = await model.getValuesOfSubtotalChart(
          scheme.currency.id,
          scheme.viewportRange,
          scheme.categories.map((e) => e.id).toList(),
          scheme.intervalInDays,
        );
        final now = DateTime.now();
        int todaysIndex = 0;
        double max = double.negativeInfinity;
        for (final (index, bar) in bars.indexed) {
          if (bar.amount > max) {
            max = bar.amount;
          }
          if (bar.date.year == now.year &&
              bar.date.month == now.month &&
              bar.date.day <= now.day) {
            todaysIndex = index;
          }
        }
        //表示七本まで拡大できるように設定
        double maxScale = bars.length / 7;
        if (maxScale < 1) {
          maxScale = 1;
        }
        return SubtotalChart(
          currencySymbol: scheme.currency.symbol,
          categoryNames: scheme.categories.map((e) => e.name).toList(),
          viewportRange: scheme.viewportRange,
          bars: bars,
          intervalInDays: scheme.intervalInDays,
          yAxisExtent: max == double.negativeInfinity ? 0 : max.ceil(),
          maxScale: maxScale,
          todaysIndex: todaysIndex,
        );
      case AccumulationChartScheme scheme:
        final bars = await model.getValuesOfAccumulationChart(
          scheme.currency.id,
          scheme.analysisRange,
          scheme.viewportRange,
          scheme.categories.map((e) => e.id).toList(),
          scheme.intervalInDays,
        );
        final now = DateTime.now();
        double max = double.negativeInfinity;
        int todaysIndex = 0;
        for (final (index, bar) in bars.indexed) {
          if (bar.amount > max) {
            max = bar.amount;
          }
          if (bar.date.year == now.year &&
              bar.date.month == now.month &&
              bar.date.day <= now.day) {
            todaysIndex = index;
          }
        }
        //表示七本まで拡大できるように設定
        double maxScale = bars.length / 7;
        if (maxScale < 1) {
          maxScale = 1;
        }
        return AccumulationChart(
          categoryNames: scheme.categories.map((e) => e.name).toList(),
          currencySymbol: scheme.currency.symbol,
          bars: bars,
          viewportRange: scheme.viewportRange,
          analysisRange: scheme.analysisRange,
          yAxisExtent: max == double.negativeInfinity ? 0 : max.ceil(),
          maxScale: maxScale,
          todaysIndex: todaysIndex,
        );
      case PieChartScheme scheme:
        final values = await model.getValuesOfPieChart(
          scheme.currency.id,
          scheme.analysisRange,
          scheme.categories.map((e) => e.id).toList(),
        );
        final gross = values.fold(
          0.0,
          (previousValue, element) => previousValue + element.amount,
        );
        return PieChart(
          currencySymbol: scheme.currency.symbol,
          chips: values,
          gross: gross,
          analysisRange: scheme.analysisRange,
        );
    }
  }

  @override
  Stream<Chart> getChart() async* {
    yield await makeChartFromScheme();
    await for (final _ in chartSchemeMutationNotifier.stream) {
      yield await makeChartFromScheme();
    }
  }

  @override
  Stream<ReceiptLogSchemeInstance?> getReceiptLog(int index) {
    return model.fetchLoggedReceiptRecord(index);
  }

  @override
  Stream<int> getTableSize() async* {
    yield* model.receiptLogCount();
    await for (final _ in tableMutationNotifier.stream) {
      yield* model.receiptLogCount();
    }
  }

  Future<TemporaryTicket> makeTemporaryTicket() async {
    final scheme = currentTicketScheme;
    switch (scheme) {
      case TemporaryTicketSchemeUnspecified _:
        return TemporaryTicketUnspecified();
      case TemporaryEstimationScheme scheme:
        final estimatedValue = await model.estimateWithScheme(
          scheme.category.id,
          scheme.currency.id,
          scheme.displayOption,
        );
        return TemporaryEstimationTicket(
          period: estimatedValue.period,
          price: estimatedValue.price,
          displayOption: estimatedValue.displayOption,
          categoryName: estimatedValue.categoryName,
        );
      case TemporaryMonitorScheme scheme:
        final monitor = await model.monitorWithScheme(
          scheme.period,
          scheme.categories.map((e) => e.id).toList(),
          scheme.displayOption,
          scheme.currency.id,
        );
        return TemporaryMonitorTicket(
          period: monitor.period,
          price: monitor.price,
          displayOption: monitor.displayOption,
          categoryNames: monitor.categoryNames,
        );
    }
  }

  @override
  Stream<TemporaryTicket> getTemporaryTicket() async* {
    yield await makeTemporaryTicket();
    await for (final _ in temporaryTicketMutationNotifier.stream) {
      yield await makeTemporaryTicket();
    }
  }

  @override
  ChartConfigurationWindow openChartConfigurationWindow() {
    return ChartConfigurationWindowImpl(currentChartScheme, chartSchemeSetter);
  }

  @override
  TemporaryTicketConfigWindow openTemporaryTicketConfigWindow() {
    return TemporaryTicketConfigWindowImpl(
      currentTicketScheme,
      ticketSchemeSetter,
    );
  }

  @override
  BackupWindow openBackupWindow() {
    return BackupWindowImpl();
  }

  @override
  ExportationWindow openExportationWindow() {
    return ExportationWindowImpl();
  }

  @override
  ImportationWindow openImportationWindow() {
    return ImportationWindowImpl();
  }

  @override
  OverwriteWindow openOverwriteWindow() {
    return OverwriteWindowImpl();
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetReceiptLogId) {
    return ReceiptLogEditWindowImpl(targetReceiptLogId);
  }

  @override
  RestoreWindow openRestoreWindow() {
    return RestoreWindowImpl();
  }

  @override
  void dispose() {}
}

class ChartConfigurationWindowImpl implements ChartConfigurationWindow {
  @override
  final ChartScheme initialScheme;
  final void Function(ChartScheme) chartSchemeSetter;
  ChartConfigurationWindowImpl(this.initialScheme, this.chartSchemeSetter);

  @override
  set currentScheme(ChartScheme value) {
    chartSchemeSetter(value);
  }

  @override
  Future<ChartScheme> getInitialScheme() async {
    return initialScheme;
  }

  @override
  PieChartSection get pieChartSection =>
      PieChartSectionImpl(initialScheme, chartSchemeSetter);
  @override
  AccumulationChartSection get accumulationChartSection =>
      AccumulationChartSectionImpl(initialScheme, chartSchemeSetter);
  @override
  SubtotalChartSection get subtotalChartSection =>
      SubtotalChartSectionImpl(initialScheme, chartSchemeSetter);

  @override
  void dispose() {}
}

class PieChartSectionImpl implements PieChartSection {
  @override
  final ChartScheme initialScheme;
  @override
  set currentScheme(ChartScheme value) {
    chartSchemeSetter(value);
  }

  final void Function(ChartScheme) chartSchemeSetter;
  PieChartSectionImpl(this.initialScheme, this.chartSchemeSetter);

  @override
  Future<void> applyScheme(
    int currencyId,
    OpenPeriod analysisRange,
    List<int> categoryIds,
    bool isAllCategoriesIncluded,
  ) async {
    final currencies = await model.fetchAllCurrencies();
    final categories = await model.fetchAllCategories();
    currentScheme = PieChartScheme(
      currency: currencies.firstWhere((e) => e.id == currencyId),
      analysisRange: analysisRange,
      categories: categories.where((e) => categoryIds.contains(e.id)).toList(),
      isAllCategoriesIncluded: isAllCategoriesIncluded,
    );
  }

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<PieChartScheme> getInitialScheme() async {
    if (initialScheme is PieChartScheme) {
      return initialScheme as PieChartScheme;
    }
    return PieChartScheme(
      currency: await model.fetchDefaultCurrency(),
      analysisRange: OpenPeriod(begins: null, ends: null),
      categories: [],
      isAllCategoriesIncluded: true,
    );
  }

  @override
  void dispose() {}
}

class AccumulationChartSectionImpl implements AccumulationChartSection {
  @override
  final ChartScheme initialScheme;

  @override
  set currentScheme(ChartScheme value) {
    chartSchemeSetter(value);
  }

  final void Function(ChartScheme) chartSchemeSetter;

  AccumulationChartSectionImpl(this.initialScheme, this.chartSchemeSetter);

  @override
  Future<void> applyScheme(
    int currencyId,
    OpenPeriod analysisRange,
    ClosedPeriod viewportRange,
    List<int> categoryIds,
    bool isAllCategoriesIncluded,
    int intervalInDays,
  ) async {
    final currencies = await model.fetchAllCurrencies();
    final categories = await model.fetchAllCategories();
    currentScheme = AccumulationChartScheme(
      currency: currencies.firstWhere((e) => e.id == currencyId),
      analysisRange: analysisRange,
      viewportRange: viewportRange,
      categories: categories.where((e) => categoryIds.contains(e.id)).toList(),
      isAllCategoriesIncluded: isAllCategoriesIncluded,
      intervalInDays: intervalInDays,
    );
  }

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<AccumulationChartScheme> getInitialScheme() async {
    if (initialScheme is AccumulationChartScheme) {
      return initialScheme as AccumulationChartScheme;
    }
    final now = DateTime.now();
    final today = Date(now.year, now.month, now.day);
    return AccumulationChartScheme(
      currency: await model.fetchDefaultCurrency(),
      analysisRange: OpenPeriod(begins: null, ends: null),
      viewportRange: ClosedPeriod(begins: today, ends: today),
      categories: [],
      isAllCategoriesIncluded: true,
      intervalInDays: 1,
    );
  }

  @override
  void dispose() {}
}

class SubtotalChartSectionImpl implements SubtotalChartSection {
  @override
  final ChartScheme initialScheme;

  @override
  set currentScheme(ChartScheme value) {
    chartSchemeSetter(value);
  }

  final void Function(ChartScheme) chartSchemeSetter;

  SubtotalChartSectionImpl(this.initialScheme, this.chartSchemeSetter);

  @override
  Future<void> applyScheme(
    List<int> categoryIds,
    bool isAllCategoriesIncluded,
    int currencyId,
    ClosedPeriod viewportRange,
    int intervalInDays,
  ) async {
    final currencies = await model.fetchAllCurrencies();
    final categories = await model.fetchAllCategories();
    currentScheme = SubtotalChartScheme(
      currency: currencies.firstWhere((e) => e.id == currencyId),
      viewportRange: viewportRange,
      categories: categories.where((e) => categoryIds.contains(e.id)).toList(),
      isAllCategoriesIncluded: isAllCategoriesIncluded,
      intervalInDays: intervalInDays,
    );
  }

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<SubtotalChartScheme> getInitialScheme() async {
    if (initialScheme is SubtotalChartScheme) {
      return initialScheme as SubtotalChartScheme;
    }
    final now = DateTime.now();
    final today = Date(now.year, now.month, now.day);
    return SubtotalChartScheme(
      currency: await model.fetchDefaultCurrency(),
      viewportRange: ClosedPeriod(begins: today, ends: today),
      categories: [],
      isAllCategoriesIncluded: true,
      intervalInDays: 1,
    );
  }

  @override
  void dispose() {}
}

class TemporaryTicketConfigWindowImpl implements TemporaryTicketConfigWindow {
  @override
  final TemporaryTicketScheme initialScheme;

  @override
  set currentScheme(TemporaryTicketScheme value) {
    ticketSchemeSetter(value);
  }

  final void Function(TemporaryTicketScheme) ticketSchemeSetter;
  TemporaryTicketConfigWindowImpl(this.initialScheme, this.ticketSchemeSetter);

  @override
  TemporaryEstimationSchemeSection get estimationSchemeSection =>
      TemporaryEstimationSchemeSectionImpl(initialScheme, ticketSchemeSetter);

  @override
  TemporaryMonitorSchemeSection get monitorSchemeSection =>
      TemporaryMonitorSchemeSectionImpl(initialScheme, ticketSchemeSetter);

  @override
  Future<TemporaryTicketScheme> getInitialScheme() async {
    return initialScheme;
  }

  @override
  void dispose() {}
}

class TemporaryEstimationSchemeSectionImpl
    implements TemporaryEstimationSchemeSection {
  @override
  final TemporaryTicketScheme initialScheme;

  @override
  set currentScheme(TemporaryTicketScheme value) {
    ticketSchemeSetter(value);
  }

  final void Function(TemporaryTicketScheme) ticketSchemeSetter;

  TemporaryEstimationSchemeSectionImpl(
    this.initialScheme,
    this.ticketSchemeSetter,
  );

  @override
  Future<void> applyMonitorScheme(
    int categoryId,
    OpenPeriod period,
    EstimationDisplayOption displayOption,
    int currencyId,
  ) async {
    final currencies = await model.fetchAllCurrencies();
    final categories = await model.fetchAllCategories();
    currentScheme = TemporaryEstimationScheme(
      category: categories.firstWhere((e) => e.id == categoryId),
      period: period,
      displayOption: displayOption,
      currency: currencies.firstWhere((e) => e.id == currencyId),
    );
  }

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<TemporaryEstimationScheme> getInitialScheme() async {
    if (initialScheme is TemporaryEstimationScheme) {
      return Future.value(initialScheme as TemporaryEstimationScheme);
    }
    final currency = await model.fetchDefaultCurrency();
    final category = (await model.fetchAllCategories()).first;
    return TemporaryEstimationScheme(
      category: category,
      period: OpenPeriod(begins: null, ends: null),
      displayOption: EstimationDisplayOption.perDay,
      currency: currency,
    );
  }

  @override
  void dispose() {}
}

class TemporaryMonitorSchemeSectionImpl
    implements TemporaryMonitorSchemeSection {
  @override
  final TemporaryTicketScheme initialScheme;

  @override
  set currentScheme(TemporaryTicketScheme value) {
    ticketSchemeSetter(value);
  }

  final void Function(TemporaryTicketScheme) ticketSchemeSetter;

  TemporaryMonitorSchemeSectionImpl(
    this.initialScheme,
    this.ticketSchemeSetter,
  );

  @override
  Future<void> applyMonitorScheme(
    List<int> categoryIds,
    OpenPeriod period,
    MonitorDisplayOption displayOption,
    int currencyId,
    bool isAllCategoriesIncluded,
  ) async {
    final currencies = await model.fetchAllCurrencies();
    final categories = await model.fetchAllCategories();
    currentScheme = TemporaryMonitorScheme(
      categories: categories.where((e) => categoryIds.contains(e.id)).toList(),
      period: period,
      displayOption: displayOption,
      currency: currencies.firstWhere((e) => currencyId == e.id),
      isAllCategoriesIncluded: isAllCategoriesIncluded,
    );
  }

  @override
  Future<List<Category>> getCategoryOptions() {
    return model.fetchAllCategories();
  }

  @override
  Future<List<Currency>> getCurrencyOptions() {
    return model.fetchAllCurrencies();
  }

  @override
  Future<TemporaryMonitorScheme> getInitialScheme() async {
    if (initialScheme is TemporaryMonitorScheme) {
      return Future.value(initialScheme as TemporaryMonitorScheme);
    }
    final currency = await model.fetchDefaultCurrency();
    return Future.value(
      TemporaryMonitorScheme(
        categories: [],
        period: OpenPeriod(begins: null, ends: null),
        displayOption: MonitorDisplayOption.summation,
        currency: currency,
        isAllCategoriesIncluded: true,
      ),
    );
  }

  @override
  void dispose() {}
}

class ExportationWindowImpl implements ExportationWindow {
  @override
  Future<bool> exportDataTo(String path) {
    Logger().d(path);
    return model.exportDataTo(path);
  }

  @override
  void dispose() {}
}

class BackupWindowImpl implements BackupWindow {
  @override
  Future<bool> backupDataTo(String path) {
    return model.backupDataTo(path);
  }

  @override
  void dispose() {}
}

class ImportationWindowImpl implements ImportationWindow {
  @override
  Future<bool> importDataFrom(String path) async {
    final response = await model.importDataFrom(path);
    if (response) {
      tableMutationNotifier.add(null);
      ticketMutationNotifier.add(null);
      categoryMutationNotifier.add(null);
      currencyMutationNotifier.add(null);
    }
    return response;
  }

  @override
  void dispose() {}
}

class OverwriteWindowImpl implements OverwriteWindow {
  @override
  Future<bool> overwriteDataWith(String path) async {
    final response = await model.overwriteDataWith(path);
    if (response) {
      ticketMutationNotifier.add(null);
      categoryMutationNotifier.add(null);
      currencyMutationNotifier.add(null);
    }
    return response;
  }

  @override
  void dispose() {}
}

class RestoreWindowImpl implements RestoreWindow {
  @override
  Future<bool> restoreDataFrom(String path) async {
    final response = await model.restoreDataFrom(path);
    if (response) {
      tableMutationNotifier.add(null);
      ticketMutationNotifier.add(null);
      categoryMutationNotifier.add(null);
      currencyMutationNotifier.add(null);
    }
    return response;
  }

  @override
  void dispose() {}
}

final categoryMutationNotifier = StreamController<void>.broadcast();
final currencyMutationNotifier = StreamController<void>.broadcast();

class UtilsPageImpl implements UtilsPage {
  @override
  CategorySection categorySection() async* {
    yield await model.fetchAllCategories();
    await for (final _ in categoryMutationNotifier.stream) {
      yield await model.fetchAllCategories();
    }
  }

  @override
  CurrencySection currencySection() async* {
    yield await model.fetchAllConfiguableCurrencies();
    await for (final _ in currencyMutationNotifier.stream) {
      yield await model.fetchAllConfiguableCurrencies();
    }
  }

  @override
  Future<void> editCategory(int categoryId, String categoryName) async {
    await model.editCategory(categoryId, categoryName);
    categoryMutationNotifier.add(null);
    ticketMutationNotifier.add(null);
  }

  @override
  Future<void> editCurrency(
    int currencyId,
    String currencyName,
    double currencyRatio,
  ) async {
    await model.editCurrency(currencyId, currencyName, currencyRatio);
    currencyMutationNotifier.add(null);
    ticketMutationNotifier.add(null);
  }

  @override
  Future<void> newCategory(String categoryName) async {
    await model.createCategory(categoryName);
    categoryMutationNotifier.add(null);
  }

  @override
  Future<void> newCurrency(String currencyName, double currencyRatio) async {
    await model.createCurrency(currencyName, currencyRatio);
    currencyMutationNotifier.add(null);
  }

  @override
  CategoryIntegrationWindow openCategoryIntegrationWindow(int replaceeId) {
    return CategoryIntegrationWindowImpl(replaceeId);
  }

  @override
  CurrencyIntegrationWindow openCurrencyIntegrationWindow(int replaceeId) {
    return CurrencyIntegrationWindowImpl(replaceeId);
  }

  @override
  Future<void> setDefaultCurrency(int currencyId) async {
    await model.setCurrencyAsDefault(currencyId);
    currencyMutationNotifier.add(null);
  }

  @override
  void dispose() {}
}

class CategoryIntegrationWindowImpl implements CategoryIntegrationWindow {
  @override
  final int replaceeId;

  CategoryIntegrationWindowImpl(this.replaceeId);

  List<Category>? cache;

  @override
  Future<Category> getReplacee() async {
    cache ??= await model.fetchAllCategories();
    return cache!.firstWhere((element) => element.id == replaceeId);
  }

  @override
  Future<List<Category>> getOptions() async {
    cache ??= await model.fetchAllCategories();
    return cache!.where((element) => element.id != replaceeId).toList();
  }

  @override
  Future<void> integrateCategory(int replacerId) async {
    await model.integrateCategory(replaceeId, replacerId);
    categoryMutationNotifier.add(null);
    ticketMutationNotifier.add(null);
  }

  @override
  void dispose() {}
}

class CurrencyIntegrationWindowImpl implements CurrencyIntegrationWindow {
  @override
  final int replaceeId;

  CurrencyIntegrationWindowImpl(this.replaceeId);

  List<Currency>? cache;

  @override
  Future<List<Currency>> getOptions() async {
    cache ??= await model.fetchAllCurrencies();
    return cache!.where((element) => element.id != replaceeId).toList();
  }

  @override
  Future<Currency> getReplacee() async {
    cache ??= await model.fetchAllCurrencies();
    return cache!.firstWhere((element) => element.id == replaceeId);
  }

  @override
  Future<void> integrateCurrency(int replacerId) async {
    await model.integrateCurrency(replaceeId, replacerId);
    currencyMutationNotifier.add(null);
    ticketMutationNotifier.add(null);
  }

  @override
  void dispose() {}
}
