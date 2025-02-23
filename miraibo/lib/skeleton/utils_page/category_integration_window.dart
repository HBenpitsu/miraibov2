import 'dart:async';
import 'dart:developer' show log;

import 'package:miraibo/dto/dto.dart';

// <interface>

/// CategoryIntegrationWindow opens when the user wants to integrate a category with another category.
/// When opening the window, the user should specify the category to be replaced.
/// The specified category is stored in [replaceeId].
/// Users can select a category to replace the specified category from the options.
/// And then, users dispatch the integration process by tapping the integrate button.

abstract interface class CategoryIntegrationWindow {
  // <states>
  /// The ID of the currency to be replaced.
  /// This is not changed during the lifecycle of the window.
  int get replaceeId;
  // </states>

  // <presenters>
  /// In integration window, all categories (except replacee) are shown as replacer options.
  Future<Category> getReplacee();
  Future<List<Category>> getOptions();
  // </presenters>

  // <controllers>
  /// integrates a category whose category is [replacerId] with the category of [replaceeId].
  Future<void> integrateCategory(int replacerId);
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
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
  Future<Category> getReplacee() async {
    log('getReplacee is called with replaceeId: $replaceeId');
    return Category(name: _categories[replaceeId] ?? '', id: replaceeId);
  }

  @override
  Future<List<Category>> getOptions() async {
    log('getOptions is called');
    return _categories.entries
        .where((entry) => entry.key != replaceeId)
        .map((entry) => Category(id: entry.key, name: entry.value))
        .toList(growable: false);
  }

  @override
  Future<void> integrateCategory(int replacerId) async {
    log('integrateCategory is called with replacerId: $replacerId');
    _categories.remove(replaceeId);
    _categoryStream.add(_categories);
  }

  @override
  void dispose() {
    log('CategoryIntegrationWindow is disposed');
  }
}
// </mock>
