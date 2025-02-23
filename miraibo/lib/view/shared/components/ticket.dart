import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;

class InteractiveTicket extends StatelessWidget {
  final dto.Ticket data;
  final void Function(dto.Ticket) onTap;
  const InteractiveTicket({required this.data, required this.onTap, super.key});

  static const double maxTicketWidth = 330;

  Widget content(BuildContext context) {
    switch (data) {
      case dto.ReceiptLogTicket data:
        return LogTicket(
            categories: [data.categoryName],
            description: data.description,
            amount: data.price.amount,
            currencySymbol: data.price.symbol,
            confirmed: data.confirmed,
            timestamp: data.date);
      case dto.PlanTicket data:
        return PlanTicket(
            categories: [data.categoryName],
            description: data.description,
            amount: data.price.amount,
            currencySymbol: data.price.symbol,
            schedule: data.schedule);
      case dto.EstimationTicket data:
        return EstimateTicket(
            categories: data.categoryNames,
            amount: data.price.amount,
            currencySymbol: data.price.symbol,
            displayOption: data.displayOption,
            period: data.period);
      case dto.MonitorTicket data:
        return MonitorTicket(
            categories: data.categoryNames,
            amount: data.price.amount,
            currencySymbol: data.price.symbol,
            displayOption: data.displayOption,
            period: data.period);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(data),
      child: content(context),
    );
  }
}

class LogTicket extends StatelessWidget {
  final List<String> categories;
  final String description;
  final int amount;
  final String currencySymbol;
  final bool confirmed;
  final dto.Date timestamp;
  const LogTicket(
      {required this.categories,
      required this.description,
      required this.amount,
      required this.currencySymbol,
      required this.confirmed,
      required this.timestamp,
      super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final supplimentaryTexts = [
      if (!confirmed) 'unconfirmed',
      if (amount < 0) 'income',
    ];
    return TicketAppearanceTemplate(
      ticketType: 'Log',
      categories: categories,
      amount: amount,
      currencySymbol: currencySymbol +
          (supplimentaryTexts.isNotEmpty
              ? ' (${supplimentaryTexts.join(', ')})'
              : ''),
      description: description,
      timeInfo: '${timestamp.year}-${timestamp.month}-${timestamp.day}',
      priceBackgroundColor: colorScheme.surfaceContainerHighest,
    );
  }
}

class PlanTicket extends StatelessWidget {
  final List<String> categories;
  final String description;
  final int amount;
  final String currencySymbol;
  final dto.Schedule schedule;
  const PlanTicket(
      {required this.categories,
      required this.description,
      required this.amount,
      required this.currencySymbol,
      required this.schedule,
      super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TicketAppearanceTemplate(
      ticketType: 'Plan',
      categories: categories,
      amount: amount,
      currencySymbol: currencySymbol + (amount < 0 ? ' (income)' : ''),
      description: description,
      timeInfo: makeScheduleString(schedule),
      priceBackgroundColor: colorScheme.secondaryContainer,
      priceColor: colorScheme.secondary,
      ticketTypeColor: colorScheme.secondary,
      timeStampColor: colorScheme.secondary,
    );
  }
}

class EstimateTicket extends StatelessWidget {
  final List<String> categories;
  final int amount;
  final String currencySymbol;
  final dto.EstimationDisplayOption displayOption;
  final dto.OpenPeriod period;
  const EstimateTicket(
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
    final colorScheme = Theme.of(context).colorScheme;
    return TicketAppearanceTemplate(
      ticketType: 'Estimate',
      categories: categories,
      amount: amount,
      currencySymbol: currencySymbol + (amount < 0 ? ' (income)' : ''),
      description: amount < 0
          ? 'is earned for the categories recently. This trend would continue'
          : 'is spent for the categories recently. This trend would continue',
      timeInfo: makePeriodString(period),
      priceBackgroundColor: colorScheme.tertiaryContainer,
      priceColor: colorScheme.tertiary,
      ticketTypeColor: colorScheme.tertiary,
      timeStampColor: colorScheme.tertiary,
    );
  }
}

class MonitorTicket extends StatelessWidget {
  final List<String> categories;
  final int amount;
  final String currencySymbol;
  final dto.MonitorDisplayOption displayOption;
  final dto.OpenPeriod period;
  const MonitorTicket(
      {required this.categories,
      required this.amount,
      required this.currencySymbol,
      required this.displayOption,
      required this.period,
      super.key});

