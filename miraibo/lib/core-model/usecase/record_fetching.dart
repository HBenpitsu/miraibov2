import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/core-model/value/collection/receipt_log_collection.dart'
    as model;

/// {@template fetchLoggedReceiptRecords}
/// fetch the logged receipt records at given index
/// {@endtemplate}
Stream<ReceiptLogSchemeInstance?> fetchLoggedReceiptRecord(int index) async* {
  final logStream = model.ReceiptLogCollection.watchFor(index);
  await for (final log in logStream) {
    if (log == null) {
      yield null;
      continue;
    }
    yield ReceiptLogSchemeInstance(
      id: log.id,
      date: Date(log.date.year, log.date.month, log.date.day),
      price: ConfigureblePrice(
        amount: log.price.amount.toInt(),
        currencyId: log.price.currency.id,
        currencySymbol: log.price.currency.symbol,
      ),
      description: log.description,
      category: Category(id: log.category.id, name: log.category.name),
      confirmed: log.confirmed,
    );
  }
}
