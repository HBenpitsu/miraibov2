import 'dart:async';

import 'package:miraibo/skeleton/root.dart';
import 'package:miraibo/dto/dto.dart';

import 'dart:developer' show log;
import 'dart:math' show Random;

class MockRoot implements Root {
  @override
  PlanningPage get planningPage => MockPlanningPage();

  @override
  MainPage get mainPage => MockMainPage();

  @override
  DataPage get dataPage => MockDataPage();

  @override
  UtilsPage get utilsPage => MockUtilsPage();

  @override
  void dispose() {
    planningPage.dispose();
    mainPage.dispose();
    dataPage.dispose();
    utilsPage.dispose();
    log('MockRoot disposed');
  }
}

// <shared>
class MockMonitorSchemeEditWindow implements MonitorSchemeEditWindow {
  @override
  final int targetTicketId;
  final Sink<List<Ticket>> ticketsStream;
  final List<Ticket> tickets;

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR'),
  ];

  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockMonitorSchemeEditWindow(
      this.targetTicketId, this.ticketsStream, this.tickets);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<MonitorScheme> getOriginalMonitorScheme() {
    log('getOriginalMonitorScheme is called');
    final today = DateTime.now();
    final twoWeeksLater = today.add(const Duration(days: 14)).cutOffTime();
    final twoWeeksAgo = today.subtract(const Duration(days: 14)).cutOffTime();
    return Future.value(MonitorScheme(
      period: OpenPeriod(
        begins: twoWeeksAgo,
        ends: twoWeeksLater,
      ),
      currency: currencyList[0],
      displayOption: MonitorDisplayOption.meanInDays,
      categories: categoryList.sublist(0, 5),
    ));
  }

  @override
  Future<void> updateMonitorScheme(
      {required List<int> categoryIds,
      required OpenPeriod period,
      required MonitorDisplayOption displayOption,
      required int currencyId}) async {
    log('updateMonitorScheme is called with categoryIds: $categoryIds, period: $period, displayOption: $displayOption, currencyId: $currencyId');
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      final ticket = tickets.removeAt(0);
      if (ticket is! MonitorTicket) {
        newTickets.add(ticket);
        continue;
      }
      if (ticket.id != targetTicketId) {
        newTickets.add(ticket);
        continue;
      }
      newTickets.add(MonitorTicket(
        id: targetTicketId,
        period: period,
        displayOption: displayOption,
        price: Price(amount: 1000, symbol: currencyList[currencyId].symbol),
        categoryNames: categoryList
            .where((element) => categoryIds.contains(element.id))
            .map((e) => e.name)
            .toList(growable: false),
      ));
    }
    tickets.addAll(newTickets);
    ticketsStream.add(tickets);
  }

  @override
  Future<void> deleteMonitorScheme() async {
    log('deleteMonitorScheme is called with targetTicketId: $targetTicketId');
    tickets.removeWhere(
        (element) => element is MonitorTicket && element.id == targetTicketId);
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('MonitorSchemeEditWindow is disposed');
  }
}

class MockReceiptLogConfirmationWindow implements ReceiptLogConfirmationWindow {
  @override
  final int targetReceiptLogId;
  final List<Ticket> tickets;
  final Sink<List<Ticket>> ticketsStream;
  MockReceiptLogConfirmationWindow(
      this.targetReceiptLogId, this.tickets, this.ticketsStream);

  @override
  Future<ReceiptLogTicket> getLogContent() async {
    log('getLogContent is called with targetReceiptLogId: $targetReceiptLogId');
    for (final ticket in tickets) {
      if (ticket is! ReceiptLogTicket) continue;
      if (ticket.id == targetReceiptLogId) return ticket;
    }
    throw Exception('ticket not found');
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow() {
    log('openReceiptLogEditWindow is called with targetReceiptLogId: $targetReceiptLogId');
    return MockReceiptLogEditWindow(targetReceiptLogId, ticketsStream, tickets);
  }

  @override
  Future<void> confirmReceiptLog() async {
    log('confirmReceiptLog is called with targetReceiptLogId: $targetReceiptLogId');
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      final ticket = tickets.removeAt(0);
      if (ticket is! ReceiptLogTicket) {
        newTickets.add(ticket);
        continue;
      }
      if (ticket.id != targetReceiptLogId) {
        newTickets.add(ticket);
        continue;
      }
      newTickets.add(ReceiptLogTicket(
          id: ticket.id,
          price: ticket.price,
          date: ticket.date,
          description: ticket.description,
          categoryName: ticket.categoryName,
          confirmed: true));
    }
    tickets.addAll(newTickets);
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('ReceiptLogConfirmationWindow is disposed');
  }
}

class MockReceiptLogEditWindow implements ReceiptLogEditWindow {
  @override
  final int targetLogId;
  final Sink<List<Ticket>> ticketsStream;
  final List<Ticket> tickets;

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR'),
  ];

  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockReceiptLogEditWindow(this.targetLogId, this.ticketsStream, this.tickets);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<ReceiptLogScheme> getOriginalReceiptLog() {
    log('getOriginalReceiptLog is called with targetLogId: $targetLogId');
    final today = DateTime.now().cutOffTime();
    return Future.value(ReceiptLogScheme(
      category: categoryList[0],
      date: today,
      price: const ConfigureblePrice(
          amount: 1000, currencyId: 0, currencySymbol: 'JPY'),
      description: 'original description of the receipt log',
      confirmed: false,
    ));
  }

  @override
  Future<void> updateReceiptLog(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Date date}) async {
    log('updateReceiptLog is called with categoryId: $categoryId, description: $description, amount: $amount, currencyId: $currencyId, date: $date');
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      final ticket = tickets.removeAt(0);
      if (ticket is! ReceiptLogTicket) {
        newTickets.add(ticket);
        continue;
      }
      if (ticket.id != targetLogId) {
        newTickets.add(ticket);
        continue;
      }
      newTickets.add(ReceiptLogTicket(
        id: targetLogId,
        price: Price(amount: amount, symbol: currencyList[currencyId].symbol),
        date: date,
        description: description,
        categoryName: categoryList[categoryId].name,
        confirmed: true,
      ));
    }
    tickets.addAll(newTickets);
    ticketsStream.add(tickets);
  }

  @override
  Future<void> deleteReceiptLog() async {
    log('deleteReceiptLog is called with targetLogId: $targetLogId');
    tickets.removeWhere(
        (element) => element is ReceiptLogTicket && element.id == targetLogId);
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('ReceiptLogEditWindow is disposed');
  }
}
// </shared>

