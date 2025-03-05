import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart' show NativeDatabase;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:miraibo/middleware/relational/dao.dart';
import 'package:miraibo/shared/enumeration.dart';

part 'database.g.dart';

@DriftDatabase(include: {'primary_tables.drift'}, daos: [Plans])
class AppDatabase extends _$AppDatabase {
  static AppDatabase? _instance;
  AppDatabase._() : super(_openConnection());
  factory AppDatabase() {
    return _instance ??= AppDatabase._();
  }

  @override
  int get schemaVersion => 1;
  // HISTORY:
  // 1: Initial version (2025/3/3)

  static QueryExecutor _openConnection() {
    WidgetsFlutterBinding.ensureInitialized();
    return LazyDatabase(() async {
      final String directory;
      if (kIsWeb) {
        throw UnimplementedError('Database for Web is not supported');
      } else {
        directory = (await getApplicationDocumentsDirectory()).path;
      }
      final file = File(join(directory, 'db.sqlite'));
      return NativeDatabase(file);
    });
  }
}
