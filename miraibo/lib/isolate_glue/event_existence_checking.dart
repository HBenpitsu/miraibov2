import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';

// <fetchEventExistenceOn>
/// {@macro fetchEventExistenceOn}
Future<void> fetchEventExistenceOn(Date date) {
  return compute(usecase.fetchEventExistenceOn, date);
}
// </fetchEventExistenceOn>
