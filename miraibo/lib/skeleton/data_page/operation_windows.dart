// following skeleton classes are so small, so they are merged into this single file.

// <interface>
/// exportation window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to export receipt log data to external environment.
abstract interface class ExportationWindow {
  // <controllers>
  Future<void> exportDataTo(String path);
  // </controllers>
}

/// overwrite window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to overwrite receipt logs with external data.
/// That means that all of the current receipt logs in app will be deleted and replaced with the external data.
abstract interface class OverwriteWindow {
  // <controllers>
  Future<void> overwriteDataWith(String path);
  // </controllers>
}

/// import window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to import receipt log data from external environment.
abstract interface class ImportationWindow {
  // <controllers>
  Future<void> importDataFrom(String path);
  // </controllers>
}

/// backup window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to backup receipt log data to external environment.
/// The backup data contains all of app data. That means that the backup-file contains:
///
/// - all of the receipt logs
/// - all of the plans
/// - all of the estimation schemes
/// - all of the monitor schemes
/// - all of the categories
/// - all of the currencies
///
/// and so on.
/// The backup-file can be used to restore the app data later.
abstract interface class BackupWindow {
  // <controllers>
  Future<void> backupDataTo(String path);
  // </controllers>
}

/// restore window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to restore app data from external environment.
/// Restoration resets all of current database and replaces with the external data.
abstract interface class RestoreWindow {
  // <controllers>
  Future<void> restoreDataFrom(String path);
  // </controllers>
}
// </interface>

// <mock>
class MockExportationWindow implements ExportationWindow {
  @override
  Future<void> exportDataTo(String path) async {
    return;
  }
}

class MockOverwriteWindow implements OverwriteWindow {
  @override
  Future<void> overwriteDataWith(String path) async {
    return;
  }
}

class MockImportationWindow implements ImportationWindow {
  @override
  Future<void> importDataFrom(String path) async {
    return;
  }
}

class MockBackupWindow implements BackupWindow {
  @override
  Future<void> backupDataTo(String path) async {
    return;
  }
}

class MockRestoreWindow implements RestoreWindow {
  @override
  Future<void> restoreDataFrom(String path) async {
    return;
  }
}
// </mock>