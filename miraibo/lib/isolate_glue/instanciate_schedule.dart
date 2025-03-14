import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/instanciate_schedule.dart'
    as usecase;

Future<void> __instanciateScheduleUntilToday(() param) {
  return usecase.instanciateScheduleUntilToday();
}

/// {@macro instanciateScheduleUntilToday}
Future<void> instanciateScheduleUntilToday() async {
  await compute(__instanciateScheduleUntilToday, ());
}
