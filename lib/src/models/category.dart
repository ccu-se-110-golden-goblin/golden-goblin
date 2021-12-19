import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Type { income, expenses }

class Category {
  // basic props
  final int id;
  final String name;
  final Type type;
  final IconData iconData;
  final Color iconColor;

  // construct
  Category({
    required this.id,
    required this.name,
    required this.type,
    this.iconData = Icons.restaurant,
    this.iconColor = const Color(0xFF99D6EA),
  });

  // Convert a Transaction into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'iconData': iconData,
      'iconColor': iconColor,
    };
  }

  // Implement toString to make Category easier to use the print statement.
  @override
  String toString() {
    return 'Category{id: $id, name: $name, type: $type, iconData: $iconData, iconColor: $iconColor}';
  }
}
