import 'package:miraibo/core-model/entity/currency.dart';

class Price {
  final double amount;
  final Currency currency;

  const Price({required this.amount, required this.currency});

  Price exchangeTo(Currency currency) {
    if (this.currency.ratio == 0) {
      return Price(
        amount: 0,
        currency: currency,
      );
    }
    return Price(
      amount: amount.toDouble() * currency.ratio / this.currency.ratio,
      currency: currency,
    );
  }

  @override
  String toString() => '(${currency.symbol})${amount.toStringAsFixed(2)}';
}
