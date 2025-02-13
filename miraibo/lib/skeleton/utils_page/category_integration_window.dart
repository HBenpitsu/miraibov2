import 'dart:async';

import 'package:miraibo/dto/general.dart';

// <interface>

/// CategoryIntegrationWindow opens when the user wants to integrate a category with another category.
/// When opening the window, the user should specify the category to be replaced.
/// The specified category is stored in [replaceeId].
/// Users can select a category to replace the specified category from the options.
/// And then, users dispatch the integration process by tapping the integrate button.

abstract interface class CategoryIntegrationWindow {
  // <states>
  int get replaceeId;
  // </states>

  // <presenters>
  /// In integration window, all categories (except replacee) are shown as replacer options.
  Future<List<Category>> getOptions();
  // </presenters>

  // <controllers>
  /// integrates a category whose category is [replacerId] with the category of [replaceeId].
  Future<void> integrateCategory(int replacerId);
  // </controllers>
}
// </interface>

// <mock>
typedef MockCategoryMap = Map<int, String>;

class MockCategoryIntegrationWindow implements CategoryIntegrationWindow {
  @override
  final int replaceeId;
  final Sink<MockCategoryMap> _categoryStream;
  final MockCategoryMap _categories;
  const MockCategoryIntegrationWindow(
      this.replaceeId, this._categoryStream, this._categories);

  @override
  Future<List<Category>> getOptions() async {
    return _categories.entries
        .where((entry) => entry.key != replaceeId)
        .map((entry) => Category(id: entry.key, name: entry.value))
        .toList();
  }

  @override
  Future<void> integrateCategory(int replacerId) async {
    _categories.remove(replaceeId);
    _categoryStream.add(_categories);
  }
}
// </mock>