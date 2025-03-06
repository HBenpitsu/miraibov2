import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:miraibo/core-model/value/period.dart';
import '../test_materials/fake_path_provider.dart';
import '../test_materials/mock_data_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:miraibo/repository/impl.dart' as repository_impl;
import 'package:miraibo/core-model/entity/category.dart' as model;
import 'package:miraibo/core-model/entity/currency.dart' as model;
import 'package:miraibo/core-model/entity/receipt_log.dart' as model;
import 'package:miraibo/core-model/entity/estimation_scheme.dart' as model;
import 'package:miraibo/core-model/entity/monitor_scheme.dart' as model;
import 'package:miraibo/core-model/entity/plan.dart' as model;
import 'package:miraibo/core-model/entity/receipt_log.dart' as model;
import 'package:miraibo/core-model/value/collection/category_collection.dart'
    as model;
import 'package:miraibo/core-model/value/collection/currency_collection.dart'
    as model;
import 'package:miraibo/core-model/value/collection/receipt_log_collection.dart'
    as model;
import 'package:miraibo/core-model/value/collection/record_collection.dart'
    as model;
import 'package:miraibo/core-model/value/collection/ticket_collection.dart'
    as model;
import 'package:miraibo/core-model/service/initialization_service.dart'
    as model;
import 'package:miraibo/external-model/service/external_data_service.dart'
    as model;
import 'package:miraibo/external-model/service/error_handling_service.dart'
    as model;

Future<void> showAllLogs(Logger logger) async {
  {
    int i = 0;
    List<model.ReceiptLog> logs = [];
    while (true) {
      final log = await model.ReceiptLogCollection.watchFor(i).first;
      if (log == null) break;
      logs.add(log);
      i++;
    }
    logger.i('all logs');
    logger.i(logs);
  }
}

void main() {
  final logger = Logger();
  final fakePathProvider = FakePathProviderPlatform();
  late final MockDataProvider provider;
  setUpAll(() {
    PathProviderPlatform.instance = fakePathProvider;
    repository_impl.bind();
  });
  test('initialization service', () async {
    await model.InitializationService.initialize();
  });
  test('error handling service', () async {
    try {
      throw Exception('exception');
    } on Exception catch (e) {
      model.ErrorHandlingService.logException(e);
    }
    try {
      throw Error();
    } on Error catch (e) {
      model.ErrorHandlingService.logError(e);
    }
    model.ErrorHandlingService.logWarning('warning');
  });
  test('model', () async {
    provider = await MockDataProvider.provide();
  });
  test('category collection', () async {
    logger.i((await model.CategoryCollection.getAll()).map((e) {
      return e.name;
    }).toList());
  });
  test('currency collection', () async {
    logger.i(await model.CurrencyCollection.getAll());
  });
  test('receipt log collection', () async {
    showAllLogs(logger);
    logger.i('unconfirmed logs');
    logger.i((await model.ReceiptLogCollection.unconfirmedLogs()).logs);
    logger.i('ignored logs');
    logger.i((await model.ReceiptLogCollection.ignoredUnconfirmedLogs()).logs);
  });
  test('log watching', () async {
    final stream1 = model.ReceiptLogCollection.watchFor(0);
    final subscription = stream1.listen((log) {
      logger.i(log);
    });
    final stream2 = model.ReceiptLogCollection.watchFor(0);
    (await stream2.first)!.update(description: 'updated');
    await Future.delayed(Duration(milliseconds: 1));
    while (true) {
      final firstLog = await model.ReceiptLogCollection.watchFor(0).first;
      if (firstLog == null) break;
      await firstLog.delete();
    }
    await Future.delayed(Duration(milliseconds: 1));
    subscription.cancel();
    await provider.makeLogs();
  });
  test('record collection', () async {
    final cur1 = await model.Currency.findOrCreate('CUR1', 1);
    var records = await model.RecordCollection.loggedRecords(
        Period.recentDays(), model.CategoryCollection.phantomAll);
    logger.i(records);
    var category = await model.Category.findOrCreate('CAT1');
    records = await model.RecordCollection.get(
        Period.nextDays(7), model.CategoryCollection.single(category));
    logger.i(records);
    logger.i(['total', records.total(cur1)]);
    logger.i(['mean', records.meanPerDays(cur1)]);
  });
  test('ticket collection', () async {
    logger.i(await model.TicketCollection.ticketsForToday());
    for (final date in Period.recentDays().dates()) {
      logger.i(await model.TicketCollection.ticketsOn(date));
    }
  });
  test('integrate currency', () async {
    logger.i(await model.CurrencyCollection.getAll());
    final cur1 = await model.Currency.find('CUR1', 10);
    final cur2 = await model.Currency.find('CUR2', 20);
    await showAllLogs(logger);
    await cur1!.integrateWith(cur2!);
    await showAllLogs(logger);
    logger.i(await model.CurrencyCollection.getAll());
  });
  test('integrate category', () async {
    showAllLogs(logger);
    logger.i(await model.CategoryCollection.getAll());
    final cat1 = await model.Category.find('CAT1');
    final cat2 = await model.Category.find('CAT2');
    await cat2!.integrateWith(cat1!);
    logger.i(await model.CategoryCollection.getAll());
    showAllLogs(logger);
  });
  tearDownAll(() async {
    // fakePathProvider.tearDown();
    logger.i(await fakePathProvider.getApplicationDocumentsPath());
  });
  test('external data service', () async {
    await model.ReceiptLogCSVService.exportCSVToFile('test.csv');
  });
}
