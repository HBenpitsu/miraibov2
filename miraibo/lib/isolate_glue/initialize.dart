import 'package:miraibo/core-model/service/initialization_service.dart';

Future<void> initializeApp() async {
  await InitializationService.initialize();
}
