import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_edit_window.dart';

// <interface>
/// The window shows the receipt log and the buttons to confirm/edit the receipt log.
abstract interface class ReceiptLogConfirmationWindow {
  // <states>
  /// the id of the receipt log to be confirmed.
  /// this is not changed during the lifecycle of the window.
  int get targetReceiptLogId;
  // </states>

  // <presenters>
  /// get the content of the receipt log.
  /// The content should be shown in the window.
  Future<ReceiptLogTicket> getLogContent();
  // </presenters>

  // <naviagtors>
  /// when user selects to edit the receipt log, the receipt log edit window opens
  /// shortly after this window is closed.
  ReceiptLogEditWindow openReceiptLogEditWindow();
  // </navigators>

  // <controllers>
  /// Mark the receipt log as confirmed. Only if the user cancels the confirmation, it is not confirmed.
  /// regardless user confirms or edits the receipt log, the receipt log is marked as confirmed.
  Future<void> confirmReceiptLog();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
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
    for (final ticket in tickets) {
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
      final ticket = tickets.removeAt(0);
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

  @override
  void dispose() {}
}
// </mock>