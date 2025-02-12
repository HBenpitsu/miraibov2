// following skeleton classes are so small, so they are merged into this single file.

// <interface>
abstract interface class ExportationWindow {
  /// exportation window takes a path and there are two buttons to cancel and to proceed.
  /// This window is used when user wants to export receipt log data to external environment.
  // <controllers>
  Future<void> exportDataTo(String path);
  // </controllers>
}

abstract interface class OverwriteWindow {
  /// overwrite window takes a path and there are two buttons to cancel and to proceed.
  /// This window is used when user wants to overwrite receipt logs with external data.
  /// That means that all of the current receipt logs in app will be deleted and replaced with the external data.
  // <controllers>
  Future<void> overwriteDataWith(String path);
  // </controllers>
}

abstract interface class ImportationWindow {
  /// import window takes a path and there are two buttons to cancel and to proceed.
  /// This window is used when user wants to import receipt log data from external environment.
  // <controllers>
  Future<void> importDataFrom(String path);
  // </controllers>
}

abstract interface class BackupWindow {
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
  // <controllers>
  Future<void> backupDataTo(String path);
  // </controllers>
}

abstract interface class RestoreWindow {
  /// restore window takes a path and there are two buttons to cancel and to proceed.
  /// This window is used when user wants to restore app data from external environment.
  /// Restoration resets all of current database and replaces with the external data.
  // <controllers>
  Future<void> restoreDataFrom(String path);
  // </controllers>
}
// </interface>
