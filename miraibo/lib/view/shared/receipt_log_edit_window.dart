import 'package:flutter/material.dart';
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/skeleton/shared/receipt_log_edit_window.dart' as skt;
import 'package:miraibo/view/shared/components/ticket_scheme_config_section.dart';
import 'package:miraibo/view/shared/components/modal_window.dart';

void openReceiptLogEditWindow(
    BuildContext context, skt.ReceiptLogEditWindow skeleton) {
  showDialog(
    context: context,
    builder: (context) {
      return ReceiptLogEditWindow(skeleton: skeleton);
    },
  );
}

class ReceiptLogEditWindow extends StatefulWidget {
  final skt.ReceiptLogEditWindow skeleton;
  const ReceiptLogEditWindow({required this.skeleton, super.key});

  @override
  State<ReceiptLogEditWindow> createState() => _ReceiptLogEditWindowState();
}

class _ReceiptLogEditWindowState extends State<ReceiptLogEditWindow> {
  dto.ReceiptLogScheme? currentScheme;

  @override
  void initState() {
    super.initState();
  }

  Future<Widget> form() async {
    return ReceiptLogConfigSection(
      initial: await widget.skeleton.getOriginalReceiptLog(),
      categoryOptions: await widget.skeleton.getCategoryOptions(),
      currencyOptions: await widget.skeleton.getCurrencyOptions(),
      onChanged: (scheme) {
        currentScheme = scheme;
      },
    );
  }

  void cancel() {
    Navigator.of(context).pop();
  }

  void save() {
    if (currentScheme == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save. Try again.'),
        ),
      );
      return;
    }
    widget.skeleton.updateReceiptLog(
        categoryId: currentScheme!.category.id,
        description: currentScheme!.description,
        amount: currentScheme!.price.amount,
        currencyId: currentScheme!.price.currencyId,
        date: currentScheme!.date);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWindowContainer(
        child: Column(
      children: [
        Expanded(
            child: FutureBuilder(
          future: form(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            }
            return const CircularProgressIndicator();
          },
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            TextButton(
              onPressed: cancel,
              child: const Text('Cancel'),
            ),
            const Spacer(),
            TextButton(
              onPressed: save,
              child: const Text('Save'),
            ),
            const Spacer(),
          ],
        ),
      ],
    ));
  }

  @override
  void dispose() {
    super.dispose();
    widget.skeleton.dispose();
  }
}
