// To parse this JSON data, do
//
//     final loginRespon = loginResponFromMap(jsonString);

import 'dart:convert';

LoginRespon loginResponFromMap(String str) => LoginRespon.fromMap(json.decode(str));

String loginResponToMap(LoginRespon data) => json.encode(data.toMap());

class LoginRespon {
    final bool success;
    final String message;
    final Data data;

    LoginRespon({
        required this.success,
        required this.message,
        required this.data,
    });

    factory LoginRespon.fromMap(Map<String, dynamic> json) => LoginRespon(
        success: json["success"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data.toMap(),
    };
}

class Data {
    final int id;
    final String name;
    final String email;
    final dynamic emailVerifiedAt;
    final DateTime createdAt;
    final DateTime updatedAt;
    final String token;
    final String tokenType;

    Data({
        required this.id,
        required this.name,
        required this.email,
        required this.emailVerifiedAt,
        required this.createdAt,
        required this.updatedAt,
        required this.token,
        required this.tokenType,
    });

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        token: json["token"],
        tokenType: json["token_type"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "token": token,
        "token_type": tokenType,
    };
}
