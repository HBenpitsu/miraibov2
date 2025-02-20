import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_create_window.dart'
    as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/view/shared/components/ticket_scheme_config_section.dart';

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

  Future<(List<dto.Category>, List<dto.Currency>, dto.Currency)> data() async {
    return (
      await widget.skeleton.getCategoryOptions(),
      await widget.skeleton.getCurrencyOptions(),
      await widget.skeleton.getDefaultCurrency()
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
          final categoryOptions = snapshot.data!.$1;
          final currencyOptions = snapshot.data!.$2;
          final defaultCurrency = snapshot.data!.$3;

          final initialScheme = dto.ReceiptLogScheme(
              category: categoryOptions.first,
              description: '',
              price: dto.ConfigureblePrice(
                  amount: 0,
                  currencyId: defaultCurrency.id,
                  currencySymbol: defaultCurrency.symbol),
              date: DateTime.now().cutOffTime(),
              confirmed: true);

          currentScheme ??= initialScheme;

          return SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Log', style: Theme.of(context).textTheme.displaySmall),
              ReceiptLogConfigSection(
                  categoryOptions: categoryOptions,
                  currencyOptions: currencyOptions,
                  initial: initialScheme,
                  onChanged: (scheme) {
                    currentScheme = scheme;
                  })
            ],
          ));
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
