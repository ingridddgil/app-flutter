import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/screens/login.dart';


class AppRoutes {
  static const home = '/';

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => LoginPage(),
  }; 
}