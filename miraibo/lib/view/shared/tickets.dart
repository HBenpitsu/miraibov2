import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;

class Ticket extends StatelessWidget {
  final dto.Ticket data;
  final void Function(dto.Ticket) onTap;
  const Ticket({required this.data, required this.onTap, super.key});

  static const double maxTicketWidth = 330;
  static const double minTicketHeight = 180;

  double width(BuildContext context) {
    return min(maxTicketWidth, MediaQuery.of(context).size.width);
  }

  @override
  Widget build(BuildContext context) {
    switch (data) {
      case dto.ReceiptLogTicket data:
        return LogTicketContent(
            categories: [data.categoryName],
            description: data.description,
            amount: data.price.amount,
            currencySymbol: data.price.symbol,
            timestamp: data.date);
      case dto.PlanTicket data:
        return PlanTicketContent(
            categories: [data.categoryName],
            description: data.description,
            amount: data.price.amount,
            currencySymbol: data.price.symbol,
            schedule: data.schedule);
      case dto.EstimationTicket data:
        return EstimateTicketContent(
            categories: data.categoryNames,
            amount: data.price.amount,
            currencySymbol: data.price.symbol,
            displayOption: data.displayOption,
            period: data.period);
      case dto.MonitorTicket data:
        return MonitorTicketContent(
            categories: data.categoryNames,
            amount: data.price.amount,
            currencySymbol: data.price.symbol,
            displayOption: data.displayOption,
            period: data.period);
    }
  }
}

class LogTicketContent extends StatelessWidget {
  final List<String> categories;
  final String description;
  final int amount;
  final String currencySymbol;
  final dto.Date timestamp;
  const LogTicketContent(
      {required this.categories,
      required this.description,
      required this.amount,
      required this.currencySymbol,
      required this.timestamp,
      super.key});
  @override
  Widget build(BuildContext context) {
    return TicketContentTemplate(
        ticketType: 'Log',
        categories: categories,
        amount: amount,
        currencySymbol: currencySymbol,
        description: description,
        timeInfo: '${timestamp.year}-${timestamp.month}-${timestamp.day}');
  }
}

class PlanTicketContent extends StatelessWidget {
  final List<String> categories;
  final String description;
  final int amount;
  final String currencySymbol;
  final dto.Schedule schedule;
  const PlanTicketContent(
      {required this.categories,
      required this.description,
      required this.amount,
      required this.currencySymbol,
      required this.schedule,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TicketContentTemplate(
      ticketType: 'Plan',
      categories: categories,
      amount: amount,
      currencySymbol: currencySymbol,
      description: description,
      timeInfo: makeScheduleString(schedule),
    );
  }
}

class EstimateTicketContent extends StatelessWidget {
  final List<String> categories;
  final int amount;
  final String currencySymbol;
  final dto.EstimationDisplayOption displayOption;
  final dto.OpenPeriod period;
  const EstimateTicketContent(
      {required this.categories,
      required this.amount,
      required this.currencySymbol,
      required this.displayOption,
      required this.period,
      super.key});
  @override
  Widget build(BuildContext context) {
    var currencySymbol = this.currencySymbol;
    switch (displayOption) {
      case dto.EstimationDisplayOption.perDay:
        currencySymbol += '/day';
      case dto.EstimationDisplayOption.perWeek:
        currencySymbol += '/week';
      case dto.EstimationDisplayOption.perMonth:
        currencySymbol += '/month';
      case dto.EstimationDisplayOption.perYear:
        currencySymbol += '/year';
    }
    return TicketContentTemplate(
      ticketType: 'Estimate',
      categories: categories,
      amount: amount,
      currencySymbol: currencySymbol,
      description:
          'is spent for the categories recently. This trend would continue',
      timeInfo: makePeriodString(period),
    );
  }
}

class MonitorTicketContent extends StatelessWidget {
  final List<String> categories;
  final int amount;
  final String currencySymbol;
  final dto.MonitorDisplayOption displayOption;
  final dto.OpenPeriod period;
  const MonitorTicketContent(
      {required this.categories,
      required this.amount,
      required this.currencySymbol,
      required this.displayOption,
      required this.period,
      super.key});