  String makeDescription() {
    if (amount < 0) {
      switch (displayOption) {
        case dto.MonitorDisplayOption.meanInDays:
        case dto.MonitorDisplayOption.meanInWeeks:
        case dto.MonitorDisplayOption.meanInMonths:
        case dto.MonitorDisplayOption.meanInYears:
          return 'would be earned for the categories in average';
        case dto.MonitorDisplayOption.quartileMeanInDays:
        case dto.MonitorDisplayOption.quartileMeanInWeeks:
        case dto.MonitorDisplayOption.quartileMeanInMonths:
        case dto.MonitorDisplayOption.quartileMeanInYears:
          return 'would be earned for the categories in average excluding outliers';
        case dto.MonitorDisplayOption.summation:
          return 'would be earned for the categories in total';
      }
    } else {
      switch (displayOption) {
        case dto.MonitorDisplayOption.meanInDays:
        case dto.MonitorDisplayOption.meanInWeeks:
        case dto.MonitorDisplayOption.meanInMonths:
        case dto.MonitorDisplayOption.meanInYears:
          return 'would be spent for the categories in average';
        case dto.MonitorDisplayOption.quartileMeanInDays:
        case dto.MonitorDisplayOption.quartileMeanInWeeks:
        case dto.MonitorDisplayOption.quartileMeanInMonths:
        case dto.MonitorDisplayOption.quartileMeanInYears:
          return 'would be  spent for the categories in average excluding outliers';
        case dto.MonitorDisplayOption.summation:
          return 'would be  spent for the categories in total';
      }
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
    return TicketAppearanceTemplate(
      ticketType: 'Monitor',
      categories: categories,
      amount: amount,
      currencySymbol: currencySymbol + (amount < 0 ? ' (income)' : ''),
      description: makeDescription(),
      timeInfo: makePeriodString(period),
    );
  }
}

class TicketAppearanceTemplate extends StatelessWidget {
  static const double ticketWidth = 330;
  final String ticketType;
  final List<String> categories;
  final String description;
  final int amount;
  final String currencySymbol;
  final String timeInfo;
  final Color? cardColor;
  final Color? priceBackgroundColor;
  final Color? priceColor;
  final Color? descriptionColor;
  final Color? ticketTypeColor;
  final Color? timeStampColor;
  static const double contentPadding = 6;
  static const double priceSpacing = 10;
  static const double amountFontSize = 40;
  static const double currencyFontSize = 20;
  const TicketAppearanceTemplate(
      {required this.ticketType,
      required this.categories,
      required this.amount,
      required this.currencySymbol,
      required this.description,
      required this.timeInfo,
      this.cardColor,
      this.priceBackgroundColor,
      this.priceColor,
      this.descriptionColor,
      this.ticketTypeColor,
      this.timeStampColor,
      super.key});

  List<Widget> content(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final priceLabel = Container(
      color: priceBackgroundColor ?? colorScheme.primaryContainer,
      width: double.infinity,
      child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text('${amount.abs()}',
                style: TextStyle(
                    color: priceColor ?? colorScheme.primary,
                    fontSize: amountFontSize,
                    fontWeight: FontWeight.w300)),
            const SizedBox(width: priceSpacing),
            Text(currencySymbol,
                style: TextStyle(
                    color: priceColor ?? colorScheme.primary,
                    fontSize: currencyFontSize,
                    fontWeight: FontWeight.w300)),
          ]),
    );
    return [
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            ticketType,
            style: TextStyle(color: ticketTypeColor ?? colorScheme.primary),
          )),
      Align(
          alignment: Alignment.centerRight,
          child: Text(
            categories.isEmpty ? 'for all categories' : categories.join(', '),
            style: TextStyle(color: descriptionColor ?? colorScheme.onSurface),
            textAlign: TextAlign.right,
          )),
      const Divider(),
      priceLabel,
      const Divider(),
      Align(
          alignment: Alignment.center,
          child: Text(description,
              style:
                  TextStyle(color: descriptionColor ?? colorScheme.onSurface))),
      Align(
          alignment: Alignment.centerRight,
          child: Text(timeInfo,
              style: TextStyle(
                color: timeStampColor ?? colorScheme.primary,
              ),
              textAlign: TextAlign.right)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor ?? Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
          padding: const EdgeInsets.all(contentPadding),
          child: SizedBox(
              width: ticketWidth,
              child: Column(
                  mainAxisSize: MainAxisSize.min, children: content(context)))),
    );
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
      final weekdays = [
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
      return 'every ${schedule.originDate.month}-${schedule.originDate.day} ${makePeriodString(schedule.period)}';
  }
}
