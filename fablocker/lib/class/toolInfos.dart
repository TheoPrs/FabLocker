import 'locker.dart';

class ToolInfo {
  Locker locker;
  bool availability;
  int weight;
  String name;
  int borrow_duration;
  String description;
  int? itemId;

  ToolInfo({
    required this.locker,
    required this.availability,
    required this.weight,
    required this.name,
    required this.borrow_duration,
    required this.description,
    this.itemId
  });
}
