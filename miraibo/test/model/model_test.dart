import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:miraibo/model/value/period.dart';
import '../test_materials/fake_path_provider.dart';
import '../test_materials/mock_data_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:miraibo/middleware/repository_impl.dart' as repository_impl;
import 'package:miraibo/model/entity/category.dart' as model;
import 'package:miraibo/model/entity/currency.dart' as model;
import 'package:miraibo/model/entity/receipt_log.dart' as model;
import 'package:miraibo/model/entity/estimation_scheme.dart' as model;
import 'package:miraibo/model/entity/monitor_scheme.dart' as model;
import 'package:miraibo/model/entity/plan.dart' as model;
import 'package:miraibo/model/entity/receipt_log.dart' as model;
import 'package:miraibo/model/value/collection/category_collection.dart'
    as model;
import 'package:miraibo/model/value/collection/currency_collection.dart'
    as model;
import 'package:miraibo/model/value/collection/receipt_log_collection.dart'
    as model;
import 'package:miraibo/model/value/collection/record_collection.dart' as model;
import 'package:miraibo/model/value/collection/ticket_collection.dart' as model;
import 'package:miraibo/model/service/initialization_service.dart' as model;
import 'package:miraibo/model/service/external_data_service.dart' as model;
import 'package:miraibo/model/service/error_handling_service.dart' as model;

void main() {
  final logger = Logger();
  final fakePathProvider = FakePathProviderPlatform();
  late final MockDataProvider provider;
  setUpAll(() {
    PathProviderPlatform.instance = fakePathProvider;
    repository_impl.bind();
  });
  test('create mock date', () async {
    provider = await MockDataProvider.provide();
  });
  test('category collection', () async {
    logger.i((await model.CategoryCollection.getAll()).map((e) {
      return e.name;
    }).toList());
  });
  test('currency collection', () async {
    logger.i((await model.CurrencyCollection.getAll()).map((e) {
      return e.symbol;
    }).toList());
  });
  test('receipt log collection', () async {
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
      firstLog.delete();
    }
    await Future.delayed(Duration(milliseconds: 1));
    subscription.cancel();
    await provider.makeLogs();
  });
  test('record collection', () async {
    var records = await model.RecordCollection.loggedRecords(
        Period.recentDays(), model.CategoryCollection.phantomAll);
    logger.i(records);
    var category = await model.Category.findOrCreate('CAT1');
    records = await model.RecordCollection.get(
        Period.nextDays(7), model.CategoryCollection.single(category));
    logger.i(records);
  });
  tearDownAll(() {
    fakePathProvider.tearDown();
  });
}
