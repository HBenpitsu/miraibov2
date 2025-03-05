import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dart:io';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miraibo/middleware/id_provider.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  late final int id;
  FakePathProviderPlatform() {
    TestWidgetsFlutterBinding.ensureInitialized();
    id = IdProvider().get();
  }

  String get kTemporaryPath => './build/test/$id/tmp';
  String get kApplicationSupportPath => './build/test/$id/support';
  String get kLibraryPath => './build/test/$id/library';
  String get kApplicationDocumentsPath => './build/test/$id/appDocs';
  String get kExternalStoragePath => './build/test/$id/externalStorage';
  String get kExternalCachePath => './build/test/$id/externalCache';
  String get kDownloadsPath => './build/test/$id/downloads';

  @override
  Future<String?> getTemporaryPath() async {
    return kTemporaryPath;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return kApplicationSupportPath;
  }

  @override
  Future<String?> getLibraryPath() async {
    return kLibraryPath;
  }

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return kApplicationDocumentsPath;
  }

  @override
  Future<String?> getExternalStoragePath() async {
    return kExternalStoragePath;
  }

  @override
  Future<List<String>?> getExternalCachePaths() async {
    return <String>[kExternalCachePath];
  }

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async {
    return <String>[kExternalStoragePath];
  }

  @override
  Future<String?> getDownloadsPath() async {
    return kDownloadsPath;
  }

  void tearDown() {
    final directory = Directory('./build/test/$id');
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
  }
}
