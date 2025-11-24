import 'package:flutter_demo/data/models/progress_details_data.dart';

class ProgressRepository {
  // We'll use Singleton :) If   could see this maybe he would be happy 
  ProgressRepository._internal();
  static final ProgressRepository instance = ProgressRepository._internal();

  final List<ProgressData> _items = [];

  List<ProgressData> getAll() => List.unmodifiable(_items);

  void add(ProgressData data){
    _items.add(data);
  }

  void updateById(String id, ProgressData newData){
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;
    _items[index] = newData;
  }
  
  void removeById(String id){
    _items.removeWhere((item) => item.id == id);
  }

  void clear(){
    _items.clear();
  }
}