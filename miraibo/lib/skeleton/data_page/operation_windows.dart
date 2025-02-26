// following skeleton classes are so small, so they are merged into this single file.

// <interface>
/// exportation window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to export receipt log data to external environment.
abstract interface class ExportationWindow {
  // <controllers>
  Future<bool> exportDataTo(String path);
  // </controllers>
  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

/// overwrite window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to overwrite receipt logs with external data.
/// That means that all of the current receipt logs in app will be deleted and replaced with the external data.
abstract interface class OverwriteWindow {
  // <controllers>
  Future<bool> overwriteDataWith(String path);
  // </controllers>
  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

/// import window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to import receipt log data from external environment.
abstract interface class ImportationWindow {
  // <controllers>
  Future<bool> importDataFrom(String path);
  // </controllers>
  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
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
  Future<bool> backupDataTo(String path);
  // </controllers>
  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

/// restore window takes a path and there are two buttons to cancel and to proceed.
/// This window is used when user wants to restore app data from external environment.
/// Restoration resets all of current database and replaces with the external data.
abstract interface class RestoreWindow {
  // <controllers>
  Future<bool> restoreDataFrom(String path);
  // </controllers>
  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