// <utils page>
typedef MockCategoryMap = Map<int, String>;
typedef MockCurrencyMap = Map<int, (String, double)>;

class MockUtilsPage implements UtilsPage {
  late final Stream<MockCategoryMap> categoryStream;
  late final Sink<MockCategoryMap> categorySink;
  late MockCategoryMap categories;
  late final Stream<MockCurrencyMap> currencyStream;
  late final Sink<MockCurrencyMap> currencySink;
  late MockCurrencyMap currencies;
  late int defaultCurrency;

  MockUtilsPage() {
    log('MockUtilsPage is constructed');
    categories = {for (int i = 0; i < 20; i++) i: 'category $i'};

    currencies = {for (int i = 0; i < 5; i++) i: ('currency $i', i.toDouble())};

    defaultCurrency = 0;

    // <initialize stream>
    final categoryController = StreamController<MockCategoryMap>.broadcast();
    categoryStream = categoryController.stream;
    categorySink = categoryController.sink;
    final currencyController = StreamController<MockCurrencyMap>.broadcast();
    currencyStream = currencyController.stream;
    currencySink = currencyController.sink;
    // </initialize stream>
  }

  @override
  CategorySection categorySection() {
    log('categorySection is called');
    final returnStreamController = StreamController<List<Category>>();
    returnStreamController.add(categories.entries
        .map((entry) => Category(id: entry.key, name: entry.value))
        .toList(growable: false));
    returnStreamController.addStream(categoryStream.map((data) => data.entries
        .map((entry) => Category(id: entry.key, name: entry.value))
        .toList(growable: false)));
    return returnStreamController.stream;
  }

  @override
  CurrencySection currencySection() {
    log('currencySection is called');
    final returnStreamController = StreamController<List<CurrencyInstance>>();
    returnStreamController.add(currencies.entries
        .map((entry) => CurrencyInstance(
            id: entry.key,
            symbol: entry.value.$1,
            ratio: entry.value.$2,
            isDefault: defaultCurrency == entry.key))
        .toList(growable: false));
    returnStreamController.addStream(currencyStream.map((data) => data.entries
        .map((entry) => CurrencyInstance(
            id: entry.key,
            symbol: entry.value.$1,
            ratio: entry.value.$2,
            isDefault: defaultCurrency == entry.key))
        .toList(growable: false)));
    return returnStreamController.stream;
  }

  @override
  Future<void> editCategory(int categoryId, String categoryName) async {
    log('editCategory is called with categoryId: $categoryId, categoryName: $categoryName');
    categories[categoryId] = categoryName;
    categorySink.add(categories);
  }

  @override
  Future<void> newCategory(String categoryName) async {
    log('newCategory is called with categoryName: $categoryName');
    categories[categories.length] = categoryName;
    categorySink.add(categories);
  }

  @override
  Future<void> editCurrency(
      int currencyId, String currencyName, double currencyRatio) async {
    log('editCurrency is called with currencyId: $currencyId, currencyName: $currencyName, currencyRatio: $currencyRatio');
    currencies[currencyId] = (currencyName, currencyRatio);
    currencySink.add(currencies);
  }

  @override
  Future<void> newCurrency(String currencyName, double currencyRatio) async {
    log('newCurrency is called with currencyName: $currencyName, currencyRatio: $currencyRatio');
    currencies[currencies.length] = (currencyName, currencyRatio);
    currencySink.add(currencies);
  }

  @override
  Future<void> setDefaultCurrency(int currencyId) async {
    log('setDefaultCurrency is called with currencyId: $currencyId');
    defaultCurrency = currencyId;
    currencySink.add(currencies);
  }

  @override
  CurrencyIntegrationWindow openCurrencyIntegrationWindow(int replaceeId) {
    log('openCurrencyIntegrationWindow is called with replaceeId: $replaceeId');
    return MockCurrencyIntegrationWindow(replaceeId, currencySink, currencies);
  }

  @override
  CategoryIntegrationWindow openCategoryIntegrationWindow(int replaceeId) {
    log('openCategoryIntegrationWindow is called with replaceeId: $replaceeId');
    return MockCategoryIntegrationWindow(replaceeId, categorySink, categories);
  }

  @override
  void dispose() {
    log('UtilsPage is disposed');
  }
}

class MockCurrencyIntegrationWindow implements CurrencyIntegrationWindow {
  @override
  final int replaceeId;
  final Sink<MockCurrencyMap> _currencyStream;
  final MockCurrencyMap _currencies;
  MockCurrencyIntegrationWindow(
      this.replaceeId, this._currencyStream, this._currencies);

  @override
  Future<Currency> getReplacee() async {
    log('getReplacee is called with replaceeId: $replaceeId');
    return Currency(id: replaceeId, symbol: _currencies[replaceeId]?.$1 ?? '');
  }

  @override
  Future<List<Currency>> getOptions() async {
    log('getOptions is called');
    return _currencies.entries
        .where((entry) => entry.key != replaceeId)
        .map((entry) => Currency(id: entry.key, symbol: entry.value.$1))
        .toList(growable: false);
  }

  @override
  Future<void> integrateCurrency(int replacerId) async {
    log('integrateCurrency is called with replacerId: $replacerId');
    _currencies.remove(replaceeId);
    _currencyStream.add(_currencies);
  }

  @override
  void dispose() {
    log('CurrencyIntegrationWindow is disposed');
  }
}

class MockCategoryIntegrationWindow implements CategoryIntegrationWindow {
  @override
  final int replaceeId;
  final Sink<MockCategoryMap> _categoryStream;
  final MockCategoryMap _categories;
  const MockCategoryIntegrationWindow(
      this.replaceeId, this._categoryStream, this._categories);

  @override
  Future<Category> getReplacee() async {
    log('getReplacee is called with replaceeId: $replaceeId');
    return Category(name: _categories[replaceeId] ?? '', id: replaceeId);
  }

  @override
  Future<List<Category>> getOptions() async {
    log('getOptions is called');
    return _categories.entries
        .where((entry) => entry.key != replaceeId)
        .map((entry) => Category(id: entry.key, name: entry.value))
        .toList(growable: false);
  }

