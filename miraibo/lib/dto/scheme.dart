import 'package:miraibo/dto/general.dart';
import 'package:miraibo/dto/schedule.dart';
import 'package:miraibo/shared/enumeration.dart';

class ReceiptLogSchemeInstance {
  // there is an id field in addition to the fields in ReceiptLogScheme
  final int id;
  final Date date;
  final ConfigureblePrice price;
  final String description;
  final Category category;
  final bool confirmed;

  const ReceiptLogSchemeInstance(
      {required this.id,
      required this.date,
      required this.price,
      required this.description,
      required this.category,
      required this.confirmed});
}

class ReceiptLogScheme {
  final Date date;
  final ConfigureblePrice price;
  final String description;
  final Category category;
  final bool confirmed;

  const ReceiptLogScheme(
      {required this.date,
      required this.price,
      required this.description,
      required this.category,
      required this.confirmed});

  ReceiptLogSchemeInstance toInstance(int id) {
    return ReceiptLogSchemeInstance(
        id: id,
        date: date,
        price: price,
        description: description,
        category: category,
        confirmed: confirmed);
  }

  ReceiptLogScheme copyWith({
    Date? date,
    ConfigureblePrice? price,
    String? description,
    Category? category,
    bool? confirmed,
  }) {
    return ReceiptLogScheme(
      date: date ?? this.date,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      confirmed: confirmed ?? this.confirmed,
    );
  }
}

class ReceiptLogSchemePreset {
  final ConfigureblePrice price;
  final String description;
  final Category category;

  const ReceiptLogSchemePreset(
      {required this.price, required this.description, required this.category});
}

class PlanScheme {
  final Schedule schedule;
  final ConfigureblePrice price;
  final String description;
  final Category category;

  const PlanScheme(
      {required this.schedule,
      required this.price,
      required this.description,
      required this.category});

  PlanScheme copyWith({
    Schedule? schedule,
    ConfigureblePrice? price,
    String? description,
    Category? category,
  }) {
    return PlanScheme(
      schedule: schedule ?? this.schedule,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
    );
  }
}

class EstimationScheme {
  final OpenPeriod period;
  final Currency currency;
  final EstimationDisplayOption displayOption;
  final Category category;

  const EstimationScheme(
      {required this.period,
      required this.currency,
      required this.displayOption,
      required this.category});

  EstimationScheme copyWith({
    OpenPeriod? period,
    Currency? currency,
    EstimationDisplayOption? displayOption,
    Category? category,
  }) {
    return EstimationScheme(
      period: period ?? this.period,
      currency: currency ?? this.currency,
      displayOption: displayOption ?? this.displayOption,
      category: category ?? this.category,
    );
  }
}

class MonitorScheme {
  final OpenPeriod period;
  final Currency currency;
  final MonitorDisplayOption displayOption;
  final List<Category> categories;
  final bool isAllCategoriesIncluded;

  const MonitorScheme({
    required this.period,
    required this.currency,
    required this.displayOption,
    required this.categories,
    required this.isAllCategoriesIncluded,
  });

  MonitorScheme copyWith({
    OpenPeriod? period,
    Currency? currency,
    MonitorDisplayOption? displayOption,
    List<Category>? categories,
    bool? isAllCategoriesIncluded,
  }) {
    return MonitorScheme(
      period: period ?? this.period,
      currency: currency ?? this.currency,
      displayOption: displayOption ?? this.displayOption,
      categories: categories ?? this.categories,
      isAllCategoriesIncluded:
          isAllCategoriesIncluded ?? this.isAllCategoriesIncluded,
    );
  }
}

class CurrencyInstance {
  final int id;
  final String symbol;
  final double ratio;
  final bool isDefault;

  const CurrencyInstance(
      {required this.id,
      required this.symbol,
      required this.ratio,
      required this.isDefault});
}

class ConfigureblePrice {
  final int amount;
  final int currencyId;
  final String currencySymbol;

  const ConfigureblePrice(
      {required this.amount,
      required this.currencyId,
      required this.currencySymbol});
}
