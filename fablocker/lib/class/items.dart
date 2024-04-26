// ignore_for_file: non_constant_identifier_names

import 'locker.dart';


class Item {
  late Locker lockerId;
  final String name;
  final String description;
  final bool availability;
  final double weight;
  final int borrow_duration;

  Item({
    required this.lockerId,
    required this.name,
    required this.description,
    required this.availability,
    required this.weight,
    required this.borrow_duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'locker': lockerId.toJson(),
      'name': name,
      'description': description,
      'availability': availability,
      'weight': weight,
      'borrow_duration' : borrow_duration,
    };

  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      lockerId: Locker.fromJson(json['id_locker']),
      name: json['name'],
      description: json['description'],
      availability: json['availability'],
      weight: json['weight'],
      borrow_duration: json['borrow_duration'],

    );
  }
}
