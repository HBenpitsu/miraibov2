import 'package:miraibo/core-model/value/collection/plan_collection.dart';

Future<void> instanciateScheduleUntilToday() async {
  await PlanCollection.instanciate();
}
