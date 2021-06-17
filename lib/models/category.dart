import 'package:flutter/material.dart';

class Category {
  final String title;
  final String subTitle;
  final IconData icon;

  Category(this.title, this.subTitle, this.icon);
}

List<Category> getCategories() {
  return [
    Category("wedding", "test", Icons.web),
    Category("efdzaed", "test", Icons.web),
    Category("test", "test", Icons.web)
  ];
}
