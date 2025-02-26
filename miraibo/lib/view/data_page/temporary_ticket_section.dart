import 'dart:async';
import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/data_page.dart' as skt;
import 'package:miraibo/view/shared/components/ticket.dart';
import 'package:miraibo/view/data_page/temporary_ticket_config_window.dart';

class TemporaryTicketSection extends StatefulWidget {
  final skt.DataPage skeleton;
  const TemporaryTicketSection(this.skeleton, {super.key});

  @override
  State<TemporaryTicketSection> createState() => _TemporaryTicketSectionState();
}

class _TemporaryTicketSectionState extends State<TemporaryTicketSection> {
  late final StreamSubscription<skt.TemporaryTicket> ticketSubscription;
  late skt.TemporaryTicket ticket;

  @override
  void initState() {
    super.initState();
    ticket = skt.TemporaryTicketUnspecified();
    ticketSubscription = widget.skeleton.getTemporaryTicket().listen((ticket) {
      setState(() {
        this.ticket = ticket;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          openTemporaryTicketConfigWindow(
              context, widget.skeleton.openTemporaryTicketConfigWindow());
        },
        child: Center(
          child: switch (ticket) {
            skt.TemporaryTicketUnspecified _ => TicketAppearanceTemplate(
                priceBackgroundColor:
                    Theme.of(context).colorScheme.surfaceContainer,
                priceColor: Theme.of(context).colorScheme.surfaceContainer,
                ticketType: 'unconfigured',
                categories: [''],
                amount: 0,
                currencySymbol: '',
                description: 'Tap to configure',
                timeInfo: ''),
            skt.TemporaryMonitorTicket ticket => MonitorTicket(
                categories: ticket.categoryNames,
                amount: ticket.price.amount,
                currencySymbol: ticket.price.symbol,
                displayOption: ticket.displayOption,
                period: ticket.period),
            skt.TemporaryEstimationTicket ticket => EstimateTicket(
                categories: ticket.categoryNames,
                amount: ticket.price.amount,
                currencySymbol: ticket.price.symbol,
                displayOption: ticket.displayOption,
                period: ticket.period),
          },
        ));
  }

  @override
  void dispose() {
    ticketSubscription.cancel();
    super.dispose();
  }
}
