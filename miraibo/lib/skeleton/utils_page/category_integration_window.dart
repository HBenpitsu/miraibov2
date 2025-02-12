import 'package:miraibo/dto/general.dart';

// <interface>

abstract interface class CategoryIntegrationWindow {
  // <states>
  int get replaceeId;
  set replaceeId(int value);
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
