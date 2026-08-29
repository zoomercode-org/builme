import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/material_item.dart';
import '../core/mock/mock_data.dart';

class MaterialNotifier extends StateNotifier<List<MaterialItem>> {
  MaterialNotifier() : super(MockData.materials);

  void addMaterial(MaterialItem item) {
    state = [item, ...state];
  }
}

final materialProvider = StateNotifierProvider<MaterialNotifier, List<MaterialItem>>((ref) {
  return MaterialNotifier();
});
