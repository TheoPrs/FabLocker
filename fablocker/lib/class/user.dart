class User {
  final int rfid;
  final String role;
  final String email;
  final String password;

  User({
    required this.rfid,
    required this.role,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'rfid': rfid,
      'admin': role,
      'eemail': email,
      'password': password,
    };
  }
}
