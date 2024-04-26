class Locker {
  late int id;
  late int? itemId;

  Locker({required this.id, this.itemId});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId
    };
  }

  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
      id: json['id'],
      itemId : json['itemId']
    );
  }
}

