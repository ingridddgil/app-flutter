import 'package:flutter/material.dart';
import 'app.dart';
import 'data/repositories/progress_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressRepository.instance.init();
  runApp(const AppOdoo());
}
