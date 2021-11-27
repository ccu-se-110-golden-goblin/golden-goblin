import 'package:flutter/material.dart';

class Book {
  // props
  final int id;
  final String name;
  final Icon icon;
  final Color iconColor;

  // construct
  Book({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
  });

  // DEBUG ONLY: Convert a Transaction into a Map.
  Map<String, dynamic> toMap() {
    return {
      'amount': id,
      'book': name,
      'category': icon,
      'date': iconColor,
    };
  }

  // Implement toString to make Book easier to use the print statement.
  @override
  String toString() {
    return 'Book{id: $id, name: $name, icon: $icon, iconColor: $iconColor}';
  }
}
