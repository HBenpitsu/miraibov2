import 'package:miraibo/skeleton/data_page/chart.dart';
import 'package:miraibo/skeleton/data_page/temporary_ticket.dart';

class InfoSectionPresenter {
  final ChartPresenter chartPresenter = ChartPresenter();
  final TemporaryTicketPresenter temporaryTicketPresenter =
      TemporaryTicketPresenter();
}

class InfoSectionController {
  final ChartController chartController = ChartController();
  final TemporaryTicketController temporaryTicketController =
      TemporaryTicketController();
}
