class Locker {
  late int id;

  Locker({required this.id});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  factory Locker.fromJson(Map<String, dynamic> json) {
    return Locker(
      id: json['id'],
    );
  }
}