  String makeDescription() {
    switch (displayOption) {
      case dto.MonitorDisplayOption.meanInDays:
      case dto.MonitorDisplayOption.meanInWeeks:
      case dto.MonitorDisplayOption.meanInMonths:
        return 'is spent for the categories in average';
      case dto.MonitorDisplayOption.quartileMeanInDays:
      case dto.MonitorDisplayOption.quartileMeanInWeeks:
      case dto.MonitorDisplayOption.quartileMeanInMonths:
        return 'is spent for the categories in average excluding outliers';
      case dto.MonitorDisplayOption.summation:
        return 'is spent for the categories in total';
    }
  }

  @override
  Widget build(BuildContext context) {
    var currencySymbol = this.currencySymbol;
    switch (displayOption) {
      case dto.MonitorDisplayOption.meanInDays:
      case dto.MonitorDisplayOption.quartileMeanInDays:
        currencySymbol += '/day';
      case dto.MonitorDisplayOption.meanInWeeks:
      case dto.MonitorDisplayOption.quartileMeanInWeeks:
        currencySymbol += '/week';
      case dto.MonitorDisplayOption.meanInMonths:
      case dto.MonitorDisplayOption.quartileMeanInMonths:
        currencySymbol += '/month';
      default:
    }
    return TicketContentTemplate(
      ticketType: 'Monitor',
      categories: categories,
      amount: amount,
      currencySymbol: currencySymbol,
      description: makeDescription(),
      timeInfo: makePeriodString(period),
    );
  }
}

class TicketContentTemplate extends StatelessWidget {
  static const double maxTicketWidth = 330;
  static const double minTicketHeight = 180;
  final String ticketType;
  final List<String> categories;
  final String description;
  final int amount;
  final String currencySymbol;
  final String timeInfo;
  const TicketContentTemplate(
      {required this.ticketType,
      required this.categories,
      required this.amount,
      required this.currencySymbol,
      required this.description,
      required this.timeInfo,
      super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: SizedBox(
            width: Ticket.maxTicketWidth,
            height: Ticket.minTicketHeight,
            child: Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(ticketType),
                      Text(categories.isEmpty
                          ? 'all of categories'
                          : categories.join(', ')),
                    ],
                  ),
                  Text('$amount $currencySymbol'),
                  Text(description),
                  Text(timeInfo),
                ],
              ),
            )));
  }
}

String makeDateString(dto.Date date) {
  return '${date.year}-${date.month}-${date.day}';
}

String makePeriodString(dto.OpenPeriod period) {
  switch ((period.begins, period.ends)) {
    case (dto.Date begins, dto.Date ends):
      return 'from ${makeDateString(begins)} to ${makeDateString(ends)}';
    case (dto.Date begins, null):
      return 'from ${makeDateString(begins)}';
    case (null, dto.Date ends):
      return 'until ${makeDateString(ends)}';
    case (null, null):
      return '';
    default:
      throw Exception('Illegal situation');
  }
}

String convertIntoOrdinal(int number) {
  final numberString = number.toString();
  switch (numberString[numberString.length - 1]) {
    case '1':
      return '${numberString}st';
    case '2':
      return '${numberString}nd';
    case '3':
      return '${numberString}rd';
    default:
      return '${numberString}th';
  }
}

String makeScheduleString(dto.Schedule schedule) {
  switch (schedule) {
    case dto.OneshotSchedule schedule:
      return 'on ${schedule.date.year}-${schedule.date.month}-${schedule.date.day}';
    case dto.IntervalSchedule schedule:
      return 'every ${schedule.interval} days ${makePeriodString(schedule.period)}';
    case dto.WeeklySchedule schedule:
      var weekdays = [
        if (schedule.sunday) 'Sun.',
        if (schedule.monday) 'Mon.',
        if (schedule.tuesday) 'Tue.',
        if (schedule.wednesday) 'Wed.',
        if (schedule.thursday) 'Thu.',
        if (schedule.friday) 'Fri.',
        if (schedule.saturday) 'Sat.'
      ];
      return 'every ${weekdays.join(' ')} ${makePeriodString(schedule.period)}';
    case dto.MonthlySchedule schedule:
      if (schedule.offset < 0) {
        final dayString = convertIntoOrdinal(-schedule.offset);
        return 'every $dayString to the last day ${makePeriodString(schedule.period)}';
      }
      final dayString = convertIntoOrdinal(schedule.offset + 1);
      return 'every $dayString day ${makePeriodString(schedule.period)}';
    case dto.AnnualSchedule schedule:
      return 'every ${schedule.originDate.year}-${schedule.originDate.month} ${makePeriodString(schedule.period)}';
  }
}