  @override
  Future<void> integrateCategory(int replacerId) async {
    log('integrateCategory is called with replacerId: $replacerId');
    _categories.remove(replaceeId);
    _categoryStream.add(_categories);
  }

  @override
  void dispose() {
    log('CategoryIntegrationWindow is disposed');
  }
}
// </utils page>

// <planning page>

class MockPlanningPage implements PlanningPage {
  @override
  MonthlyScreen showInitialScreen() {
    log('showInitialScreen is called');
    final now = DateTime.now();
    return MockMonthlyScreen(now.cutOffTime());
  }

  @override
  void dispose() {
    log('MockPlanningPage: dispose called');
  }
}

class MockMonthlyScreen implements MonthlyScreen {
  @override
  final Date initiallyCenteredDate;
  final Random _random = Random();

  MockMonthlyScreen(this.initiallyCenteredDate);

  @override
  Calender getCalender(int index) {
    log('getCalender is called with index: $index');
    final firstDay = DateTime(
        initiallyCenteredDate.year, initiallyCenteredDate.month + index, 1);
    final lastDay = DateTime(
        initiallyCenteredDate.year, initiallyCenteredDate.month + index + 1, 0);
    final firstWeekday = firstDay.weekday % 7; // make Sunday(7) to 0
    final events = List.generate(lastDay.day, (index) {
      switch (_random.nextInt(3)) {
        case 0:
          return EventExistence.none;
        case 1:
          return EventExistence.important;
        case 2:
          return EventExistence.trivial;
        default:
          throw Exception('Invalid random number occurred');
      }
    });
    return Calender(firstDay.year, firstDay.month, lastDay.day, firstWeekday,
        Future.value(events));
  }

  @override
  DailyScreen navigateToDailyScreen(int year, int month, int day) {
    log('navigateToDailyScreen is called with year: $year, month: $month, day: $day');
    return MockDailyScreen(year, month, day);
  }

  @override
  void dispose() {
    log('MonthlyScreen is disposed');
  }
}

class MockPlanEditWindow implements PlanEditWindow {
  @override
  final int targetPlanId;
  final Sink<List<Ticket>> ticketsStream;
  final List<Ticket> tickets;

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR'),
  ];

  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockPlanEditWindow(this.targetPlanId, this.ticketsStream, this.tickets);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<PlanScheme> getOriginalPlan() {
    log('getOriginalPlan is called with targetPlanId: $targetPlanId');
    final today = DateTime.now().cutOffTime();
    return Future.value(PlanScheme(
        category: categoryList[0],
        schedule: OneshotSchedule(date: today),
        price: ConfigureblePrice(
            amount: 1000,
            currencyId: 0,
            currencySymbol: currencyList[0].symbol),
        description: 'original description of the plan'));
  }

  @override
  Future<void> updatePlan(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Schedule schedule}) async {
    log('updatePlan is called with categoryId: $categoryId, description: $description, amount: $amount, currencyId: $currencyId, schedule: $schedule');
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      final ticket = tickets.removeAt(0);
      if (ticket is! PlanTicket) {
        newTickets.add(ticket);
        continue;
      }
      if (ticket.id != targetPlanId) {
        newTickets.add(ticket);
        continue;
      }
      newTickets.add(PlanTicket(
        id: targetPlanId,
        price: Price(amount: amount, symbol: currencyList[currencyId].symbol),
        schedule: schedule,
        description: description,
        categoryName: categoryList[categoryId].name,
      ));
    }
    tickets.addAll(newTickets);
    ticketsStream.add(tickets);
  }

  @override
  Future<void> deletePlan() async {
    log('deletePlan is called with targetPlanId: $targetPlanId');
    tickets.removeWhere(
        (element) => element is PlanTicket && element.id == targetPlanId);
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('PlanEditWindow is disposed');
  }
}

class MockEstimationSchemeEditWindow implements EstimationSchemeEditWindow {
  @override
  final int targetSchemeId;
  final Sink<List<Ticket>> ticketsStream;
  final List<Ticket> tickets;

  // List of predefined currencies
  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR'),
  ];

  // List of predefined categories
  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockEstimationSchemeEditWindow(
      this.targetSchemeId, this.ticketsStream, this.tickets);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<EstimationScheme> getOriginalEstimationScheme() {
    log('getOriginalEstimationScheme is called');
    final today = DateTime.now();
    final twoWeeksLater = today.add(const Duration(days: 14)).cutOffTime();
    final twoWeeksAgo = today.subtract(const Duration(days: 14)).cutOffTime();
    return Future.value(EstimationScheme(
      period: OpenPeriod(
        begins: twoWeeksAgo,
        ends: twoWeeksLater,
      ),
      currency: currencyList[0],
      displayOption: EstimationDisplayOption.perWeek,
      categories: categoryList.sublist(0, 5),
    ));
  }

  @override
  Future<void> updateEstimationScheme(
      {required List<int> categoryIds,
      required OpenPeriod period,
      required EstimationDisplayOption displayOption,
      required int currencyId}) async {
    log('updateEstimationScheme is called with categoryIds: $categoryIds, period: $period, displayOption: $displayOption, currencyId: $currencyId');
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      final ticket = tickets.removeAt(0);
      if (ticket is! EstimationTicket) {
        newTickets.add(ticket);
        continue;
      }
      if (ticket.id != targetSchemeId) {
        newTickets.add(ticket);
        continue;
      }
      newTickets.add(EstimationTicket(
        id: targetSchemeId,
        period: period,
        price: Price(amount: 1000, symbol: currencyList[currencyId].symbol),
        displayOption: displayOption,
        categoryNames: categoryList
            .where((element) => categoryIds.contains(element.id))
            .map((e) => e.name)
            .toList(growable: false),
      ));
    }
    tickets.addAll(newTickets);
    ticketsStream.add(tickets);
  }

  @override
  Future<void> deleteEstimationScheme() async {
    log('deleteEstimationScheme is called with targetSchemeId: $targetSchemeId');
    tickets.removeWhere((element) =>
        element is EstimationTicket && element.id == targetSchemeId);
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('EstimationSchemeEditWindow is disposed');
  }
}

