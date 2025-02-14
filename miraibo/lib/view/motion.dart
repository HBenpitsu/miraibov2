import 'dart:ui';
import 'package:flutter/material.dart';

/* This custom scroll behavior enables mouse wheel */
class MouseScrollBehavior extends MaterialScrollBehavior {
  const MouseScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
