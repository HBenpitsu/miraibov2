import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart' show NativeDatabase;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:logger/logger.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;
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

  static Future<void> prune() async {
    final String directory;
    if (kIsWeb) {
      throw UnimplementedError('Database for Web is not supported');
    } else {
      directory = (await getApplicationSupportDirectory()).path;
    }
    Logger().i('Using databse file at $directory');
    final file = File(join(directory, 'miraibo-db.sqlite'));
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> clear() async {
    await batch((batch) {
      for (final table in allTables) {
        batch.deleteAll(table);
      }
    });
  }

  static int chunkSize = 1024;

  Stream<String> dump() async* {
    final file = await getDatabaseFile();
    // take a snapshot
    final snapshot = await file.copy('miraibo-db.sqlite.dump');
    int cursor = 0;
    while (true) {
      final chunk = await snapshot.openRead(cursor, cursor + chunkSize).first;
      if (chunk.isEmpty) break;
      yield utf8.decode(chunk);
      cursor += chunk.length;
    }
    await snapshot.delete();
  }

  Future<void> load(Stream<String> chunks) async {
    await close();
    final file = await getDatabaseFile();
    final sink = file.openWrite();
    await for (final chunk in chunks) {
      sink.write(chunk);
    }
    await sink.flush();
    await sink.close();
  }

  static File? _databaseFile;
  static Future<File> getDatabaseFile() async {
    if (_databaseFile != null) return _databaseFile!;
    final String directory;
    if (kIsWeb) {
      throw UnimplementedError('Database for Web is not supported');
    } else {
      directory = (await getApplicationSupportDirectory()).path;
    }
    Logger().i('Using databse file at $directory');
    return File(join(directory, 'miraibo-db.sqlite'));
  }

  static QueryExecutor _openConnection() {
    WidgetsFlutterBinding.ensureInitialized();
    return LazyDatabase(() async {
      return NativeDatabase(await getDatabaseFile());
    });
  }
}
