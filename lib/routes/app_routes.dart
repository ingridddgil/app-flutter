import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/screens/login.dart';
import 'package:flutter_demo/ui/screens/menu.dart';


class AppRoutes {
  static const home = '/';
  static const menu = 'menu';

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => LoginPage(),
    menu: (_) => MenuPage(),
  }; 
}