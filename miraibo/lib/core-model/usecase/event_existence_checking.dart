import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/shared/enumeration.dart';
import 'package:miraibo/core-model/service/event_existence_checking_service.dart'
    as model;
import 'package:miraibo/core-model/value/date.dart' as model;

/// {@template fetchEventExistenceOn}
/// returns the existence of the event on the date
/// see `docs/architecture/3.2.2.7. EventExistence` for details
/// {@endtemplate}
Future<EventExistence> fetchEventExistenceOn(Date date) async {
  return await model.EventExistenceCheckingService.get(
      model.Date(date.year, date.month, date.day));
}
