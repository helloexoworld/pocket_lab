import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:pocket_lab/widgets/app.dart';

void main() {
  HttpOverrides.global = new StethoHttpOverrides();

  runApp(new App());
}