class MockDailyScreen implements DailyScreen {
  @override
  late final Date initiallyCenteredDate;

  @override
  int offset = 0;

  late final Stream<Date> labelStream;
  late final Sink<Date> labelSink;
  late final List<Ticket> tickets;
  late final Stream<List<Ticket>> ticketStream;
  late final Sink<List<Ticket>> ticketSink;
  MockDailyScreen(int year, int month, int day) {
    log('MockDailyScreen is constructed with year: $year, month: $month, day: $day');
    initiallyCenteredDate = Date(year, month, day);

    // <prepare parameters>
    final today = DateTime(year, month, day);
    final twoMonthAgo =
        today.subtract(const Duration(days: 2 * 31)).cutOffTime();
    final twoMonthLater = today.add(const Duration(days: 2 * 31)).cutOffTime();
    final startlessPeriod = OpenPeriod(begins: null, ends: twoMonthLater);
    final endlessPeriod = OpenPeriod(begins: twoMonthAgo, ends: null);
    final closedPeriod = OpenPeriod(begins: twoMonthAgo, ends: twoMonthLater);
    const price = Price(amount: -1000, symbol: 'JPY');
    // </prepare parameters>

    // <make mock tickets>
    tickets = [
      MonitorTicket(
          id: 0,
          period: startlessPeriod,
          price: price,
          displayOption: MonitorDisplayOption.meanInDays,
          categoryNames: [
            'list of categories aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
          ]),
      MonitorTicket(
          id: 1,
          period: endlessPeriod,
          price: price,
          displayOption: MonitorDisplayOption.quartileMeanInDays,
          categoryNames: [
            'category1',
            'category2',
            'category3',
            'category4',
            'category5',
            'category6',
            'category7',
            'category8',
          ]),
      MonitorTicket(
          id: 2,
          period: closedPeriod,
          price: price,
          displayOption: MonitorDisplayOption.summation,
          categoryNames: []),
      PlanTicket(
          id: 3,
          schedule: OneshotSchedule(date: Date(year, month, day)),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 4,
          schedule: IntervalSchedule(
              originDate: Date(year, month, day),
              period: const OpenPeriod(),
              interval: 1),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 5,
          schedule: IntervalSchedule(
              originDate: Date(year, month, day),
              period: OpenPeriod(
                  begins: Date(
                      twoMonthAgo.year, twoMonthAgo.month, twoMonthAgo.day)),
              interval: 1),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 6,
          schedule: IntervalSchedule(
              originDate: Date(year, month, day),
              period: OpenPeriod(
                  ends: Date(twoMonthLater.year, twoMonthLater.month,
                      twoMonthLater.day)),
              interval: 3),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 7,
          schedule: IntervalSchedule(
              originDate: Date(year, month, day),
              period: OpenPeriod(begins: twoMonthAgo, ends: twoMonthLater),
              interval: 1),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 8,
          schedule: WeeklySchedule(
              period: closedPeriod,
              sunday: true,
              monday: false,
              tuesday: false,
              wednesday: false,
              thursday: true,
              friday: false,
              saturday: false),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 9,
          schedule: MonthlySchedule(period: closedPeriod, offset: 1),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 10,
          schedule: MonthlySchedule(period: closedPeriod, offset: -1),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 11,
          schedule: AnnualSchedule(
              period: closedPeriod, originDate: Date(year, month, day)),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      EstimationTicket(
          id: 12,
          period: startlessPeriod,
          price: price,
          displayOption: EstimationDisplayOption.perDay,
          categoryNames: ['list of categories']),
      EstimationTicket(
          id: 13,
          period: endlessPeriod,
          price: price,
          displayOption: EstimationDisplayOption.perMonth,
          categoryNames: ['category1', 'category2']),
      EstimationTicket(
          id: 14,
          period: closedPeriod,
          price: price,
          displayOption: EstimationDisplayOption.perWeek,
          categoryNames: []),
      EstimationTicket(
          id: 15,
          period: closedPeriod,
          price: price,
          displayOption: EstimationDisplayOption.perYear,
          categoryNames: []),
      ReceiptLogTicket(
          id: 16,
          date: Date(year, month, day),
          price: price,
          description: 'this is a description of the receipt log.',
          categoryName: 'category0',
          confirmed: true),
      ReceiptLogTicket(
          id: 17,
          date: Date(year, month, day),
          price: price,
          description: 'this is a description of the receipt log.',
          categoryName: 'category0',
          confirmed: false)
    ];
    // </make mock tickets>

    // <initialize streams>
    final labelStreamController = StreamController<Date>.broadcast();
    labelStream = labelStreamController.stream;
    labelSink = labelStreamController.sink;
    labelSink.add(initiallyCenteredDate);
    final ticketStreamController = StreamController<List<Ticket>>.broadcast();
    ticketStream = ticketStreamController.stream;
    ticketSink = ticketStreamController.sink;
    // </initialize streams>
  }

  @override
  Stream<List<Ticket>> getTicketsOn(int index) {
    log('getTicketsOn is called with index: $index');
    final returnStreamController = StreamController<List<Ticket>>();
    returnStreamController.add(tickets);
    returnStreamController.addStream(ticketStream);
    return returnStreamController.stream;
  }

  @override
  Stream<Date> getLabel() {
    log('getLabel is called');
    final returnStreamController = StreamController<Date>();
    returnStreamController.add(initiallyCenteredDate);
    returnStreamController.addStream(labelStream);
    return returnStreamController.stream;
  }

  @override
  MonthlyScreen navigateToMonthlyScreen() {
    log('navigateToMonthlyScreen is called');
    final currentDate = DateTime(initiallyCenteredDate.year,
        initiallyCenteredDate.month, initiallyCenteredDate.day + offset);
    return MockMonthlyScreen(currentDate.cutOffTime());
  }

  @override
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId) {
    log('openMonitorSchemeEditWindow is called with targetTicketId: $targetTicketId');
    return MockMonitorSchemeEditWindow(targetTicketId, ticketSink, tickets);
  }

  @override
  PlanEditWindow openPlanEditWindow(int targetTicketId) {
    log('openPlanEditWindow is called with targetTicketId: $targetTicketId');
    return MockPlanEditWindow(targetTicketId, ticketSink, tickets);
  }

