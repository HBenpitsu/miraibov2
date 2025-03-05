import 'package:miraibo/middleware/id_provider.dart';
import 'package:miraibo/model/entity/category.dart';
import 'package:miraibo/model/repository/primitive.dart';

class CategoryCollection {
  static final CategoryRepository _repository = CategoryRepository.instance;
  final List<Category> _categories;
  final bool fixed;
  List<Category> get list =>
      fixed ? List.unmodifiable(_categories) : _categories;
  final bool containsAll;

  CategoryCollection._({
    required List<Category> categories,
    required this.containsAll,
    required this.fixed,
  }) : _categories = categories;

  CategoryCollection({
    required List<Category> categories,
    this.containsAll = false,
  })  : _categories = categories,
        fixed = false;

  static CategoryCollection phantomAll =
      CategoryCollection._(categories: [], containsAll: true, fixed: true);

  CategoryCollection.empty() : this(categories: []);

  CategoryCollection.single(Category category) : this(categories: [category]);

  static Stream<List<Category>> watchAll() {
    return _repository.allCategories().map((categories) {
      return List.unmodifiable(categories);
    });
  }

  static Future<List<Category>> getAll() async {
    return List.unmodifiable(await _repository.allCategories().first);
  }

  /// returns true if default categories are inserted
  static Future<bool> prepareDefaultCategories() async {
    final allCategoriesAtNow = await _repository.allCategories().first;
    if (allCategoriesAtNow.isNotEmpty) return false;

    final IdProvider idProvider = IdProvider();
    final defaultCategories = [
      for (final name in [
        'Food',
        'Gas',
        'Water',
        'Electricity',
        'Transportation',
        'Education Fee',
        'Education Materials',
        'Medication',
        'Amusement',
        'Furniture',
        'Necessities',
        'Other Expense',
        'Scholarship',
        'Payment',
        'Other Income',
        'Adjustment',
      ])
        Category(id: idProvider.get(), name: name)
    ];
    await _repository.insertAll(defaultCategories);
    return true;
  }

  CategoryCollection replace(Category replacee, Category replacer) {
    final categories = List<Category>.from(_categories);
    // If there is no replacee, keep as it is
    if (!categories.contains(replacee)) return this;
    // If there is replacer already, just remove replacee
    if (categories.contains(replacer)) {
      categories.remove(replacee);
      return CategoryCollection(categories: categories);
    }
    categories.remove(replacee);
    categories.add(replacer);
    return CategoryCollection(categories: categories);
  }

  /// only available when containsAll is false
  List<int> ids() {
    if (containsAll) {
      throw Exception(
          'Thus containsAll-flag is true. This object does not have ids.');
    }
    return _categories.map((category) => category.id).toList();
  }
}
