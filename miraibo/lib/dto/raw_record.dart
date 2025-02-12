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

  const RawReceiptLog(this.id, this.date, this.price, this.description,
      this.category, this.confirmed);
}

class RawPlan {
  final int id; // only id is the clue to identify the entity
  final Schedule schedule;
  final PriceInfo price;
  final String description;
  final Category category;

  const RawPlan(
      this.id, this.schedule, this.price, this.description, this.category);
}

class RawEstimationScheme {
  final int id; // only id is the clue to identify the entity
  final OpenPeriod period;
  final PriceInfo price;
  final EstimationDisplayConfig displayConfig;
  final List<Category> categories;

  const RawEstimationScheme(
      this.id, this.period, this.price, this.displayConfig, this.categories);
}

class RawMonitorScheme {
  final int id; // only id is the clue to identify the entity
  final OpenPeriod period;
  final Price price;
  final MonitorDisplayConfig displayConfig;
  final List<Category> categories;

  const RawMonitorScheme(
      this.id, this.period, this.price, this.displayConfig, this.categories);
}
