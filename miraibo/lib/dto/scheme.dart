import 'package:miraibo/dto/general.dart';
import 'package:miraibo/dto/schedule.dart';
import 'package:miraibo/dto/enumration.dart';

class ReceiptLogScheme {
  final int id; // only id is the clue to identify the entity
  final Date date;
  final PriceConfig price;
  final String description;
  final Category category;
  final bool confirmed;

  const ReceiptLogScheme(
      {required this.id,
      required this.date,
      required this.price,
      required this.description,
      required this.category,
      required this.confirmed});
}

class PlanScheme {
  final int id; // only id is the clue to identify the entity
  final Schedule schedule;
  final PriceConfig price;
  final String description;
  final Category category;

  const PlanScheme(
      {required this.id,
      required this.schedule,
      required this.price,
      required this.description,
      required this.category});
}

class EstimationScheme {
  final int id; // only id is the clue to identify the entity
  final OpenPeriod period;
  final Currency currency;
  final EstimationDisplayOption displayOption;
  final List<Category> categories;

  const EstimationScheme(
      {required this.id,
      required this.period,
      required this.currency,
      required this.displayOption,
      required this.categories});
}

class MonitorScheme {
  final int id; // only id is the clue to identify the entity
  final OpenPeriod period;
  final Currency currency;
  final MonitorDisplayOption displayOption;
  final List<Category> categories;

  const MonitorScheme(
      {required this.id,
      required this.period,
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
