import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/repository/impl.dart' as repository;

// <fetchEventExistenceOn>
Future<void> __fetchEventExistenceOn(Date date) {
  repository.bind();
  return usecase.fetchEventExistenceOn(date);
}

/// {@macro fetchEventExistenceOn}
Future<void> fetchEventExistenceOn(Date date) {
  return compute(__fetchEventExistenceOn, date);
}
// </fetchEventExistenceOn>
