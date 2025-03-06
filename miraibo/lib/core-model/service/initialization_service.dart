import 'package:miraibo/core-model/value/collection/category_collection.dart';

class InitializationService {
  static Future<void> initialize() async {
    await CategoryCollection.prepareDefaultCategories();
  }
}
