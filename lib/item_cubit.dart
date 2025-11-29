import 'package:flutter_bloc/flutter_bloc.dart';
import 'item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ItemCubit extends Cubit<List<Item>> {
  ItemCubit() : super([]) {
    loadItems();
  }

  // Load saved items
  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('items');

    if (data != null) {
      final List decoded = jsonDecode(data);
      emit(decoded.map((e) => Item.fromJson(e)).toList());
    }
  }

  // Save items to SharedPreferences
  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString('items', encoded);
  }

  // Add new item
  void addItem(String title) {
    final newList = List<Item>.from(state)..add(Item(title: title));
    emit(newList);
    saveItems();
  }

  // Toggle item complete/incomplete
  void toggleItem(int index) {
    final newList = List<Item>.from(state);
    final item = newList[index];

    newList[index] = Item(title: item.title, isDone: !item.isDone);
    emit(newList);
    saveItems();
  }

  // Delete item
  void deleteItem(int index) {
    final newList = List<Item>.from(state)..removeAt(index);
    emit(newList);
    saveItems();
  }
}
