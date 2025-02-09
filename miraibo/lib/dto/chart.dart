import 'package:miraibo/dto/general.dart';

class PieChartChip {
  final String categoryName;
  final double amount;

  const PieChartChip(this.categoryName, this.amount);
}

class AccumulatedBar {
  final Date date;
  final double amount;

  const AccumulatedBar(this.date, this.amount);
}

class SubtotalBar {
  final Date date;
  final double amount;

  const SubtotalBar(this.date, this.amount);
}
