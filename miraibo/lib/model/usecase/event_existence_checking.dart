import 'package:miraibo/model/usecase/general_primitives.dart';
export 'package:miraibo/model/usecase/general_primitives.dart';

enum EventExistence {
  none,
  trivial,
  important,
}

/// returns the existence of the event on the date
/// see `docs/architecture/3.2.2.7. EventExistence` for details
fetchEventExistenceOn(Date date) async {
  // access to iso-glue
  throw UnimplementedError();
}
