import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/repository/impl.dart' as repository;

// <createCategory>
Future<int> __createCategory(String name) {
  repository.bind();
  return usecase.createCategory(name);
}

/// {@macro createCategory}
Future<int> createCategory(String name) {
  return usecase.createCategory(name);
  // return compute(__createCategory, name);
}
// </createCategory>

// <editCategory>
Future<void> __editCategory((int, String) param) {
  repository.bind();
  return usecase.editCategory(param.$1, param.$2);
}

Future<void> editCategory(int id, String name) {
  return usecase.editCategory(id, name);
  // return compute(__editCategory, (id, name));
}
// </editCategory>

// <integrateCategory>
Future<void> __integrateCategory((int, int) param) {
  repository.bind();
  return usecase.integrateCategory(param.$1, param.$2);
}

Future<void> integrateCategory(int replaceeId, int replacerId) {
  return usecase.integrateCategory(replaceeId, replacerId);
  // return compute(__integrateCategory, (replaceeId, replacerId));
}
// </integrateCategory>

// <fetchAllCategories>
Future<List<Category>> __fetchAllCategories(() param) {
  repository.bind();
  return usecase.fetchAllCategories();
}

/// {@macro fetchAllCategories}
Future<List<Category>> fetchAllCategories() async {
  return usecase.fetchAllCategories();
  // return compute(__fetchAllCategories, ());
}
// </fetchAllCategories>
