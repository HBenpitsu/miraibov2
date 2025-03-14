import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/core-model/value/collection/ticket_collection.dart'
    as model;
import 'package:miraibo/core-model/value/date.dart' as model;
import 'package:miraibo/core-model/value/schedule.dart' as model;

/// {@template fetchTicketsOn}
/// fetches tickets on the given date
/// returns the list of ticket
/// {@endtemplate}
Future<List<Ticket>> fetchTicketsOn(Date date) async {
  final tickets = await model.TicketCollection.ticketsOn(
      model.Date(date.year, date.month, date.day));
  final result = <Ticket>[];
  for (final monitorScheme in tickets.monitorSchemes) {
    final price = await monitorScheme.getValue();
    final begins = monitorScheme.period.isStartless
        ? null
        : Date(
            monitorScheme.period.begins.year,
            monitorScheme.period.begins.month,
            monitorScheme.period.begins.day,
          );
    final ends = monitorScheme.period.isEndless
        ? null
        : Date(
            monitorScheme.period.ends.year,
            monitorScheme.period.ends.month,
            monitorScheme.period.ends.day,
          );
    result.add(
      MonitorTicket(
        id: monitorScheme.id,
        price:
            Price(amount: price.amount.toInt(), symbol: price.currency.symbol),
        displayOption: monitorScheme.displayOption,
        period: OpenPeriod(begins: begins, ends: ends),
        categoryNames: monitorScheme.categories.containsAll
            ? []
            : monitorScheme.categories.list.map((e) => e.name).toList(),
      ),
    );
  }
  for (final plan in tickets.plans) {
    final Schedule schedule = switch (plan.schedule) {
      model.OneshotSchedule oneshotSchedule => OneshotSchedule(
          date: Date(oneshotSchedule.date.year, oneshotSchedule.date.month,
              oneshotSchedule.date.day),
        ),
      model.IntervalSchedule intervalSchedule => IntervalSchedule(
          interval: intervalSchedule.interval,
          originDate: Date(
              intervalSchedule.originDate.year,
              intervalSchedule.originDate.month,
              intervalSchedule.originDate.day),
          period: OpenPeriod(
            begins: intervalSchedule.period.isStartless
                ? null
                : Date(
                    intervalSchedule.period.begins.year,
                    intervalSchedule.period.begins.month,
                    intervalSchedule.period.begins.day),
            ends: intervalSchedule.period.isEndless
                ? null
                : Date(
                    intervalSchedule.period.ends.year,
                    intervalSchedule.period.ends.month,
                    intervalSchedule.period.ends.day),
          ),
        ),
      model.WeeklySchedule weeklySchedule => WeeklySchedule(
          period: OpenPeriod(
            begins: weeklySchedule.period.isStartless
                ? null
                : Date(
                    weeklySchedule.period.begins.year,
                    weeklySchedule.period.begins.month,
                    weeklySchedule.period.begins.day),
            ends: weeklySchedule.period.isEndless
                ? null
                : Date(
                    weeklySchedule.period.ends.year,
                    weeklySchedule.period.ends.month,
                    weeklySchedule.period.ends.day),
          ),
          sunday: weeklySchedule.sunday,
          monday: weeklySchedule.monday,
          tuesday: weeklySchedule.tuesday,
          wednesday: weeklySchedule.wednesday,
          thursday: weeklySchedule.thursday,
          friday: weeklySchedule.friday,
          saturday: weeklySchedule.saturday,
        ),
      model.MonthlySchedule monthlySchedule => MonthlySchedule(
          period: OpenPeriod(
            begins: monthlySchedule.period.isStartless
                ? null
                : Date(
                    monthlySchedule.period.begins.year,
                    monthlySchedule.period.begins.month,
                    monthlySchedule.period.begins.day),
            ends: monthlySchedule.period.isEndless
                ? null
                : Date(
                    monthlySchedule.period.ends.year,
                    monthlySchedule.period.ends.month,
                    monthlySchedule.period.ends.day),
          ),
          offset: monthlySchedule.offset,
        ),
      model.AnnualSchedule annualSchedule => AnnualSchedule(
          originDate: Date(annualSchedule.originDate.year,
              annualSchedule.originDate.month, annualSchedule.originDate.day),
          period: OpenPeriod(
            begins: annualSchedule.period.isStartless
                ? null
                : Date(
                    annualSchedule.period.begins.year,
                    annualSchedule.period.begins.month,
                    annualSchedule.period.begins.day),
            ends: annualSchedule.period.isEndless
                ? null
                : Date(
                    annualSchedule.period.ends.year,
                    annualSchedule.period.ends.month,
                    annualSchedule.period.ends.day),
          ),
        ),
    };
    result.add(
      PlanTicket(
        id: plan.id,
        categoryName: plan.category.name,
        schedule: schedule,
        description: plan.description,
        price: Price(
            amount: plan.price.amount.toInt(),
            symbol: plan.price.currency.symbol),
      ),
    );
  }
  for (final estimationScheme in tickets.estimationSchemes) {
    final price = await estimationScheme.scaledEstimation();
    final begins = estimationScheme.period.isStartless
        ? null
        : Date(
            estimationScheme.period.begins.year,
            estimationScheme.period.begins.month,
            estimationScheme.period.begins.day,
          );
    final ends = estimationScheme.period.isEndless
        ? null
        : Date(
            estimationScheme.period.ends.year,
            estimationScheme.period.ends.month,
            estimationScheme.period.ends.day,
          );
    result.add(
      EstimationTicket(
        id: estimationScheme.id,
        price:
            Price(amount: price.amount.toInt(), symbol: price.currency.symbol),
        displayOption: estimationScheme.displayOption,
        categoryName: estimationScheme.category.name,
        period: OpenPeriod(begins: begins, ends: ends),
      ),
    );
  }
  for (final log in tickets.receiptLogs) {
    result.add(
      ReceiptLogTicket(
        id: log.id,
        date: Date(log.date.year, log.date.month, log.date.day),
        price: Price(
            amount: log.price.amount.toInt(),
            symbol: log.price.currency.symbol),
        description: log.description,
        categoryName: log.category.name,
        confirmed: log.confirmed,
      ),
    );
  }
  return result;
}

