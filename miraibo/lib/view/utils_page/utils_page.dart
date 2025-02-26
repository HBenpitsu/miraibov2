import 'package:flutter/material.dart';
import 'package:miraibo/view/shared/components/foldable_section.dart';
import 'package:miraibo/view/shared/components/form_components/custom_text_field.dart';
import 'package:miraibo/view/shared/components/valed_container.dart';
import 'package:miraibo/view/shared/constants.dart';
import 'package:miraibo/skeleton/utils_page/utils_page.dart' as skt;
import 'package:miraibo/dto/dto.dart' as dto;
import 'package:miraibo/view/utils_page/category_integrate_window.dart';
import 'package:miraibo/view/utils_page/currency_integrate_window.dart';

const sectionMargin = SizedBox(height: 10);
const lineMargin = SizedBox(height: 5);

class _Tile extends StatelessWidget {
  final List<Widget> children;
  const _Tile(this.children, {super.key});

  static const tileMargin = EdgeInsets.symmetric(horizontal: 20, vertical: 5);
  static const tilePadding =
      EdgeInsets.only(top: 8, right: 9, bottom: 8, left: 18);
  static const double tileRadius = 30;
  static const double tileHeight = 60;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: tileMargin,
        child: Container(
            height: tileHeight,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(tileRadius)),
            child: Padding(
              padding: tilePadding,
              child: Row(children: children),
            )));
  }
}

class UtilsPage extends StatefulWidget {
  final skt.UtilsPage skeleton;
  const UtilsPage(this.skeleton, {super.key});

  static const double heightOfCagegorySection = 460;
  static const double heightOfCurrencySection = 460;
  static const double sectionValeSize = 30;
  static const double horizontalPadding = 30;

  @override
  State<UtilsPage> createState() => _UtilsPageState();
}

class _UtilsPageState extends State<UtilsPage> {
  late final ScrollController scrollCtl;

  @override
  void initState() {
    super.initState();
    scrollCtl = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final mainContent = Column(
      children: [
        _CategorySection(widget.skeleton),
        sectionMargin,
        _CurrencySection(widget.skeleton),
      ],
    );
    final bottomBar = SizedBox(
        height: bottomNavigationBarHeight,
        child: Row(
          children: [
            Expanded(
                child: IconButton(
                    onPressed: () {
                      scrollCtl.animateTo(0,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut);
                    },
                    icon: const Icon(Icons.arrow_upward))),
            Expanded(
                child: IconButton(
                    onPressed: () {
                      scrollCtl.animateTo(scrollCtl.position.maxScrollExtent,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut);
                    },
                    icon: const Icon(Icons.arrow_downward))),
          ],
        ));
    return Scaffold(
      body: SingleChildScrollView(
          controller: scrollCtl,
          child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: UtilsPage.horizontalPadding),
              child: mainContent)),
      bottomNavigationBar: bottomBar,
    );
  }

  @override
  void dispose() {
    widget.skeleton.dispose();
    scrollCtl.dispose();
    super.dispose();
  }
}

class _CategorySection extends StatefulWidget {
  final skt.UtilsPage skeleton;
  const _CategorySection(this.skeleton);

  @override
  State<StatefulWidget> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<_CategorySection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  FoldingController foldCtl = FoldingController();
  TextEditingController nameCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sectionColor = Theme.of(context).colorScheme.surfaceContainer;
    final mainContent = StreamBuilder(
        stream: widget.skeleton.categorySection(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final data = snapshot.data!;
          return ValedList(
              upperValeHeight: UtilsPage.sectionValeSize,
              lowerValeHeight: UtilsPage.sectionValeSize,
              valeColor: sectionColor,
              itemCount: data.length,
              builder: (context, index) {
                return categoryItem(context, data[index]);
              });
        });
    final container = FoldableSection(
        color: sectionColor,
        header: categoryAddTile(context),
        body: mainContent,
        bodyHeight: UtilsPage.heightOfCagegorySection,
        controller: foldCtl);
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              foldCtl.toggle();
            },
            child: Text('Category',
                style: Theme.of(context).textTheme.headlineLarge)),
        lineMargin,
        container
      ],
    );
  }

  Widget categoryAddTile(BuildContext context) {
    final categoryCreateButton = TextButton(
      onPressed: () {
        if (nameCtl.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Category name cannot be empty')));
          return;
        }
        widget.skeleton.newCategory(nameCtl.text);
        nameCtl.clear();
      },
      style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primary),
      child: const Icon(Icons.add),
    );
    return _Tile([
      Expanded(child: CustomTextField(controller: nameCtl)),
      categoryCreateButton
    ]);
  }

  Widget categoryItem(BuildContext context, dto.Category category) {
    final nameField = CustomTextField(
        initialText: category.name,
        invalidMessageBuilder: (text) {
          if (text.isEmpty) {
            return 'Category name cannot be empty';
          }
          return null;
        },
        onEditCompleted: (text) {
          widget.skeleton.editCategory(category.id, text);
        });
    final integrateButton = TextButton(
      onPressed: () {
        openCategoryIntegrateWindow(context,
            widget.skeleton.openCategoryIntegrationWindow(category.id));
      },
      style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primary),
      child: const Icon(Icons.delete),
    );
    return _Tile([Expanded(child: nameField), integrateButton],
        key: ValueKey(category.id));
  }

  @override
  void dispose() {
    foldCtl.dispose();
    nameCtl.dispose();
    super.dispose();
  }
}

