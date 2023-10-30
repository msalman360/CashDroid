import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  double total;

  Category({
    required this.name,
    required this.icon,
    this.total = 0.0,
  });
}