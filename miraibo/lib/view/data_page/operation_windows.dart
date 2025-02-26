import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/data_page/operation_windows.dart' as skt;
import 'package:miraibo/view/shared/components/modal_window.dart';
import 'package:miraibo/view/shared/constants.dart';
import 'package:file_picker/file_picker.dart';

abstract class _OperationWindowPreState<T extends StatefulWidget>
    extends State<T> {
  Widget get content;
  bool get danger;
  String get nameOfAction;
  String get windowTitle;

  String? invalidMessage();
  void proceed();

  Widget get actionButtons {
    return Padding(
        padding: const EdgeInsets.all(actionButtonPadding),
        child: Row(children: [
          Expanded(
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'))),
          const Spacer(),
          Expanded(
              child: TextButton(
                  onPressed: () {
                    final invalidMessage = this.invalidMessage();
                    if (invalidMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(invalidMessage)));
                      return;
                    }
                    proceed();
                    Navigator.of(context).pop();
                  },
                  child: Text(nameOfAction,
                      style:
                          danger ? TextStyle(color: Colors.redAccent) : null))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ModalWindowContainer(
      shrink: true,
      child: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 0),
          child: Column(
            children: [
              Text(windowTitle, style: textTheme.headlineMedium),
              const Divider(),
              if (danger)
                const Text('CAUTION: This action is irreversible.',
                    style: TextStyle(color: Colors.redAccent, fontSize: 20)),
              if (danger) const SizedBox(height: 10),
              content,
              actionButtons,
            ],
          )),
    );
  }
}

void openExportWindow(BuildContext context, skt.ExportationWindow skeleton) {
  showDialog(
      context: context, builder: (context) => ExportationWindow(skeleton));
}

class ExportationWindow extends StatefulWidget {
  final skt.ExportationWindow skeleton;
  const ExportationWindow(this.skeleton, {super.key});

  @override
  State<ExportationWindow> createState() => _ExportationWindowState();
}

class _ExportationWindowState
    extends _OperationWindowPreState<ExportationWindow> {
  String? path;

  @override
  String? invalidMessage() {
    if (path == null) {
      return 'Select a directory to export first.';
    }
    return null;
  }

  @override
  void proceed() {
    final messenger = ScaffoldMessenger.of(context);
    widget.skeleton.exportDataTo(path!).then((sucess) {
      messenger.showSnackBar(SnackBar(
          content:
              Text(sucess ? 'Data is exported' : 'Failed to export data')));
    });
  }

  @override
  String get windowTitle => 'Export Logs';

  @override
  String get nameOfAction => 'Export';

  @override
  bool get danger => false;

  @override
  Widget get content {
    final messenger = ScaffoldMessenger.of(context);
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              try {
                // An unimplemented error can be thrown
                final result = await FilePicker.platform.getDirectoryPath();
                if (result != null) {
                  setState(() {
                    path = result;
                  });
                }
              } on UnimplementedError catch (_) {
                messenger.showSnackBar(SnackBar(
                    content:
                        Text('This action is not supported on this platform')));
              }
            },
            child: const Text('Select a directory to export')),
        Text(path == null ? 'No directory selected' : 'Selected path: $path'),
      ],
    );
  }
}

void openImportWindow(BuildContext context, skt.ImportationWindow skeleton) {
  showDialog(
      context: context, builder: (context) => ImportationWindow(skeleton));
}

class ImportationWindow extends StatefulWidget {
  final skt.ImportationWindow skeleton;
  const ImportationWindow(this.skeleton, {super.key});

  @override
  State<ImportationWindow> createState() => _ImportationWindowState();
}

class _ImportationWindowState
    extends _OperationWindowPreState<ImportationWindow> {
  String? path;

  @override
  String? invalidMessage() {
    if (path == null) {
      return 'Select a file to import first.';
    }
    return null;
  }

  @override
  void proceed() {
    final messenger = ScaffoldMessenger.of(context);
    widget.skeleton.importDataFrom(path!).then((sucess) {
      messenger.showSnackBar(SnackBar(
          content:
              Text(sucess ? 'Data is imported' : 'Failed to import data')));
    });
  }

  @override
  String get windowTitle => 'Import Logs';

  @override
  String get nameOfAction => 'Import';

  @override
  bool get danger => false;

  @override
  Widget get content {
    final messenger = ScaffoldMessenger.of(context);
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              try {
                // An unimplemented error can be thrown
                final result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  setState(() {
                    path = result.files.single.path;
                  });
                }
              } on UnimplementedError catch (_) {
                messenger.showSnackBar(SnackBar(
                    content:
                        Text('This action is not supported on this platform')));
              }
            },
            child: const Text('Select a file to import')),
        Text(path == null ? 'No file selected' : 'Selected path: $path'),
      ],
    );
  }
}

