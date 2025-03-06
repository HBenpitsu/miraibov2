import 'package:miraibo/core-model/entity/currency.dart';
import 'package:miraibo/core-model/value/price.dart';
import 'package:miraibo/core-model/value/date.dart';

class ReceiptRecord {
  final Price price;
  final Date date;

  const ReceiptRecord({required this.price, required this.date});

  ReceiptRecord exchangeTo(Currency currency) {
    return ReceiptRecord(
      price: price.exchangeTo(currency),
      date: date,
    );
  }

  @override
  String toString() => '$date: $price';
}
