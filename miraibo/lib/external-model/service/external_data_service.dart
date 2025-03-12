import 'package:miraibo/middleware/csv_parser.dart';
import 'package:miraibo/repository/core.dart';
import 'package:miraibo/core-model/entity/receipt_log.dart';
import 'package:miraibo/repository/external.dart';
import 'package:miraibo/core-model/value/collection/category_collection.dart';
import 'package:miraibo/core-model/value/date.dart';
import 'package:miraibo/core-model/value/price.dart';
import 'package:miraibo/core-model/value/period.dart';
import 'package:miraibo/core-model/entity/category.dart';
import 'package:miraibo/core-model/entity/currency.dart';

class ReceiptLogCSVService {
  static final ExternalEnvironmentInterface externalEnvironment =
      ExternalEnvironmentInterface.instance;
  static final ReceiptLogRepository repository = ReceiptLogRepository.instance;

  static const String csvHeader = 'year, month, day, '
      'name_of_category, description, amount, '
      'symbol_of_currency, ratio_of_currency, confirmed\n';

  static Stream<String> _exportCSV() async* {
    yield csvHeader;
    await for (final log
        in repository.get(Period.entirePeriod, CategoryCollection.phantomAll)) {
      yield '''${CSVLineParser.encode([
            log.date.year,
            log.date.month,
            log.date.day,
            log.category.name,
            log.description,
            log.price.amount,
            log.price.currency.symbol,
            log.price.currency.ratio,
            log.confirmed,
          ])}\n''';
    }
  }

  static Future<void> exportCSVToFile(String path) async {
    await externalEnvironment.generateFile(path, _exportCSV());
  }

  /// return error message.
  /// it is null if the CSV file is successfully imported
  static Future<String?> _importCSV(Stream<String> lineStream) async {
    bool firstLine = true;
    await for (final line in lineStream) {
      if (firstLine) {
        if (line != csvHeader) {
          return 'Invalid header';
        }
        firstLine = false;
        continue;
      }

      if (line == '') continue;

      final stripped = line.substring(0, line.length - 1); // remove '\n'
      final values = CSVLineParser.parse(stripped);
      if (values.length != 9) {
        return 'Invalid number of columns ($values)';
      }
      final year = int.tryParse(values[0]);
      final month = int.tryParse(values[1]);
      final day = int.tryParse(values[2]);
      final nameOfCategory = values[3];
      final description = values[4];
      final amount = double.tryParse(values[5]);
      final nameOfCurrency = values[6];
      final ratio = double.tryParse(values[7]);
      final confirmed = values[8] == 'true';

      if (year == null || month == null || day == null) {
        return 'Invalid date: ${values[0]}-${values[1]}-${values[2]}';
      }

      final date = Date(year, month, day);
      final category = await Category.findOrCreate(nameOfCategory);

      if (ratio == null) {
        return 'Invalid currency ratio: ${values[7]}';
      }

      final currency = await Currency.findOrCreate(nameOfCurrency, ratio);

      if (amount == null) {
        return 'Invalid amount: ${values[5]}';
      }

      final price = Price(amount: amount, currency: currency);

      await ReceiptLog.create(date, price, description, category, confirmed);
    }
    return null;
  }

  static Future<String?> importCSVFromFile(String path) async {
    final lineStream = await externalEnvironment.loadFile(path);
    if (lineStream == null) {
      return 'File not found';
    }
    return await _importCSV(lineStream);
  }
}
