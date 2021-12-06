import 'package:flutter/material.dart';

class Account {
  // props
  final int id;
  final String name;
  final IconData icon;
  final Color iconColor;

  // construct
  Account({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconColor,
  });

  // DEBUG ONLY: Convert a Transaction into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'iconColor': iconColor,
    };
  }

  // Implement toString to make Account easier to use the print statement.
  @override
  String toString() {
    return 'Account{id: $id, name: $name, icon: $icon, iconColor: $iconColor}';
  }
}
