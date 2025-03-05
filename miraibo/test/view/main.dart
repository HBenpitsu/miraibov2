import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/mock.dart' as skeleton;
import 'package:miraibo/view/root.dart' as view;

void main() {
  final mockSkeleton = skeleton.MockRoot();
  runApp(view.AppRoot(mockSkeleton));
}
