import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/impl.dart' as skt;
import 'package:miraibo/view/root.dart' as view;
import 'package:miraibo/isolate_glue/isolate_glue.dart' as isolate_glue;
import 'package:miraibo/repository/impl.dart' as repository;

void main() async {
  repository.bind();
  final skeleton = skt.RootImpl();
  await isolate_glue.initializeApp();
  await isolate_glue.instanciateScheduleUntilToday();
  runApp(view.AppRoot(skeleton));
}
