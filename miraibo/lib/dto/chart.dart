import 'package:miraibo/dto/general.dart';

sealed class ChartChip {
  const ChartChip();
}

class RatioValue extends ChartChip {
  final String categoryName;
  final double amount;
  final double ratio;

  const RatioValue(
      {required this.categoryName, required this.amount, required this.ratio});
}

class AccumulatedValue extends ChartChip {
  final Date date;
  final double amount;

  const AccumulatedValue({required this.date, required this.amount});
}

class SubtotalValue extends ChartChip {
  final Date date;
  final double amount;

  const SubtotalValue({required this.date, required this.amount});
}
