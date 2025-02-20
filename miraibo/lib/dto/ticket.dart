import 'package:miraibo/dto/general.dart';
import 'package:miraibo/dto/schedule.dart';
import 'package:miraibo/dto/enumration.dart';

// Note that these data classes are used to transfer data to 'show' ticket.
// That means these data classes are not used to transfer data to 'create', 'edit', 'delete' ticket.

// Only the id field is used to identify the entity (not to show the ticket).

sealed class Ticket {
  const Ticket();
}

class ReceiptLogTicket extends Ticket {
  final int id; // only id is the clue to identify the entity
  final Date date;
  final Price price;
  final String description;
  final String categoryName;
  final bool confirmed;

  const ReceiptLogTicket(
      {required this.id,
      required this.date,
      required this.price,
      required this.description,
      required this.categoryName,
      required this.confirmed});
}

class PlanTicket extends Ticket {
  final int id; // only id is the clue to identify the entity
  final Schedule schedule;
  final Price price;
  final String description;
  final String categoryName;

  const PlanTicket(
      {required this.id,
      required this.schedule,
      required this.price,
      required this.description,
      required this.categoryName});
}

class EstimationTicket extends Ticket {
  final int id; // only id is the clue to identify the entity
  final OpenPeriod period;
  final Price price;
  final EstimationDisplayOption displayOption;
  final List<String> categoryNames;

  const EstimationTicket(
      {required this.id,
      required this.period,
      required this.price,
      required this.displayOption,
      required this.categoryNames});
}

class MonitorTicket extends Ticket {
  final int id; // only id is the clue to identify the entity
  final OpenPeriod period;
  final Price price;
  final MonitorDisplayOption displayOption;
  final List<String> categoryNames;

  const MonitorTicket(
      {required this.id,
      required this.period,
      required this.price,
      required this.displayOption,
      required this.categoryNames});
}