void openOverwriteWindow(BuildContext context, skt.OverwriteWindow skeleton) {
  showDialog(context: context, builder: (context) => OverriteWindow(skeleton));
}

class OverriteWindow extends StatefulWidget {
  final skt.OverwriteWindow skeleton;
  const OverriteWindow(this.skeleton, {super.key});

  @override
  State<OverriteWindow> createState() => _OverriteWindowState();
}

class _OverriteWindowState extends _OperationWindowPreState<OverriteWindow> {
  String? path;

  @override
  String? invalidMessage() {
    if (path == null) {
      return 'Select a file to import first.';
    }
    return null;
  }

  @override
  void proceed() {
    final messenger = ScaffoldMessenger.of(context);
    widget.skeleton.overwriteDataWith(path!).then((sucess) {
      messenger.showSnackBar(SnackBar(
          content:
              Text(sucess ? 'Data is overwritten' : 'Failed to overwrite')));
    });
  }

  @override
  String get windowTitle => 'Overwrite Logs';

  @override
  String get nameOfAction => 'Overwrite';

  @override
  bool get danger => true;

  @override
  Widget get content {
    final messenger = ScaffoldMessenger.of(context);
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              try {
                // An unimplemented error can be thrown
                final result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  setState(() {
                    path = result.files.single.path;
                  });
                }
              } on UnimplementedError catch (_) {
                messenger.showSnackBar(SnackBar(
                    content:
                        Text('This action is not supported on this platform')));
              }
            },
            child: const Text('Select a file to import')),
        Text(path == null ? 'No file selected' : 'Selected path: $path'),
      ],
    );
  }
}

void openBackupWindow(BuildContext context, skt.BackupWindow skeleton) {
  showDialog(context: context, builder: (context) => BackupWindow(skeleton));
}

class BackupWindow extends StatefulWidget {
  final skt.BackupWindow skeleton;
  const BackupWindow(this.skeleton, {super.key});

  @override
  State<BackupWindow> createState() => _BackupWindowState();
}

class _BackupWindowState extends _OperationWindowPreState<BackupWindow> {
  String? path;

  @override
  String? invalidMessage() {
    if (path == null) {
      return 'Select a directory to export a backup-file first.';
    }
    return null;
  }

  @override
  void proceed() {
    final messenger = ScaffoldMessenger.of(context);
    widget.skeleton.backupDataTo(path!).then((sucess) {
      messenger.showSnackBar(SnackBar(
          content: Text(sucess ? 'Backup completed' : 'Failed to backup')));
    });
  }

  @override
  String get windowTitle => 'Backup';

  @override
  String get nameOfAction => 'Backup';

  @override
  bool get danger => false;

  @override
  Widget get content {
    final messenger = ScaffoldMessenger.of(context);
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              try {
                // An unimplemented error can be thrown
                final result = await FilePicker.platform.getDirectoryPath();
                if (result != null) {
                  setState(() {
                    path = result;
                  });
                }
              } on UnimplementedError catch (_) {
                messenger.showSnackBar(SnackBar(
                    content:
                        Text('This action is not supported on this platform')));
              }
            },
            child: const Text('Select a directory to export backup-file')),
        Text(path == null ? 'No directory selected' : 'Selected path: $path'),
      ],
    );
  }
}

void openRestoreWindow(BuildContext context, skt.RestoreWindow skeleton) {
  showDialog(context: context, builder: (context) => RestoreWindow(skeleton));
}

class RestoreWindow extends StatefulWidget {
  final skt.RestoreWindow skeleton;
  const RestoreWindow(this.skeleton, {super.key});

  @override
  State<RestoreWindow> createState() => _RestoreWindowState();
}

class _RestoreWindowState extends _OperationWindowPreState<RestoreWindow> {
  String? path;

  @override
  String? invalidMessage() {
    if (path == null) {
      return 'Select a backup-file first.';
    }
    return null;
  }

  @override
  void proceed() {
    final messenger = ScaffoldMessenger.of(context);
    widget.skeleton.restoreDataFrom(path!).then((sucess) {
      messenger.showSnackBar(SnackBar(
          content:
              Text(sucess ? 'Restoration completed' : 'Failed to restore')));
    });
  }

  @override
  String get windowTitle => 'Restore';

  @override
  String get nameOfAction => 'Restore';

  @override
  bool get danger => true;

  @override
  Widget get content {
    final messenger = ScaffoldMessenger.of(context);
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              try {
                // An unimplemented error can be thrown
                final result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  setState(() {
                    path = result.files.single.path;
                  });
                }
              } on UnimplementedError catch (_) {
                messenger.showSnackBar(SnackBar(
                    content:
                        Text('This action is not supported on this platform')));
              }
            },
            child: const Text('Select a backup-file')),
        Text(path == null ? 'No file selected' : 'Selected path: $path'),
      ],
    );
  }
}
