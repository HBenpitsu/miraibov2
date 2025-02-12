// following skeleton classes are so small, so they are merged into this single file.

// <interface>
abstract interface class ExportationWindow {
  /// exportation window takes a path and there are two buttons to cancel and to proceed.
  // <controllers>
  Future<void> exportDataTo(String path);
  // </controllers>
}

abstract interface class OverwriteWindow {
  /// overwrite window takes a path and there are two buttons to cancel and to proceed.
  // <controllers>
  Future<void> overwriteDataWith(String path);
  // </controllers>
}

abstract interface class ImportationWindow {
  /// import window takes a path and there are two buttons to cancel and to proceed.
  // <controllers>
  Future<void> importDataFrom(String path);
  // </controllers>
}

abstract interface class BackupWindow {
  /// backup window takes a path and there are two buttons to cancel and to proceed.
  // <controllers>
  Future<void> backupDataTo(String path);
  // </controllers>
}

abstract interface class RestoreWindow {
  /// restore window takes a path and there are two buttons to cancel and to proceed.
  // <controllers>
  Future<void> restoreDataFrom(String path);
  // </controllers>
}
// </interface>