/// {@template fetchReceiptLogsAndMonitorsForToday}
/// fetches tickets for today
/// {@endtemplate}
Future<List<Ticket>> fetchReceiptLogsAndMonitorsForToday() async {
  final tickets = await model.TicketCollection.ticketsForToday();
  final result = <Ticket>[];
  for (final ticket in tickets.monitorSchemes) {
    final price = await ticket.getValue();
    final begins = ticket.period.isStartless
        ? null
        : Date(
            ticket.period.begins.year,
            ticket.period.begins.month,
            ticket.period.begins.day,
          );
    final ends = ticket.period.isEndless
        ? null
        : Date(
            ticket.period.ends.year,
            ticket.period.ends.month,
            ticket.period.ends.day,
          );
    result.add(
      MonitorTicket(
        id: ticket.id,
        price:
            Price(amount: price.amount.toInt(), symbol: price.currency.symbol),
        displayOption: ticket.displayOption,
        period: OpenPeriod(begins: begins, ends: ends),
        categoryNames: ticket.categories.containsAll
            ? []
            : ticket.categories.list.map((e) => e.name).toList(),
      ),
    );
  }
  for (final ticket in tickets.receiptLogs) {
    result.add(
      ReceiptLogTicket(
        id: ticket.id,
        date: Date(ticket.date.year, ticket.date.month, ticket.date.day),
        price: Price(
            amount: ticket.price.amount.toInt(),
            symbol: ticket.price.currency.symbol),
        description: ticket.description,
        categoryName: ticket.category.name,
        confirmed: ticket.confirmed,
      ),
    );
  }
  return result;
}
