import 'dart:convert';

SavePresensiModel savePresensiModelFromMap(String str) =>
    SavePresensiModel.fromMap(json.decode(str));

String savePresensiModelToMap(SavePresensiModel data) =>
    json.encode(data.toMap());

class SavePresensiModel {
  final bool success;
  final String message;
  final Data data;

  SavePresensiModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SavePresensiModel.fromMap(Map<String, dynamic> json) =>
      SavePresensiModel(
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
  final int userId;
  final String latitude;
  final String longitude;
  final DateTime tanggal;
  final String masuk;
  final dynamic pulang;
  final DateTime createdAt;
  final DateTime updatedAt;

  Data({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.tanggal,
    required this.masuk,
    required this.pulang,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        tanggal: DateTime.parse(json["tanggal"]),
        masuk: json["masuk"],
        pulang: json["pulang"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "latitude": latitude,
        "longitude": longitude,
        "tanggal":
            "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "masuk": masuk,
        "pulang": pulang,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
