import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/utils_page/currency_integration_window.dart'
    as skt;
import 'package:miraibo/view/shared/components/form_components/form_components.dart';
import 'package:miraibo/view/utils_page/integrate_window_pre_state.dart';

void openCurrencyIntegrateWindow(
    BuildContext context, skt.CurrencyIntegrationWindow skeleton) {
  showDialog(
    context: context,
    builder: (context) {
      return CurrencyIntegrateWindow(skeleton);
    },
  );
}

class CurrencyIntegrateWindow extends StatefulWidget {
  final skt.CurrencyIntegrationWindow skeleton;
  const CurrencyIntegrateWindow(this.skeleton, {super.key});
  @override
  State<CurrencyIntegrateWindow> createState() =>
      _CurrencyIntegrateWindowState();
}

class _CurrencyIntegrateWindowState
    extends IntegrateWindowPreState<CurrencyIntegrateWindow> {
  @override
  String get windowTitle => 'Integrate Currency';

  @override
  Widget replacerSelector() {
    return FutureBuilder(
        future: widget.skeleton.getOptions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // initialize replacerId
            replacerId ??= snapshot.data?.first.id;

            // create SingleSelector
            final options = snapshot.data!;
            return SingleSelector<int>.fromTuple(
                initialIndex: 0,
                items: options.map((e) => (e.symbol, e.id)),
                onChanged: (id) {
                  replacerId = id;
                });
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  Future<String> getReplaceeName() async {
    return (await widget.skeleton.getReplacee()).symbol;
  }

  @override
  Future<void> integrateWith(int replacerId) async {
    await widget.skeleton.integrateCurrency(replacerId);
  }
}
