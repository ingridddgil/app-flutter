import 'dart:convert';

import '../models/progress_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressRepository {
  // Singleton
  ProgressRepository._internal();
  static final ProgressRepository instance = ProgressRepository._internal();

  static const _storageKey = 'progress_records';

  final List<ProgressData> _items = [];

  List<ProgressData> getAll() => List.unmodifiable(_items);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    final decoded = jsonDecode(raw) as List<dynamic>;
    _items
      ..clear()
      ..addAll(
        decoded.map(
          (e) => ProgressData.fromJson(Map<String, dynamic>.from(e)),
        ),
      );
  }

  void add(ProgressData data) {
    _items.add(data);
    _save();
  }

  void updateById(String id, ProgressData newData) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;
    _items[index] = newData;
    _save();
  }
  
  void removeById(String id) {
    _items.removeWhere((item) => item.id == id);
    _save();
  }

  void clear() {
    _items.clear();
    _clearStorage();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_items.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }

  Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
