import 'package:miraibo/core-model/service/initialization_service.dart';
import 'package:miraibo/core-model/entity/currency.dart';
import 'package:miraibo/core-model/entity/plan.dart';
import 'package:miraibo/core-model/entity/monitor_scheme.dart';
import 'package:miraibo/core-model/entity/estimation_scheme.dart';
import 'package:miraibo/core-model/entity/receipt_log.dart';
import 'package:miraibo/core-model/entity/category.dart';
import 'package:miraibo/core-model/value/collection/category_collection.dart';
import 'package:miraibo/core-model/value/date.dart';
import 'package:miraibo/core-model/value/price.dart';
import 'package:miraibo/core-model/value/schedule.dart';
import 'package:miraibo/core-model/value/period.dart';
import 'package:miraibo/shared/enumeration.dart';

class MockDataProvider {
  Future<void> makeLogs() async {
    final currency1 = await Currency.findOrCreate('CUR1', 10.0);
    final currency2 = await Currency.findOrCreate('CUR2', 20.0);
    final currency3 = await Currency.findOrCreate('CUR3', 30.0);
    final category1 = await Category.findOrCreate('CAT1');
    final category2 = await Category.findOrCreate('CAT2');
    final category3 = await Category.findOrCreate('CAT3');
    ReceiptLog.create(
      Date.today(),
      Price(amount: 100.0, currency: currency1),
      'Receipt 1',
      category1,
      true,
    );
    ReceiptLog.create(
      Date.today(),
      Price(amount: 100.0, currency: currency2),
      'Receipt 2',
      category2,
      true,
    );
    ReceiptLog.create(
      Date.today(),
      Price(amount: 100.0, currency: currency3),
      'Receipt 3',
      category3,
      true,
    );
    ReceiptLog.create(
      Date.today(),
      Price(amount: 100.0, currency: currency1),
      'Receipt 4 - unconfirmed',
      category1,
      false,
    );
    ReceiptLog.create(
      Date.today(),
      Price(amount: 100.0, currency: currency1),
      'Receipt 5 - unconfirmed',
      category1,
      false,
    );
    ReceiptLog.create(
      Date.today().withDelta(days: -1),
      Price(amount: 100.0, currency: currency1),
      'Receipt 6 - yesterday',
      category1,
      true,
    );
    ReceiptLog.create(
      Date.today().withDelta(days: -3),
      Price(amount: 100.0, currency: currency1),
      'Receipt 7 - 3 days ago',
      category1,
      true,
    );
    ReceiptLog.create(
      Date.today().withDelta(days: -7),
      Price(amount: 100.0, currency: currency1),
      'Receipt 8 - 7 days ago',
      category1,
      true,
    );
    ReceiptLog.create(
      Date.today().withDelta(days: -30),
      Price(amount: 100.0, currency: currency1),
      'Receipt 9 - 30 days ago',
      category1,
      true,
    );
    ReceiptLog.create(
      Date.today().withDelta(days: -3),
      Price(amount: 100.0, currency: currency1),
      'Receipt 10 - 3 days ago, unconfirmed',
      category1,
      false,
    );
    ReceiptLog.create(
      Date.today().withDelta(days: -7),
      Price(amount: 100.0, currency: currency1),
      'Receipt 11 - 7 days ago, unconfirmed',
      category1,
      false,
    );
    ReceiptLog.create(
      Date.today().withDelta(days: -30),
      Price(amount: 100.0, currency: currency1),
      'Receipt 12 - 30 days ago, unconfirmed',
      category1,
      false,
    );
  }

