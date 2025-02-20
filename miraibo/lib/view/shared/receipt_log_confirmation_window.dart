import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/shared/receipt_log_confirmation_window.dart'
    as skt;
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/view/shared/components/ticket.dart';
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/view/shared/receipt_log_edit_window.dart';

void openReceiptLogConfirmationWindow(
    BuildContext context, skt.ReceiptLogConfirmationWindow skeleton) {
  showDialog(
    context: context,
    builder: (context) {
      return ReceiptLogConfirmationWindow(skeleton: skeleton);
    },
  );
}

class ReceiptLogConfirmationWindow extends StatefulWidget {
  final skt.ReceiptLogConfirmationWindow skeleton;
  const ReceiptLogConfirmationWindow({required this.skeleton, super.key});

  @override
  State<ReceiptLogConfirmationWindow> createState() =>
      _ReceiptLogConfirmationWindowState();
}

class _ReceiptLogConfirmationWindowState
    extends State<ReceiptLogConfirmationWindow> {
  Widget title() {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text('Confirm Log', style: textTheme.displaySmall),
        const Divider(),
        Text('Do you want to confirm the ticket below?',
            style: textTheme.bodyLarge)
      ],
    );
  }

  Widget content() {
    return FutureBuilder(
        future: widget.skeleton.getLogContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Ticket(data: snapshot.data!, onTap: (_) {});
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  Widget actionButtons() {
    return Row(children: [
      const Spacer(),
      Expanded(
          child: TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
      )),
      Expanded(
          child: TextButton(
        onPressed: () {
          widget.skeleton.confirmReceiptLog();
          Navigator.of(context).pop();
          openReceiptLogEditWindow(
              context, widget.skeleton.openReceiptLogEditWindow());
        },
        child: const Text('Edit'),
      )),
      Expanded(
          child: TextButton(
        onPressed: () {
          widget.skeleton.confirmReceiptLog();
          Navigator.of(context).pop();
        },
        child: const Text('Confirm'),
      )),
      const Spacer(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ModalWindowContainer(
        shrink: true,
        child: Column(children: [
          title(),
          content(),
          Padding(
              padding: const EdgeInsets.all(actionButtonPadding),
              child: actionButtons()),
        ]));
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    super.dispose();
  }
}
