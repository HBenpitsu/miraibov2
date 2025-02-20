import 'package:flutter/material.dart';
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/view/shared/components/form_components/shared_constants.dart';

const windowPadding = EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 0);

abstract class IntegrateWindowPreState<T extends StatefulWidget>
    extends State<T> {
  int? replacerId;

  Widget replacee(String name) {
    final textTheme = Theme.of(context).textTheme;
    final nameContainerStyle = BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(formChipHeight / 2));
    return Wrap(children: [
      Text('Replace:', style: textTheme.headlineMedium),
      Container(
          decoration: nameContainerStyle,
          height: formChipHeight,
          child: Center(child: Text(name, style: textTheme.bodyLarge))),
    ]);
  }

  Future<String> getReplaceeName();

  Widget replacerSelector();

  Widget integrateSection() {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FutureBuilder(
            future: getReplaceeName(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return replacee(snapshot.data!);
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return Text('Replace: ---', style: textTheme.headlineMedium);
            },
          ),
          Text('With:', style: textTheme.headlineMedium),
          SizedBox(width: double.infinity, child: replacerSelector())
        ]));
  }

  void integrateWith(int replacerId);

  Widget actionButtons() {
    return Padding(
        padding: const EdgeInsets.all(actionButtonPadding),
        child: Row(children: [
          Expanded(
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'))),
          const Spacer(),
          Expanded(
              child: TextButton(
                  onPressed: () {
                    if (replacerId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('It is not initialized yet. Try again.')));
                      return;
                    }
                    integrateWith(replacerId!);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Integrate',
                      style: TextStyle(color: Colors.redAccent)))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ModalWindowContainer(
      shrink: true,
      child: Padding(
          padding: windowPadding,
          child: Column(
            children: [
              Text('Integrate Category', style: textTheme.headlineMedium),
              const Divider(),
              const Text('CAUTION: This action is irreversible.',
                  style: TextStyle(color: Colors.redAccent, fontSize: 20)),
              const SizedBox(height: 10),
              integrateSection(),
              actionButtons(),
            ],
          )),
    );
  }
}
