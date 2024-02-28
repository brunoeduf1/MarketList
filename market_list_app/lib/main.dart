// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:market_list_app/pages/app_widget.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
