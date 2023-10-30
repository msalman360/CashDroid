import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CategoryStorage {
  static const String _key = 'categories';

  Future<List<Category>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoryData = prefs.getStringList(_key);

    if (categoryData != null) {
      return categoryData.map((data) => Category.fromJson(jsonDecode(data))).toList();
    }

    return [];
  }


  Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final categoryData = categories.map((category) => jsonEncode(category.toJson())).toList();
    await prefs.setStringList(_key, categoryData);
  }



}
class Category {
  String name;
  String icon;

  Category({required this.name, required this.icon});

  // Create a constructor to convert JSON data to a Category object
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      icon: json['icon'],
    );
  }

  // Create a method to convert a Category object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
    };
  }
}
