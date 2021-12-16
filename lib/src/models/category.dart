import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Type { income, expenses }

class Category {
  // basic props
  final int id;
  final String name;
  final Type type;
  final IconData iconData = Icons.restaurant;
  final Color iconColor = const Color(0xFF99D6EA);

  // construct
  Category({
    required this.id,
    required this.name,
    required this.type,
  });

  // DEBUG ONLY: Convert a Transaction into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  // Implement toString to make Category easier to use the print statement.
  @override
  String toString() {
    return 'Transaction{id: $id, name: $name, type: $type}';
  }
}