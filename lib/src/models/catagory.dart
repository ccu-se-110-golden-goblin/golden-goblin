enum Type { icoming, expenses }

class Catagory {
  // basic props
  final int id;
  final String name;
  final Type type;

  // construct
  Catagory({
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

  // Implement toString to make Catagory easier to use the print statement.
  @override
  String toString() {
    return 'Transaction{id: $id, name: $name, type: $type}';
  }
}
