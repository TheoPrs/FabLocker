import 'items.dart';
class Locker {
  late int id;
  late Item? item;

  Locker({required this.id, this.item});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item': item
    };
  }

  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
      id: json['id'],
      item : json['itemId']
    );
  }
}

