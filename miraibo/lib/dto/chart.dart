import 'package:miraibo/dto/general.dart';

sealed class ChartChip {
  const ChartChip();
}

class PieChartChip extends ChartChip {
  final String categoryName;
  final double amount;

  const PieChartChip(this.categoryName, this.amount);
}

class AccumulatedBar extends ChartChip {
  final Date date;
  final double amount;

  const AccumulatedBar(this.date, this.amount);
}

class SubtotalBar extends ChartChip {
  final Date date;
  final double amount;

  const SubtotalBar(this.date, this.amount);
}
