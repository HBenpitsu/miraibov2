import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miraibo/skeleton/impl.dart' as skt;
import 'package:miraibo/view/root.dart' as view;
import 'package:miraibo/repository/impl.dart' as repository;

void main() async {
  repository.bind();
  final skeleton = skt.RootImpl();
  skt.dispatchEvents();
  runApp(view.AppRoot(skeleton));
}
