import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import 'dart:convert';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]) {
    _loadCategories();
  }

  void _loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final categoryList = prefs.getString('categories');
    if (categoryList != null) {
      state = List<Category>.from(json.decode(categoryList).map((cat) => Category.fromJson(cat)));
    }
  }

  void _saveCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('categories', json.encode(state.map((cat) => cat.toJson()).toList()));
  }

  void addCategory(String name) {
    state = [...state, Category(name: name)];
    _saveCategories();
  }

  void removeCategory(int index) {
    state = state.where((cat) => cat != state[index]).toList();
    _saveCategories();
  }
}

final categoryProvider = StateNotifierProvider<CategoryNotifier, List<Category>>((ref) {
  return CategoryNotifier();
});