class _CurrencySection extends StatefulWidget {
  final skt.UtilsPage skeleton;
  const _CurrencySection(this.skeleton);
  static const double currencyRatioFieldWidth = 60;
  static const double currencyFieldSpacing = 5;

  @override
  State<StatefulWidget> createState() => _CurrencySectionState();
}

class _CurrencySectionState extends State<_CurrencySection> {
  FoldingController foldCtl = FoldingController();

  @override
  Widget build(BuildContext context) {
    final list = StreamBuilder(
        stream: widget.skeleton.currencySection(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final data = snapshot.data!;
          return ValedList(
              upperValeHeight: UtilsPage.sectionValeSize,
              lowerValeHeight: UtilsPage.sectionValeSize,
              valeColor: Theme.of(context).colorScheme.surfaceContainer,
              itemCount: data.length,
              builder: (context, index) {
                return currencyItem(context, data[index]);
              });
        });
    final container = FoldableSection(
        controller: foldCtl,
        header: currencyAddTile(context),
        body: list,
        bodyHeight: UtilsPage.heightOfCurrencySection,
        color: Theme.of(context).colorScheme.surfaceContainer);
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              foldCtl.toggle();
            },
            child: Text('Currency',
                style: Theme.of(context).textTheme.headlineLarge)),
        lineMargin,
        container
      ],
    );
  }

  TextEditingController symbolCtl = TextEditingController();
  TextEditingController numberCtl = TextEditingController();

  Widget currencyAddTile(BuildContext context) {
    final symbolField = CustomTextField(controller: symbolCtl);
    final ratioField = CustomTextField(
        keyboardType: TextInputType.number, controller: numberCtl);
    final integrateButton = TextButton(
      onPressed: () {
        if (symbolCtl.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Currency symbol cannot be empty')));
          return;
        }
        final ratio = double.tryParse(numberCtl.text);
        if (ratio == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Currency ratio must be a number')));
          return;
        }
        widget.skeleton.newCurrency(symbolCtl.text, ratio);
        symbolCtl.clear();
        numberCtl.clear();
      },
      style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primary),
      child: const Icon(Icons.add),
    );
    return _Tile([
      Expanded(child: symbolField),
      const SizedBox(
        width: _CurrencySection.currencyFieldSpacing,
      ),
      SizedBox(
          width: _CurrencySection.currencyRatioFieldWidth, child: ratioField),
      integrateButton
    ]);
  }

  Widget currencyItem(BuildContext context, dto.CurrencyInstance currency) {
    final symbolField = CustomTextField(
      initialText: currency.symbol,
      invalidMessageBuilder: (text) {
        if (text.isEmpty) {
          return 'Currency symbol cannot be empty';
        }
        return null;
      },
      onEditCompleted: (text) {
        widget.skeleton.editCurrency(currency.id, text, currency.ratio);
      },
    );
    final ratioField = CustomTextField(
      initialText: currency.ratio.toString(),
      keyboardType: TextInputType.number,
      invalidMessageBuilder: (text) {
        if (double.tryParse(text) == null) {
          return 'Currency should be a number';
        }
        return null;
      },
      onEditCompleted: (text) {
        final ratio = double.parse(text);
        widget.skeleton.editCurrency(currency.id, currency.symbol, ratio);
      },
    );
    final integrateButton = TextButton(
      onPressed: () {
        if (currency.isDefault) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Default currency cannot be deleted')));
          return;
        }
        openCurrencyIntegrateWindow(context,
            widget.skeleton.openCurrencyIntegrationWindow(currency.id));
      },
      style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primary),
      child: const Icon(Icons.delete),
    );
    final setDefaultButton = TextButton(
      onPressed: () {
        widget.skeleton.setDefaultCurrency(currency.id);
      },
      style: TextButton.styleFrom(
          backgroundColor: currency.isDefault
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainer),
      child: const SizedBox(width: 20),
    );
    return _Tile([
      setDefaultButton,
      const SizedBox(
        width: _CurrencySection.currencyFieldSpacing,
      ),
      Expanded(child: symbolField),
      const SizedBox(
        width: _CurrencySection.currencyFieldSpacing,
      ),
      SizedBox(
          width: _CurrencySection.currencyRatioFieldWidth, child: ratioField),
      integrateButton
    ], key: ValueKey(currency.id));
  }

  @override
  void dispose() {
    foldCtl.dispose();
    symbolCtl.dispose();
    numberCtl.dispose();
    super.dispose();
  }
}