  @override
  EstimationSchemeEditWindow openEstimationSchemeEditWindow(
      int targetTicketId) {
    log('openEstimationSchemeEditWindow is called with targetTicketId: $targetTicketId');
    return MockEstimationSchemeEditWindow(targetTicketId, ticketSink, tickets);
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId) {
    log('openReceiptLogEditWindow is called with targetTicketId: $targetTicketId');
    return MockReceiptLogEditWindow(targetTicketId, ticketSink, tickets);
  }

  @override
  ReceiptLogConfirmationWindow openReceiptLogConfirmationWindow(
      int targetTicketId) {
    log('openReceiptLogConfirmationWindow is called with targetTicketId: $targetTicketId');
    return MockReceiptLogConfirmationWindow(
        targetTicketId, tickets, ticketSink);
  }

  @override
  TicketCreateWindow openTicketCreateWindow() {
    log('openTicketCreateWindow is called');
    return MockTicketCreateWindow(tickets, ticketSink);
  }

  @override
  Future<void> setOffset(int offset) async {
    log('setOffset is called with offset: $offset');
    this.offset = offset;
    final centeredDate = DateTime(initiallyCenteredDate.year,
        initiallyCenteredDate.month, initiallyCenteredDate.day + offset);
    labelSink.add(centeredDate.cutOffTime());
  }

  @override
  void dispose() {
    log('DailyScreen is disposed');
  }
}

class MockTicketCreateWindow implements TicketCreateWindow {
  @override
  late final PlanSection planSection;
  @override
  late final EstimationSchemeSection estimationSchemeSection;
  @override
  late final MonitorSchemeSection monitorSchemeSection;
  @override
  late final ReceiptLogSection receiptLogSection;

  MockTicketCreateWindow(
      List<Ticket> tickets, Sink<List<Ticket>> ticketsStream) {
    log('MockTicketCreateWindow is constructed');
    planSection = MockPlanSection(tickets, ticketsStream);
    estimationSchemeSection =
        MockEstimationSchemeSection(tickets, ticketsStream);
    monitorSchemeSection = MockMonitorSchemeSection(tickets, ticketsStream);
    receiptLogSection = MockReceiptLogSection(tickets, ticketsStream);
  }

  @override
  void dispose() {
    log('MockTicketCreateWindow is disposed');
    planSection.dispose();
    estimationSchemeSection.dispose();
    monitorSchemeSection.dispose();
    receiptLogSection.dispose();
  }
}

class MockReceiptLogSection implements ReceiptLogSection {
  final List<Ticket> tickets;
  final Sink<List<Ticket>> ticketsStream;
  final Random random = Random();

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockReceiptLogSection(this.tickets, this.ticketsStream);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<ReceiptLogScheme> getInitialScheme() async {
    log('getDefaultCurrency is called');
    return ReceiptLogScheme(
        date: DateTime.now().cutOffTime(),
        price: ConfigureblePrice(
            amount: 0, currencyId: 0, currencySymbol: currencyList[0].symbol),
        description: '',
        category: categoryList[0],
        confirmed: true);
  }

  @override
  Future<List<ReceiptLogSchemePreset>> getPresets() async {
    log('getPresets is called');
    return [
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 0, currencySymbol: currencyList[0].symbol),
        description: 'preset1',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: 'preset2',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: '',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: '',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: 'preset5',
        category: Category(id: 0, name: categoryList[0].name),
      ),
    ];
  }

  @override
  Future<void> createReceiptLog(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Date date}) async {
    log('createReceiptLog is called');
    final id = DateTime.now().millisecondsSinceEpoch * 10 + random.nextInt(10);
    tickets.add(ReceiptLogTicket(
        id: id,
        price: Price(amount: amount, symbol: currencyList[currencyId].symbol),
        date: date,
        description: description,
        categoryName: categoryList[categoryId].name,
        confirmed: true));
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('MockReceiptLogSection is disposed');
  }
}

class MockPlanSection implements PlanSection {
  final List<Ticket> tickets;
  final Sink<List<Ticket>> ticketsStream;
  final Random random = Random();

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockPlanSection(this.tickets, this.ticketsStream);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<PlanScheme> getInitialScheme() async {
    log('getInitialScheme is called');
    return PlanScheme(
        schedule: OneshotSchedule(date: DateTime.now().cutOffTime()),
        price: ConfigureblePrice(
            amount: 0, currencyId: 0, currencySymbol: currencyList[0].symbol),
        description: '',
        category: categoryList[0]);
  }

  @override
  Future<void> createPlan(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Schedule schedule}) async {
    log('createPlan is called');
    final id = DateTime.now().millisecondsSinceEpoch * 10 + random.nextInt(10);
    tickets.add(PlanTicket(
        id: id,
        price: Price(amount: amount, symbol: currencyList[currencyId].symbol),
        schedule: schedule,
        description: description,
        categoryName: categoryList[categoryId].name));
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('MockPlanSection: dispose called');
  }
}

class MockMonitorSchemeSection implements MonitorSchemeSection {
  final List<Ticket> tickets;
  final Sink<List<Ticket>> ticketsStream;
  final Random random = Random();

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockMonitorSchemeSection(this.tickets, this.ticketsStream);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<MonitorScheme> getInitialScheme() async {
    log('getDefaultCurrency is called');
    return MonitorScheme(
        categories: categoryList,
        currency: currencyList[0],
        period: const OpenPeriod(begins: null, ends: null),
        displayOption: MonitorDisplayOption.summation);
  }

  @override
  Future<void> createMonitorScheme(
      {required List<int> categoryIds,
      required OpenPeriod period,
      required MonitorDisplayOption displayOption,
      required int currencyId}) async {
    log('createMonitorScheme is called with categoryIds: $categoryIds, period: $period, displayOption: $displayOption, currencyId: $currencyId');
    final id = DateTime.now().millisecondsSinceEpoch * 10 + random.nextInt(10);
    tickets.add(MonitorTicket(
        id: id,
        period: period,
        price: Price(amount: 1000, symbol: currencyList[currencyId].symbol),
        displayOption: displayOption,
        categoryNames: categoryIds
            .map((id) => categoryList[id].name)
            .toList(growable: false)));
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('MonitorSchemeSection is disposed');
  }
}

