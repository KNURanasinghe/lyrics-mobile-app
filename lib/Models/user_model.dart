class UserModel {
  final String fullname;
  final String email;
  final String phonenumber;
  final String password;
  final int? id; // Added to store user ID from backend

  UserModel({
    required this.fullname,
    required this.email,
    required this.phonenumber,
    required this.password,
    this.id,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      phonenumber: json['phonenumber'] as String,
      password: '', // Password won't be returned from the API
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'fullname': fullname,
      'email': email,
      'phonenumber': phonenumber,
      'password': password,
    };
  }

  // Copy with method for immutability
  UserModel copyWith({
    String? fullname,
    String? email,
    String? phonenumber,
    String? password,
    int? id,
  }) {
    return UserModel(
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      phonenumber: phonenumber ?? this.phonenumber,
      password: password ?? this.password,
      id: id ?? this.id,
    );
  }
}
