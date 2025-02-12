import 'package:miraibo/dto/general.dart';
import 'package:miraibo/dto/schedule.dart';
import 'package:miraibo/dto/enumration.dart';

// Note that these data classes are used to transfer data to 'show' ticket.
// That means these data classes are not used to transfer data to 'create', 'edit', 'delete' ticket.

// Only the id field is used to identify the entity (not to show the ticket).

sealed class Ticket {
  const Ticket();
}

mixin ReceiptLogAndMonitorTicket on Ticket {}

mixin MonitorAndEstimationTicket on Ticket {}

class ReceiptLogTicket extends Ticket with ReceiptLogAndMonitorTicket {
  final int id; // only id is the clue to identify the entity
  final Date date;
  final Price price;
  final String description;
  final String categoryName;
  final bool confirmed;

  const ReceiptLogTicket(this.id, this.date, this.price, this.description,
      this.categoryName, this.confirmed);
}

class PlanTicket extends Ticket {
  final int id; // only id is the clue to identify the entity
  final Schedule schedule;
  final Price price;
  final String description;
  final String categoryName;

  const PlanTicket(
      this.id, this.schedule, this.price, this.description, this.categoryName);
}

class EstimationTicket extends Ticket with MonitorAndEstimationTicket {
  final int id; // only id is the clue to identify the entity
  final OpenPeriod period;
  final Price price;
  final EstimationDisplayConfig displayConfig;
  final List<String> categoryNames;

  const EstimationTicket(
      this.id, this.period, this.price, this.displayConfig, this.categoryNames);
}

class MonitorTicket extends Ticket
    with MonitorAndEstimationTicket, ReceiptLogAndMonitorTicket {
  final int id; // only id is the clue to identify the entity
  final OpenPeriod period;
  final Price price;
  final MonitorDisplayConfig displayConfig;
  final List<String> categoryNames;

  const MonitorTicket(
      this.id, this.period, this.price, this.displayConfig, this.categoryNames);
}