class MockEstimationSchemeSection implements EstimationSchemeSection {
  final List<Ticket> tickets;
  final Sink<List<Ticket>> ticketsStream;
  final Random random = Random();

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockEstimationSchemeSection(this.tickets, this.ticketsStream);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<EstimationScheme> getInitialScheme() async {
    log('getEstimationScheme is called');
    return EstimationScheme(
        period: OpenPeriod(begins: null, ends: null),
        currency: currencyList[0],
        displayOption: EstimationDisplayOption.perDay,
        categories: categoryList);
  }

  @override
  Future<void> createEstimationScheme(
      {required List<int> categoryIds,
      required OpenPeriod period,
      required EstimationDisplayOption displayOption,
      required int currencyId}) async {
    log('createEstimationScheme is called with categoryIds: $categoryIds, period: $period, displayOption: $displayOption, currencyId: $currencyId');
    final id = DateTime.now().millisecondsSinceEpoch * 10 + random.nextInt(10);
    tickets.add(EstimationTicket(
        id: id,
        period: period,
        price: Price(amount: 1000, symbol: currencyList[currencyId].symbol),
        displayOption: displayOption,
        categoryNames: categoryIds
            .map((id) => categoryList[id].name)
            .toList(growable: false)));
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('EstimationSchemeSection is disposed');
  }
}
// </planning page>

// >main page>

class MockMainPage implements MainPage {
  @override
  late final Date today;
  late final List<Ticket> tickets;
  late final Stream<List<Ticket>> ticketsStream;
  late final Sink<List<Ticket>> ticketsSink;

  MockMainPage() {
    log('MockMainPage is constructed');
    // <prepare parameters>
    final now = DateTime.now();
    today = now.cutOffTime();
    final twoMonthAgo = now.subtract(const Duration(days: 2 * 31)).cutOffTime();
    final twoMonthLater = now.add(const Duration(days: 2 * 31)).cutOffTime();
    final startlessPeriod = OpenPeriod(begins: null, ends: twoMonthLater);
    final endlessPeriod = OpenPeriod(begins: twoMonthAgo, ends: null);
    final closedPeriod = OpenPeriod(begins: twoMonthAgo, ends: twoMonthLater);
    const price = Price(amount: 1000, symbol: 'JPY');
    // </prepare parameters>

    // <make mock tickets to show>
    tickets = [
      MonitorTicket(
          id: 0,
          period: startlessPeriod,
          price: price,
          displayOption: MonitorDisplayOption.meanInDays,
          categoryNames: ['list of categories']),
      MonitorTicket(
          id: 1,
          period: endlessPeriod,
          price: price,
          displayOption: MonitorDisplayOption.quartileMeanInDays,
          categoryNames: ['category1', 'category2']),
      MonitorTicket(
          id: 2,
          period: closedPeriod,
          price: price,
          displayOption: MonitorDisplayOption.summation,
          categoryNames: []),
      ReceiptLogTicket(
          id: 16,
          date: today,
          price: price,
          description: 'this is a description of the receipt log.',
          categoryName: 'category0',
          confirmed: true),
      ReceiptLogTicket(
          id: 17,
          date: today,
          price: price,
          description: 'this is a description of the receipt log.',
          categoryName: 'category0',
          confirmed: false)
    ];
    // </make mock tickets to show>

    // <initialize stream>
    final ticketsStreamController = StreamController<List<Ticket>>.broadcast();
    ticketsStream = ticketsStreamController.stream;
    ticketsSink = ticketsStreamController.sink;

    ticketsSink.add(tickets);
    // </initialize stream>
  }

  @override
  Stream<List<Ticket>> getTickets() {
    log('getTickets is called');
    final returnStreamController = StreamController<List<Ticket>>();
    returnStreamController.add(tickets);
    returnStreamController.addStream(ticketsStream);
    return returnStreamController.stream;
  }

  @override
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId) {
    log('openMonitorSchemeEditWindow is called with targetTicketId: $targetTicketId');
    return MockMonitorSchemeEditWindow(targetTicketId, ticketsSink, tickets);
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId) {
    log('openReceiptLogEditWindow is called with targetTicketId: $targetTicketId');
    return MockReceiptLogEditWindow(targetTicketId, ticketsSink, tickets);
  }

  @override
  ReceiptLogConfirmationWindow openReceiptLogConfirmationWindow(
      int targetTicketId) {
    log('openReceiptLogConfirmationWindow is called with targetTicketId: $targetTicketId');
    return MockReceiptLogConfirmationWindow(
        targetTicketId, tickets, ticketsSink);
  }

  @override
  ReceiptLogCreateWindow openReceiptLogCreateWindow() {
    log('openReceiptLogCreateWindow is called');
    return MockReceiptLogCreateWindow(tickets, ticketsSink);
  }

  @override
  void dispose() {
    log('MockMainPage is disposed');
  }
}

class MockReceiptLogCreateWindow implements ReceiptLogCreateWindow {
  final List<Ticket> tickets;
  final Sink<List<Ticket>> ticketsStream;
  final Random random = Random();

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockReceiptLogCreateWindow(this.tickets, this.ticketsStream);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<ReceiptLogScheme> getInitialScheme() async {
    log('getDefaultCurrency is called');
    return ReceiptLogScheme(
        date: DateTime.now().cutOffTime(),
        price: ConfigureblePrice(
            amount: 0, currencyId: 0, currencySymbol: currencyList[0].symbol),
        description: '',
        category: categoryList[0],
        confirmed: true);
  }

  @override
  Future<List<ReceiptLogSchemePreset>> getPresets() async {
    log('getPresets is called');
    return [
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 0, currencySymbol: currencyList[0].symbol),
        description:
            'preset1 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: 'preset2',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: '',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: '',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: 'preset5',
        category: Category(id: 0, name: categoryList[0].name),
      ),
    ];
  }

  @override
  Future<void> createReceiptLog(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Date date}) async {
    log('createReceiptLog is called with categoryId: $categoryId, description: $description, amount: $amount, currencyId: $currencyId, date: $date');
    final id = DateTime.now().millisecondsSinceEpoch * 10 + random.nextInt(10);
    tickets.add(ReceiptLogTicket(
        id: id,
        date: date,
        price: Price(amount: amount, symbol: currencyList[currencyId].symbol),
        description: description,
        categoryName: categoryList[categoryId].name,
        confirmed: true));
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('MockReceiptLogCreateWindow is disposed');
  }
}
// </main page>

