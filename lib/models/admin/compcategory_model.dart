//compcategory_model.dart
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['categoryname'].toString(),
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;

  MenuItem(this.title, this.icon);
}
