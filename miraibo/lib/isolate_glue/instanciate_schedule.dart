import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/instanciate_schedule.dart'
    as usecase;
import 'package:miraibo/repository/impl.dart' as repository;

Future<void> __instanciateScheduleUntilToday(() param) {
  repository.bind();
  return usecase.instanciateScheduleUntilToday();
}

/// {@macro instanciateScheduleUntilToday}
Future<void> instanciateScheduleUntilToday() async {
  await compute(__instanciateScheduleUntilToday, ());
}