// <data page>

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

class MockExportationWindow implements ExportationWindow {
  @override
  Future<bool> exportDataTo(String path) async {
    log('MockExportationWindow: exportDataTo called with path: $path');
    return Random().nextBool();
  }

  @override
  void dispose() {
    log('MockExportationWindow: dispose called');
  }
}

class MockOverwriteWindow implements OverwriteWindow {
  @override
  Future<bool> overwriteDataWith(String path) async {
    log('MockOverwriteWindow: overwriteDataWith called with path: $path');
    return Random().nextBool();
  }

  @override
  void dispose() {
    log('MockOverwriteWindow: dispose called');
  }
}

class MockImportationWindow implements ImportationWindow {
  @override
  Future<bool> importDataFrom(String path) async {
    log('MockImportationWindow: importDataFrom called with path: $path');
    return Random().nextBool();
  }

  @override
  void dispose() {
    log('MockImportationWindow: dispose called');
  }
}

class MockBackupWindow implements BackupWindow {
  @override
  Future<bool> backupDataTo(String path) async {
    log('MockBackupWindow: backupDataTo called with path: $path');
    return Random().nextBool();
  }

  @override
  void dispose() {
    log('MockBackupWindow: dispose called');
  }
}

class MockRestoreWindow implements RestoreWindow {
  @override
  Future<bool> restoreDataFrom(String path) async {
    log('MockRestoreWindow: restoreDataFrom called with path: $path');
    return Random().nextBool();
  }

  @override
  void dispose() {
    log('MockRestoreWindow: dispose called');
  }
}

class MockTemporaryTicketConfigWindow implements TemporaryTicketConfigWindow {
  @override
  final TemporaryTicketScheme initialScheme;
  final Function(TemporaryTicketScheme) schemeSetter;
  @override
  set currentScheme(TemporaryTicketScheme value) => schemeSetter(value);

  @override
  late final TemporaryEstimationSchemeSection estimationSchemeSection;
  @override
  late final TemporaryMonitorSchemeSection monitorSchemeSection;

  MockTemporaryTicketConfigWindow(this.initialScheme, this.schemeSetter) {
    log('MockTemporaryTicketConfigWindow is constructed');
    estimationSchemeSection =
        MockTemporaryEstimationSchemeSection(initialScheme, schemeSetter);
    monitorSchemeSection =
        MockTemporaryMonitorSchemeSection(initialScheme, schemeSetter);
  }

  @override
  Future<TemporaryTicketScheme> getInitialScheme() async {
    return initialScheme;
  }

  @override
  void dispose() {
    log('MockTemporaryTicketConfigWindow is disposed');
    estimationSchemeSection.dispose();
    monitorSchemeSection.dispose();
  }
}

class MockTemporaryMonitorSchemeSection
    implements TemporaryMonitorSchemeSection {
  @override
  final TemporaryTicketScheme initialScheme;
  final Function(TemporaryTicketScheme) schemeSetter;
  @override
  set currentScheme(TemporaryTicketScheme value) => schemeSetter(value);

  // List of predefined currencies
  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  // List of predefined categories
  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockTemporaryMonitorSchemeSection(this.initialScheme, this.schemeSetter);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<TemporaryMonitorScheme> getInitialScheme() async {
    log('getInitialScheme is called');
    if (initialScheme is TemporaryMonitorScheme) {
      return initialScheme as TemporaryMonitorScheme;
    }
    // provide a default scheme
    return TemporaryMonitorScheme(
        categories: categoryList,
        period: const OpenPeriod(begins: null, ends: null),
        displayOption: MonitorDisplayOption.meanInDays,
        currency: currencyList[0]);
  }

  @override
  Future<void> applyMonitorScheme(List<int> categoryIds, OpenPeriod period,
      MonitorDisplayOption displayOption, int currencyId) async {
    log('applyMonitorScheme is called');
    // cast bunch of parameters to the temporary monitor scheme
    currentScheme = TemporaryMonitorScheme(
        categories:
            categoryIds.map((id) => categoryList[id]).toList(growable: false),
        period: period,
        displayOption: displayOption,
        currency: currencyList[currencyId]);
  }

  @override
  void dispose() {
    log('MockTemporaryMonitorSchemeSection is disposed');
  }
}

class MockTemporaryEstimationSchemeSection
    implements TemporaryEstimationSchemeSection {
  @override
  final TemporaryTicketScheme initialScheme;

  /// setter to implement set [currentScheme]
  final Function(TemporaryTicketScheme) schemeSetter;
  @override
  set currentScheme(TemporaryTicketScheme value) => schemeSetter(value);

  /// list of predefined currencies
  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  /// list of predefined categories
  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockTemporaryEstimationSchemeSection(this.initialScheme, this.schemeSetter);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<TemporaryEstimationScheme> getInitialScheme() async {
    log('getInitialScheme is called');
    if (initialScheme is TemporaryEstimationScheme) {
      return initialScheme as TemporaryEstimationScheme;
    }
    // provide a mock-default scheme
    return TemporaryEstimationScheme(
        categories: categoryList,
        currency: currencyList[0],
        displayOption: EstimationDisplayOption.perMonth,
        period: const OpenPeriod(begins: null, ends: null));
  }

  @override
  Future<void> applyMonitorScheme(List<int> categoryIds, OpenPeriod period,
      EstimationDisplayOption displayOption, int currencyId) async {
    log('applyMonitorScheme is called');
    // cast bunch of parameters to the temporary estimation scheme
    currentScheme = TemporaryEstimationScheme(
        categories: categoryList
            .where((element) => categoryIds.contains(element.id))
            .toList(growable: false),
        currency: currencyList[currencyId],
        displayOption: displayOption,
        period: period);
  }

  @override
  void dispose() {
    log('MockTemporaryEstimationSchemeSection is disposed');
  }
}

class MockChartConfigurationWindow implements ChartConfigurationWindow {
  @override
  final ChartScheme initialScheme;
  final Function(ChartScheme) schemeSetter;
  @override
  set currentScheme(ChartScheme value) => schemeSetter(value);

  @override
  late final AccumulationChartSection accumulationChartSection;

  @override
  late final PieChartSection pieChartSection;

  @override
  late final SubtotalChartSection subtotalChartSection;

