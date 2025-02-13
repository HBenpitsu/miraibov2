import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/root.dart' as skeleton;
import 'package:miraibo/view/root.dart' as view;

void main() {
  final mockSkeleton = skeleton.MockRoot();
  final app = view.AppRoot(mockSkeleton);
  runApp(app);
}
