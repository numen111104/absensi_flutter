import 'dart:convert';

HomeRespon homeResponFromMap(String str) =>
    HomeRespon.fromMap(json.decode(str));

String homeResponToMap(HomeRespon data) => json.encode(data.toMap());

class HomeRespon {
  final bool success;
  final String message;
  final List<Datum> data;

  HomeRespon({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HomeRespon.fromMap(Map<String, dynamic> json) => HomeRespon(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Datum {
  final int id;
  final int userId;
  final String latitude;
  final String longitude;
  final String tanggal;
  final String masuk;
  final String pulang;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isHariIni;

  Datum({
    required this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.tanggal,
    required this.masuk,
    required this.pulang,
    required this.createdAt,
    required this.updatedAt,
    required this.isHariIni,
  });

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        tanggal: json["tanggal"],
        masuk: json["masuk"],
        pulang: json["pulang"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isHariIni: json["is_hari_ini"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "latitude": latitude,
        "longitude": longitude,
        "tanggal": tanggal,
        "masuk": masuk,
        "pulang": pulang,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_hari_ini": isHariIni,
      };
}
