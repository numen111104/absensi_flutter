import 'dart:convert';

import 'package:absensi_flutter/config.dart';
import 'package:absensi_flutter/models/simpan_presensi.dart';
import 'package:absensi_flutter/style.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:http/http.dart' as http;


class SimpanPage extends StatefulWidget {
  static const route = '/tambah_data';
  const SimpanPage({super.key});

  @override
  State<SimpanPage> createState() => _SimpanPageState();
}

class _SimpanPageState extends State<SimpanPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token;

  Future<LocationData?> _currentLocation() async {
    bool serviceEnable;
    PermissionStatus permission;
    Location location = Location();
    serviceEnable = await location.serviceEnabled();
    if (!serviceEnable) {
      serviceEnable = await location.requestService();
      if (!serviceEnable) {
        return Future.error("Service not enable");
      }
    }
    permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return Future.error("Permission not granted");
      }
    }
    return await location.getLocation();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = _prefs.then((value) => value.getString("token") ?? "");
  }

  Future savePresensi(latitude, longitude) async {
    SavePresensiModel savePresensiModel;
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${await _token}',
    };
    final Map<String, String> body = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    };
    var response = await http.post(
      Uri.parse('$baseUrl/api/save-presensi'),
      headers: headers,
      body: {
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      },
    );
    if (response.statusCode == 200) {
      savePresensiModel = SavePresensiModel.fromMap(json.decode(response.body));
      if (savePresensiModel.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Style.tertiaryColor,
          content: Text(savePresensiModel.message, style: Style.inter),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Style.tertiaryColor,
          content: Text(savePresensiModel.message, style: Style.inter),
        ));
        Navigator.pop(context);
      }
    } else {
      throw Exception("Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Style.secondaryColor,
          title: Text("Absen", style: Style.heading),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          iconTheme: IconThemeData(color: Style.primaryColor),
        ),
        backgroundColor: Style.primaryColor,
        body: FutureBuilder<LocationData?>(
          future: _currentLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(children: [
                  Icon(Icons.warning_rounded, color: Style.secondaryColor),
                  const SizedBox(
                    height: 80,
                  ),
                  Text("Error: ${snapshot.error}", style: Style.inter),
                ]),
              );
            } else {
              final LocationData currentLocation = snapshot.data!;
              return SafeArea(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: Style.container.copyWith(
                        boxShadow: [
                          BoxShadow(
                            color: Style.secondaryColor,
                            offset: const Offset(-6, -7),
                          )
                        ],
                      ),
                      height: 300,
                      child: SfMaps(
                        layers: [
                          MapTileLayer(
                            initialFocalLatLng: MapLatLng(
                                currentLocation.latitude!,
                                currentLocation.longitude!),
                            initialZoomLevel: 15,
                            initialMarkersCount: 1,
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            markerBuilder: (BuildContext context, int index) {
                              return MapMarker(
                                latitude: currentLocation.latitude!,
                                longitude: currentLocation.longitude!,
                                child: const Icon(
                                  size: 70,
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: Style.btnPrimary,
                    onPressed: () {
                      savePresensi(
                        currentLocation.latitude,
                        currentLocation.longitude,
                      );
                    },
                    child: Text(
                      "Simpan Presensi",
                      style: Style.inter.copyWith(
                        color: Style.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,

                  ),
                  Text("Lokasi anda", style: Style.inter),
                  Text("Latitude: ${currentLocation.latitude}", style: Style.inter),
                  Text("Longitude: ${currentLocation.longitude}", style: Style.inter),
                ],
              ),);
            }
          },
        ));
  }
}
