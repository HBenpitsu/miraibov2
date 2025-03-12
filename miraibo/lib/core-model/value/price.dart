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

  Price exchangeOrKeep(Currency? currency) {
    if (currency == null) {
      return this;
    }
    return exchangeTo(currency);
  }

  Price operator *(num multiplier) {
    return Price(
      amount: amount * multiplier,
      currency: currency,
    );
  }

  Price operator /(num divisor) {
    return Price(
      amount: amount / divisor,
      currency: currency,
    );
  }

  Price operator +(Price other) {
    if (currency != other.currency) {
      throw ArgumentError('Currency mismatch');
    }
    return Price(
      amount: amount + other.amount,
      currency: currency,
    );
  }

  Price operator -(Price other) {
    if (currency != other.currency) {
      throw ArgumentError('Currency mismatch');
    }
    return Price(
      amount: amount - other.amount,
      currency: currency,
    );
  }

  @override
  String toString() => '(${currency.symbol})${amount.toStringAsFixed(2)}';
}
