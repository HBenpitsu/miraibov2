import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';

// <createCategory>
/// {@macro createCategory}
Future<int> createCategory(String name) {
  return compute(usecase.createCategory, name);
}
// </createCategory>

// <editCategory>
Future<void> __editCategory((int, String) param) {
  return usecase.editCategory(param.$1, param.$2);
}

Future<void> editCategory(int id, String name) {
  return compute(__editCategory, (id, name));
}
// </editCategory>

// <integrateCategory>
Future<void> __integrateCategory((int, int) param) {
  return usecase.integrateCategory(param.$1, param.$2);
}

Future<void> integrateCategory(int replaceeId, int replacerId) {
  return compute(__integrateCategory, (replaceeId, replacerId));
}
// </integrateCategory>

// <fetchAllCategories>
Future<List<Category>> __fetchAllCategories(() param) {
  return usecase.fetchAllCategories();
}

/// {@macro fetchAllCategories}
Future<List<Category>> fetchAllCategories() async {
  return compute(__fetchAllCategories, ());
}
// </fetchAllCategories>
