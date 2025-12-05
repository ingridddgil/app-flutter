// materialApp, rutas, tema
import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

class AppOdoo extends StatelessWidget {
  const AppOdoo({super.key});
  
  @override 
  Widget build(BuildContext context) {
    return MaterialApp (
      debugShowCheckedModeBanner: true,
      title: 'Odoo app',
      theme: ThemeData (
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF8B1E04))
      ),
      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}