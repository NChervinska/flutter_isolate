import 'package:flutter/material.dart';
import 'package:flutter_isolate/isolate_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IsolateApp());
}
