import 'package:miraibo/repository/core.dart';
import 'package:miraibo/core-model/value/date.dart';
import 'package:miraibo/core-model/value/period.dart';
import 'package:miraibo/core-model/value/collection/category_collection.dart';
import 'package:miraibo/core-model/entity/plan.dart';
import 'package:miraibo/core-model/entity/receipt_log.dart';

class PlanCollection {
  static final PlanRepository _repository = PlanRepository.instance;
  final List<Plan> lsit;

  PlanCollection(this.lsit);

  static Future<void> instanciate() async {
    final lastInstanciatedAt = await _repository.getLastInstanciatedDate();
    final today = Date.today();
    final instanciationPeriod = Period(begins: lastInstanciatedAt, ends: today);
    final Map<Date, List<int>> alreadyInstanciatedOnes = {};
    for (final date in instanciationPeriod.dates()) {
      alreadyInstanciatedOnes[date] = await _repository.instanciatedPlans(date);
    }
    final planStream =
        _repository.get(instanciationPeriod, CategoryCollection.phantomAll);
    await for (final plan in planStream) {
      final dates = plan.schedule.getScheduledDates(instanciationPeriod);
      for (final date in dates) {
        if (alreadyInstanciatedOnes[date]!.contains(plan.id)) continue;
        ReceiptLog.create(
            date, plan.price, plan.description, plan.category, false);
      }
    }
    await _repository.setLastInstanciatedDate(today);
  }
}
