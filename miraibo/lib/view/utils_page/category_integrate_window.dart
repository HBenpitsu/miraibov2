import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/utils_page/category_integration_window.dart'
    as skt;
import 'package:miraibo/view/shared/components/form_components/form_components.dart';
import 'package:miraibo/view/utils_page/integrate_window_pre_state.dart';

void openCategoryIntegrateWindow(
    BuildContext context, skt.CategoryIntegrationWindow skeleton) {
  showDialog(
    context: context,
    builder: (context) {
      return CategoryIntegrationWindow(skeleton);
    },
  );
}

class CategoryIntegrationWindow extends StatefulWidget {
  final skt.CategoryIntegrationWindow skeleton;
  static const windowPadding =
      EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 0);
  static const double integrateSectionHeight = 200;
  const CategoryIntegrationWindow(this.skeleton, {super.key});
  @override
  State<CategoryIntegrationWindow> createState() =>
      _CategoryIntegrationWindowState();
}

class _CategoryIntegrationWindowState
    extends IntegrateWindowPreState<CategoryIntegrationWindow> {
  @override
  String get windowTitle => 'Integrate Category';

  @override
  Widget replacerSelector() {
    return FutureBuilder(
        future: widget.skeleton.getOptions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text('There is no option'));
            }
            // initialize replacerId
            replacerId ??= snapshot.data!.first.id;

            // create SingleSelector
            final options = snapshot.data!;
            return SingleSelector<int>.fromTuple(
                initialIndex: 0,
                items: options.map((e) => (e.name, e.id)),
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
    return (await widget.skeleton.getReplacee()).name;
  }

  @override
  void integrateWith(int replacerId) {
    widget.skeleton.integrateCategory(replacerId);
  }
}
