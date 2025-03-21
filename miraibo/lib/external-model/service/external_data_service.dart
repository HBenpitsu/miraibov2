import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:miraibo/middleware/csv_handler.dart';
import 'package:miraibo/middleware/key_value.dart' show KeyValueStore;
import 'package:miraibo/middleware/relational/database.dart' show AppDatabase;
import 'package:miraibo/middleware/xml_handler.dart';
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
    await for (final log in repository.get(
      Period.entirePeriod,
      CategoryCollection.phantomAll,
    )) {
      yield '''${CSVLineHandler.encode([
            log.date.year,
            log.date.month,
            log.date.day,
            log.category.name,
            log.description,
            log.price.amount,
            log.price.currency.symbol,
            log.price.currency.ratio,
            log.confirmed
          ])}\n''';
    }
  }

  static Future<void> exportCSVToFile(String path) async {
    Logger().i('making $path/miraibo-data.csv...');
    await externalEnvironment.generateFile(
      '$path/miraibo-data.csv',
      _exportCSV(),
    );
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
      final values = CSVLineHandler.parse(stripped);
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

class BackupService {
  static final ExternalEnvironmentInterface externalEnvironment =
      ExternalEnvironmentInterface.instance;

  static Future<String?> dump(String path) async {
    final dumpTo = File('$path/miraibo-backup-file.xml');
    final IOSink sink;
    try {
      sink = dumpTo.openWrite();
    } catch (e) {
      return 'Failed to open file: $e';
    }
    final dumpStreamController = StreamController<String>();
    final subscription = dumpStreamController.stream.listen(sink.write);
    final dumper = XmlDumper(dumpStreamController.sink);
    dumper.open('meta');
    dumper.appendEnclosedContent('purpose', 'miraibo backup');
    dumper.appendEnclosedContent('scheme', '1');
    dumper.appendEnclosedContent('date', DateTime.now().toString());
    dumper.appendEnclosedContent('key-value encoding', 'base64');
    dumper.appendEnclosedContent('relational encoding', 'base64');
    dumper.close('meta');
    dumper.open('key-value');
    final kdb = KeyValueStore();
    final kdbcontent = base64Encode(utf8.encode(await kdb.dump()));
    dumper.appendContent(kdbcontent);
    dumper.close('key-value');
    dumper.open('relational');
    final rdb = AppDatabase();
    await for (final chunk in rdb.dump()) {
      dumper.appendEnclosedContent('chunk', base64Encode(chunk));
    }
    dumper.close('relational');
    dumper.done();
    await subscription.cancel();
    await sink.flush();
    await sink.close();
    return null;
  }

  static int chunkSize = 1024;

  static Stream<String> _getChunkStream(File file) async* {
    final fd = await file.open();
    while (true) {
      final chunk = await fd.read(chunkSize);
      if (chunk.isEmpty) break;
      yield utf8.decode(chunk);
    }
    await fd.close();
  }

  static Future<String?> load(String path) async {
    final loadFrom = File(path);
    try {
      final fd = (await loadFrom.open());
      await fd.read(0);
      await fd.close();
    } catch (e) {
      return 'Failed to open file: $e';
    }

    final parser = XmlParser(_getChunkStream(loadFrom));

    final fragmentBuffer = StringBuffer();
    String lastContextToken = [].toString();
    bool ready = false;

    StreamController<List<int>>? rdbChunks;
    Future<void>? rdbLoadingTask;

    await for (final (context, fragment) in parser.getFragments()) {
      if (context.toString() != lastContextToken) {
        // on context changed
        if (!ready && lastContextToken == ['meta', 'purpose'].toString()) {
          if (fragmentBuffer.toString() != 'miraibo backup') {
            return 'Invalid backup file';
          } else {
            AppDatabase rdb = AppDatabase();
            rdbChunks = StreamController<List<int>>();
            rdbLoadingTask = rdb.load(rdbChunks.stream);
            ready = true;
          }
        }
        if (ready) {
          if (lastContextToken == ['key-value'].toString()) {
            final kdb = KeyValueStore();
            await kdb
                .load(utf8.decode(base64Decode(fragmentBuffer.toString())));
          } else if (lastContextToken == ['relational', 'chunk'].toString()) {
            rdbChunks!.add(base64Decode(fragmentBuffer.toString()));
          }
        }
        fragmentBuffer.clear();
      }

      fragmentBuffer.write(fragment);

      lastContextToken = context.toString();
    }

    await rdbChunks?.close();
    await rdbLoadingTask;

    if (!ready) {
      return 'Invalid backup file';
    }

    return null;
  }
}
