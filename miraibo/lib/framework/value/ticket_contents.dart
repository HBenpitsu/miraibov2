import 'dart:io';

import 'package:miraibo/framework/entity/category.dart';
import 'package:miraibo/framework/value/date_time.dart';

// <log>
class LogContent {
  final int amount;
  final String description;
  final Category category;
  final DateTime date;
  final bool confirmed;
  final File? image;

  const LogContent({
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
    required this.confirmed,
    this.image,
  });
}
// </log>

// <estimation>
class EstimationContent {
  final String description;
  final List<Category> categories;
  final Period period;
  final EstimationContentScalingOption scalingOption;

  const EstimationContent({
    required this.description,
    required this.categories,
    required this.period,
    required this.scalingOption,
  });
}

enum EstimationContentScalingOption {
  weekly,
  monthly,
  quarterly,
  semesterly,
  yearly,
}
// </estimation>

// <schedule>
class ScheduleContent {
  final int amount;
  final String description;
  final Category category;
  final Period period;

  const ScheduleContent({
    required this.amount,
    required this.description,
    required this.category,
    required this.period,
  });
}
// </schedule>

// <display>
class DisplayContent {}
// </display>