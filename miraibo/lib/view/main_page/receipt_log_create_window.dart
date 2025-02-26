import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/main_page.dart' as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/view/shared/components/receipt_log_config_section_with_presets.dart';

void openReceiptLogCreateWindow(
    BuildContext context, skt.ReceiptLogCreateWindow skeleton) {
  showDialog(
    context: context,
    builder: (context) {
      return ReceiptLogCreateWindow(skeleton);
    },
  );
}

class ReceiptLogCreateWindow extends StatefulWidget {
  final skt.ReceiptLogCreateWindow skeleton;
  const ReceiptLogCreateWindow(this.skeleton, {super.key});

  @override
  State<ReceiptLogCreateWindow> createState() => _ReceiptLogCreateWindowState();
}

class _ReceiptLogCreateWindowState extends State<ReceiptLogCreateWindow> {
  dto.ReceiptLogScheme? currentScheme;

  Future<
      (
        List<dto.ReceiptLogSchemePreset>,
        List<dto.Category>,
        List<dto.Currency>,
        dto.ReceiptLogScheme
      )> data() async {
    return (
      await widget.skeleton.getPresets(),
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
      await widget.skeleton.getInitialScheme()
    );
  }

  Widget content() {
    return FutureBuilder(
        future: data(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text('Error');
          }

          final presets = snapshot.data!.$1;
          final categoryOptions = snapshot.data!.$2;
          final currencyOptions = snapshot.data!.$3;
          final initialScheme = snapshot.data!.$4;

          currentScheme ??= initialScheme;

          return SingleChildScrollView(
              child: ReceiptLogConfigSectionWithPresets(
                  presets: presets,
                  categoryOptions: categoryOptions,
                  currencyOptions: currencyOptions,
                  initial: initialScheme,
                  onChanged: (scheme) {
                    currentScheme = scheme;
                  }));
        });
  }

  Widget actionButtons() {
    return Row(
      children: [
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
            if (currentScheme == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('It is not initialized yet. Try again.'),
                ),
              );
              return;
            }

            widget.skeleton.createReceiptLog(
              categoryId: currentScheme!.category.id,
              description: currentScheme!.description,
              amount: currentScheme!.price.amount,
              currencyId: currentScheme!.price.currencyId,
              date: currentScheme!.date,
            );

            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        )),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalWindowContainer(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: [
                Text('New Log',
                    style: Theme.of(context).textTheme.displaySmall),
                const Divider(),
                Expanded(child: content()),
                actionButtons(),
              ],
            )));
  }

  @override
  void dispose() {
    super.dispose();
    widget.skeleton.dispose();
  }
}
