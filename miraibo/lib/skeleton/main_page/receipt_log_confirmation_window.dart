import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_edit_window.dart';

// <interface>
/// receipt log confirmation window is shown when a unconfirmed receipt log is tapped.
/// The window shows the receipt log and the buttons to confirm/edit the receipt log.
abstract interface class ReceiptLogConfirmationWindow {
  // <states>
  int get targetReceiptLogId;
  // </states>

  // <presenters>
  Future<ReceiptLogTicket> getLogContent();
  // </presenters>

  // <naviagtors>
  /// when user selects to edit the receipt log, the receipt log edit window opens.
  ReceiptLogEditWindow openReceiptLogEditWindow();
  // </navigators>

  // <controllers>
  /// regardless user confirms or edits the receipt log, the receipt log is marked as confirmed.
  Future<void> confirmReceiptLog();
  // </controllers>
}
// </interface>

// <mock>
class MockReceiptLogConfirmationWindow implements ReceiptLogConfirmationWindow {
  @override
  final int targetReceiptLogId;
  final List<Ticket> tickets;
  final Sink<List<Ticket>> ticketsStream;
  MockReceiptLogConfirmationWindow(
      this.targetReceiptLogId, this.tickets, this.ticketsStream);

  @override
  Future<ReceiptLogTicket> getLogContent() async {
    for (var ticket in tickets) {
      if (ticket is! ReceiptLogTicket) continue;
      if (ticket.id == targetReceiptLogId) return ticket;
    }
    throw Exception('ticket not found');
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow() {
    return MockReceiptLogEditWindow(targetReceiptLogId, ticketsStream, tickets);
  }

  @override
  Future<void> confirmReceiptLog() async {
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      var ticket = tickets.removeAt(0);
      if (ticket is! ReceiptLogTicket) {
        newTickets.add(ticket);
        continue;
      }
      if (ticket.id != targetReceiptLogId) {
        newTickets.add(ticket);
        continue;
      }
      newTickets.add(ReceiptLogTicket(
          id: ticket.id,
          price: ticket.price,
          date: ticket.date,
          description: ticket.description,
          categoryName: ticket.categoryName,
          confirmed: true));
    }
    tickets.addAll(newTickets);
    ticketsStream.add(tickets);
  }
}
// </mock>