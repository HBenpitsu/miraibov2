import 'package:miraibo/dto/general.dart';
import 'package:miraibo/dto/schedule.dart';
import 'package:miraibo/dto/enumration.dart';

sealed class TicketSchemeInstance {
  final int id; // only id is the clue to identify the entity
  const TicketSchemeInstance({required this.id});
}

sealed class TicketScheme {
  const TicketScheme();
}

class ReceiptLogSchemeInstance extends TicketSchemeInstance {
  final Date date;
  final PriceConfig price;
  final String description;
  final Category category;
  final bool confirmed;

  const ReceiptLogSchemeInstance(
      {required super.id,
      required this.date,
      required this.price,
      required this.description,
      required this.category,
      required this.confirmed});
}

class ReceiptLogScheme extends TicketScheme {
  final Date date;
  final PriceConfig price;
  final String description;
  final Category category;
  final bool confirmed;

  const ReceiptLogScheme(
      {required this.date,
      required this.price,
      required this.description,
      required this.category,
      required this.confirmed});
}

class PlanSchemeInstance extends TicketSchemeInstance {
  final Schedule schedule;
  final PriceConfig price;
  final String description;
  final Category category;

  const PlanSchemeInstance(
      {required super.id,
      required this.schedule,
      required this.price,
      required this.description,
      required this.category});
}

class PlanScheme extends TicketScheme {
  final Schedule schedule;
  final PriceConfig price;
  final String description;
  final Category category;

  const PlanScheme(
      {required this.schedule,
      required this.price,
      required this.description,
      required this.category});
}

class EstimationSchemeInstance extends TicketSchemeInstance {
  final OpenPeriod period;
  final Currency currency;
  final EstimationDisplayOption displayOption;
  final List<Category> categories;

  const EstimationSchemeInstance(
      {required super.id,
      required this.period,
      required this.currency,
      required this.displayOption,
      required this.categories});
}

class EstimationScheme extends TicketScheme {
  final OpenPeriod period;
  final Currency currency;
  final EstimationDisplayOption displayOption;
  final List<Category> categories;

  const EstimationScheme(
      {required this.period,
      required this.currency,
      required this.displayOption,
      required this.categories});
}

class MonitorSchemeInstance extends TicketSchemeInstance {
  final OpenPeriod period;
  final Currency currency;
  final MonitorDisplayOption displayOption;
  final List<Category> categories;

  const MonitorSchemeInstance(
      {required super.id,
      required this.period,
      required this.currency,
      required this.displayOption,
      required this.categories});
}

class MonitorScheme extends TicketScheme {
  final OpenPeriod period;
  final Currency currency;
  final MonitorDisplayOption displayOption;
  final List<Category> categories;

  const MonitorScheme(
      {required this.period,
      required this.currency,
      required this.displayOption,
      required this.categories});
}

class CurrencyConfig {
  final int id;
  final String symbol;
  final double ratio;
  final bool isDefault;

  const CurrencyConfig(
      {required this.id,
      required this.symbol,
      required this.ratio,
      required this.isDefault});
}

class PriceConfig {
  final int amount;
  final int currencyId;
  final String currencySymbol;

  const PriceConfig(
      {required this.amount,
      required this.currencyId,
      required this.currencySymbol});
}