  MockChartConfigurationWindow(this.initialScheme, this.schemeSetter) {
    log('MockChartConfigurationWindow: constructed');
    accumulationChartSection =
        MockAccumulationChartSection(initialScheme, schemeSetter);
    pieChartSection = MockPieChartSection(initialScheme, schemeSetter);
    subtotalChartSection =
        MockSubtotalChartSection(initialScheme, schemeSetter);
  }

  @override
  Future<ChartScheme> getInitialScheme() async {
    return initialScheme;
  }

  @override
  void dispose() {
    log('MockChartConfigurationWindow: dispose called');
    accumulationChartSection.dispose();
    pieChartSection.dispose();
    subtotalChartSection.dispose();
  }
}

class MockSubtotalChartSection implements SubtotalChartSection {
  @override
  final ChartScheme initialScheme;

  /// setter to implement set [currentScheme]
  final Function(ChartScheme) schemeSetter;
  @override
  set currentScheme(ChartScheme value) => schemeSetter(value);

  /// list of predefined currencies
  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  /// list of predefined categories
  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockSubtotalChartSection(this.initialScheme, this.schemeSetter);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('MockSubtotalChartSection: getCategoryOptions called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('MockSubtotalChartSection: getCurrencyOptions called');
    return currencyList;
  }

  @override
  Future<SubtotalChartScheme> getInitialScheme() async {
    log('MockSubtotalChartSection: getInitialScheme called');
    if (initialScheme is SubtotalChartScheme) {
      return initialScheme as SubtotalChartScheme;
    }
    // make mock-default scheme
    // <prepare parameters>
    final now = DateTime.now();
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    final twoWeeksLater = now.add(const Duration(days: 14));
    final closedPeriod = ClosedPeriod(
        begins: twoWeeksAgo.cutOffTime(), ends: twoWeeksLater.cutOffTime());
    // </prepare parameters>
    return SubtotalChartScheme(
        currency: currencyList[0],
        viewportRange: closedPeriod,
        intervalInDays: 7,
        categories: categoryList);
  }

  @override
  Future<void> applyScheme(List<int> categoryIds, int currencyId,
      ClosedPeriod viewportRange, int intervalInDays) async {
    log('MockSubtotalChartSection: applyScheme called with categoryIds: $categoryIds, currencyId: $currencyId, viewportRange: $viewportRange, intervalInDays: $intervalInDays');
    // cast bunch of parameters to SubtotalChartScheme and set it to currentScheme
    currentScheme = SubtotalChartScheme(
        currency: currencyList[currencyId],
        viewportRange: viewportRange,
        categories: categoryIds.map((id) => categoryList[id]).toList(),
        intervalInDays: intervalInDays);
  }

  @override
  void dispose() {
    log('MockSubtotalChartSection: dispose called');
  }
}

class MockPieChartSection implements PieChartSection {
  @override
  final ChartScheme initialScheme;

  /// setter to implement set [currentScheme]
  final Function(ChartScheme) schemeSetter;
  @override
  set currentScheme(ChartScheme value) => schemeSetter(value);

  /// list of predefined currencies
  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  /// list of predefined categories
  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockPieChartSection(this.initialScheme, this.schemeSetter);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<PieChartScheme> getInitialScheme() async {
    log('getInitialScheme is called');
    if (initialScheme is PieChartScheme) {
      return initialScheme as PieChartScheme;
    }
    // make mock-default scheme
    // <prepare parameters>
    final now = DateTime.now();
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    final twoWeeksLater = now.add(const Duration(days: 14));
    final period = OpenPeriod(
        begins: twoWeeksAgo.cutOffTime(), ends: twoWeeksLater.cutOffTime());
    // </prepare parameters>
    return PieChartScheme(
        currency: currencyList[0],
        analysisRange: period,
        categories: categoryList);
  }

  @override
  Future<void> applyScheme(
      int currencyId, OpenPeriod period, List<int> categoryIds) async {
    log('applyScheme is called');
    // cast bunch of parameters to PieChartScheme and set it to currentScheme
    currentScheme = PieChartScheme(
        currency: currencyList[currencyId],
        analysisRange: period,
        categories:
            categoryIds.map((id) => categoryList[id]).toList(growable: false));
  }

  @override
  void dispose() {
    log('MockPieChartSection is disposed');
  }
}

class MockAccumulationChartSection implements AccumulationChartSection {
  @override
  final ChartScheme initialScheme;

  /// setter to implement set [currentScheme]
  final Function(ChartScheme) schemeSetter;
  @override
  set currentScheme(ChartScheme value) => schemeSetter(value);

  /// list of predefined currencies
  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  /// list of predefined categories
  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockAccumulationChartSection(this.initialScheme, this.schemeSetter);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<AccumulationChartScheme> getInitialScheme() async {
    log('getInitialScheme is called');
    if (initialScheme is AccumulationChartScheme) {
      return initialScheme as AccumulationChartScheme;
    }
    // make mock-default scheme
    // <prepare parameters>
    final now = DateTime.now();
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    final twoWeeksLater = now.add(const Duration(days: 14));
    final period = OpenPeriod(
        begins: twoWeeksAgo.cutOffTime(), ends: twoWeeksLater.cutOffTime());
    final closedPeriod = ClosedPeriod(
        begins: twoWeeksAgo.cutOffTime(), ends: twoWeeksLater.cutOffTime());
    // </prepare parameters>
    return AccumulationChartScheme(
        currency: currencyList[0],
        analysisRange: period,
        viewportRange: closedPeriod,
        categories: categoryList,
        intervalInDays: 1);
  }

  @override
  Future<void> applyScheme(
      int currencyId,
      OpenPeriod analysisRange,
      ClosedPeriod viewportRange,
      List<int> categoryIds,
      int intervalInDays) async {
    log('applyScheme is called');
    // cast bunch of parameters to AccumulationChartScheme and set it to currentScheme
    currentScheme = AccumulationChartScheme(
        currency: currencyList[currencyId],
        analysisRange: analysisRange,
        viewportRange: viewportRange,
        categories:
            categoryIds.map((id) => categoryList[id]).toList(growable: false),
        intervalInDays: intervalInDays);
  }

  @override
  void dispose() {
    log('MockAccumulationChartSection is disposed');
  }
}
// </data page>
