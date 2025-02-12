import 'package:miraibo/dto/general.dart';
import 'package:miraibo/dto/schedule.dart';
import 'package:miraibo/dto/enumration.dart';

class RawReceiptLog {
  final int id; // only id is the clue to identify the entity
  final Date date;
  final PriceInfo price;
  final String description;
  final Category category;
  final bool confirmed;

  const RawReceiptLog(
      {required this.id,
      required this.date,
      required this.price,
      required this.description,
      required this.category,
      required this.confirmed});
}

class RawPlan {
  final int id; // only id is the clue to identify the entity
  final Schedule schedule;
  final PriceInfo price;
  final String description;
  final Category category;

  const RawPlan(
      {required this.id,
      required this.schedule,
      required this.price,
      required this.description,
      required this.category});
}

class RawEstimationScheme {
  final int id; // only id is the clue to identify the entity
  final OpenPeriod period;
  final PriceInfo price;
  final EstimationDisplayConfig displayConfig;
  final List<Category> categories;

  const RawEstimationScheme(
      {required this.id,
      required this.period,
      required this.price,
      required this.displayConfig,
      required this.categories});
}

class RawMonitorScheme {
  final int id; // only id is the clue to identify the entity
  final OpenPeriod period;
  final Price price;
  final MonitorDisplayConfig displayConfig;
  final List<Category> categories;

  const RawMonitorScheme(
      {required this.id,
      required this.period,
      required this.price,
      required this.displayConfig,
      required this.categories});
}
