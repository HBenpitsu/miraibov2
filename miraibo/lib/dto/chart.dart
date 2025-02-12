import 'package:miraibo/dto/general.dart';

sealed class ChartChip {
  const ChartChip();
}

class PieChartChip extends ChartChip {
  final String categoryName;
  final double amount;

  const PieChartChip({required this.categoryName, required this.amount});
}

class AccumulatedBar extends ChartChip {
  final Date date;
  final double amount;

  const AccumulatedBar({required this.date, required this.amount});
}

class SubtotalBar extends ChartChip {
  final Date date;
  final double amount;

  const SubtotalBar({required this.date, required this.amount});
}
