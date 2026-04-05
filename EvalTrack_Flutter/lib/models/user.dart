class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String? program;
  final int? yearLevel;
  final String? studentType;
  final bool mustChangePassword;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.program,
    this.yearLevel,
    this.studentType,
    required this.mustChangePassword,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      program: json['program'],
      yearLevel: json['year_level'] != null
          ? int.tryParse(json['year_level'].toString())
          : null,
      studentType: json['student_type'],
      mustChangePassword:
          json['must_change_password'] == 1 ||
          json['must_change_password'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'program': program,
      'year_level': yearLevel,
      'student_type': studentType,
      'must_change_password': mustChangePassword ? 1 : 0,
    };
  }
}
