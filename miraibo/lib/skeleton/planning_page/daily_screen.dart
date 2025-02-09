import 'package:miraibo/skeleton/planning_page/modal_window/ticket_create_window.dart';
import 'package:miraibo/skeleton/planning_page/modal_window/ticket_edit_window.dart';

class DailyScreenPresenter {
  final TicketCreateWindowPresenter ticketCreateWindowPresenter =
      TicketCreateWindowPresenter();
  final TicketEditWindowPresenter ticketEditWindowPresenter =
      TicketEditWindowPresenter();
}

class DailyScreenController {
  final TicketCreateWindowController ticketCreateWindowController =
      TicketCreateWindowController();
  final TicketEditWindowController ticketEditWindowController =
      TicketEditWindowController();
}
