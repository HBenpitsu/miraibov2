import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/mock.dart' as skeleton;
import 'package:miraibo/view/root.dart' as view;
import 'package:miraibo/isolate_glue/isolate_glue.dart' as isolate_glue;
import 'package:miraibo/repository/impl.dart' as repository;

void main() async {
  repository.bind();
  final mockSkeleton = skeleton.MockRoot();
  await isolate_glue.initializeApp();
  await isolate_glue.instanciateScheduleUntilToday();
  runApp(view.AppRoot(mockSkeleton));
}
