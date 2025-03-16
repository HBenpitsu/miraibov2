import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/repository/impl.dart' as repository;
import 'package:miraibo/shared/enumeration.dart';

// <fetchEventExistenceOn>
Future<EventExistence> __fetchEventExistenceOn(Date date) {
  repository.bind();
  return usecase.fetchEventExistenceOn(date);
}

/// {@macro fetchEventExistenceOn}
Future<EventExistence> fetchEventExistenceOn(Date date) {
  return usecase.fetchEventExistenceOn(date);
  // return compute(__fetchEventExistenceOn, date);
}
// </fetchEventExistenceOn>