  Future<void> makePlans() async {
    final currency1 = await Currency.findOrCreate('CUR1', 10.0);
    final currency2 = await Currency.findOrCreate('CUR2', 20.0);
    final currency3 = await Currency.findOrCreate('CUR3', 30.0);
    final category1 = await Category.findOrCreate('CAT1');
    final category2 = await Category.findOrCreate('CAT2');
    final category3 = await Category.findOrCreate('CAT3');
    Plan.create(
      OneshotSchedule(date: Date.today()),
      Price(amount: 100.0, currency: currency1),
      'Plan 1 - oneshot schedule',
      category1,
    );
    Plan.create(
      IntervalSchedule(
          originDate: Date.today(), period: Period.nextDays(7), interval: 1),
      Price(amount: 100.0, currency: currency2),
      'Plan 2 - interval schedule',
      category2,
    );
    Plan.create(
      WeeklySchedule(
        period: Period.nextDays(30),
        sunday: true,
        monday: false,
        tuesday: true,
        wednesday: false,
        thursday: true,
        friday: false,
        saturday: true,
      ),
      Price(amount: 100.0, currency: currency3),
      'Plan 3 - weekly schedule',
      category3,
    );
    Plan.create(
      MonthlySchedule(
        period: Period.nextDays(365),
        offset: 15,
      ),
      Price(amount: 100.0, currency: currency1),
      'Plan 4 - monthly schedule +15',
      category1,
    );
    Plan.create(
      MonthlySchedule(
        period: Period.nextDays(365),
        offset: -1,
      ),
      Price(amount: 100.0, currency: currency1),
      'Plan 5 - monthly schedule -1',
      category1,
    );
    Plan.create(
      AnnualSchedule(
          originDate: Date.today().withDelta(days: 3),
          period: Period.nextDays(365)),
      Price(amount: 100.0, currency: currency1),
      'Plan 6 - annual schedule',
      category1,
    );
  }

  Future<void> makeMonitorSchemes() async {
    final currency1 = await Currency.findOrCreate('CUR1', 10.0);
    final currency2 = await Currency.findOrCreate('CUR2', 20.0);
    final currency3 = await Currency.findOrCreate('CUR3', 30.0);
    final category1 = await Category.findOrCreate('CAT1');
    final category2 = await Category.findOrCreate('CAT2');
    final category3 = await Category.findOrCreate('CAT3');
    MonitorScheme.create(
      Period(
        begins: Date.today().withDelta(years: -1),
        ends: Date.today().withDelta(years: 1),
      ),
      currency1,
      MonitorDisplayOption.meanInWeeks,
      CategoryCollection.single(category1),
    );
    MonitorScheme.create(
      Period(
        begins: Date.today().withDelta(years: -1),
        ends: Date.today().withDelta(years: 1),
      ),
      currency2,
      MonitorDisplayOption.meanInMonths,
      CategoryCollection.single(category2),
    );
    MonitorScheme.create(
      Period(
        begins: Date.today().withDelta(years: -1),
        ends: Date.today().withDelta(years: 1),
      ),
      currency3,
      MonitorDisplayOption.meanInYears,
      CategoryCollection.single(category3),
    );
    MonitorScheme.create(
      Period(
        begins: Date.today().withDelta(years: -1),
        ends: Date.today().withDelta(years: 1),
      ),
      currency3,
      MonitorDisplayOption.summation,
      CategoryCollection.phantomAll,
    );
  }

  Future<void> makeEstimationSchemes() async {
    final currency1 = await Currency.findOrCreate('CUR1', 10.0);
    final currency2 = await Currency.findOrCreate('CUR2', 20.0);
    final currency3 = await Currency.findOrCreate('CUR3', 30.0);
    final category1 = await Category.findOrCreate('CAT1');
    final category2 = await Category.findOrCreate('CAT2');
    final category3 = await Category.findOrCreate('CAT3');
    EstimationScheme.create(
      Period(
        begins: Date.today().withDelta(years: -1),
        ends: Date.today().withDelta(years: 1),
      ),
      currency1,
      EstimationDisplayOption.perDay,
      category1,
    );
    EstimationScheme.create(
      Period(
        begins: Date.today().withDelta(years: -1),
        ends: Date.today().withDelta(years: 1),
      ),
      currency1,
      EstimationDisplayOption.perWeek,
      category1,
    );
    EstimationScheme.create(
      Period(
        begins: Date.today().withDelta(years: -1),
        ends: Date.today().withDelta(years: 1),
      ),
      currency2,
      EstimationDisplayOption.perMonth,
      category2,
    );
    EstimationScheme.create(
      Period(
        begins: Date.today().withDelta(years: -1),
        ends: Date.today().withDelta(years: 1),
      ),
      currency3,
      EstimationDisplayOption.perYear,
      category3,
    );
  }

  static Future<MockDataProvider> provide() async {
    await InitializationService.initialize();
    final provider = MockDataProvider();
    await provider.makeLogs();
    await provider.makePlans();
    await provider.makeMonitorSchemes();
    await provider.makeEstimationSchemes();
    return provider;
  }
}
