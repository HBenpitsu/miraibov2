import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/core-model/entity/category.dart' as model;
import 'package:miraibo/core-model/value/collection/category_collection.dart'
    as model;

/// {@template createCategory}
/// returns the id of the created category
/// {@endtemplate}
Future<int> createCategory(String name) async {
  final result = await model.Category.create(name);
  return result.id;
}

Future<void> editCategory(int id, String name) async {
  final category = await model.Category.get(id);
  if (category == null) {
    throw ArgumentError('Category with id $id does not exist');
  }
  await category.update(name);
}

Future<void> integrateCategory(int replaceeId, int replacerId) async {
  final replacee = await model.Category.get(replaceeId);
  if (replacee == null) {
    throw ArgumentError('Category with id $replaceeId does not exist');
  }
  final replacer = await model.Category.get(replacerId);
  if (replacer == null) {
    throw ArgumentError('Category with id $replacerId does not exist');
  }
  await replacee.integrateWith(replacer);
}

/// {@template fetchAllCategories}
/// returns the list of all categories (list of pairs of name and id of category)
/// {@endtemplate}
Future<List<Category>> fetchAllCategories() async {
  final categories = await model.CategoryCollection.getAll();
  return categories
      .map((category) => Category(id: category.id, name: category.name))
      .toList();
}
