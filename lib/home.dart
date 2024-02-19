import 'dart:convert';
import 'package:absensi_flutter/models/home_response.dart';
import 'package:absensi_flutter/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token, _name;
  static const size = 15.0;

  HomeRespon? homeResModel;
  Datum? today;
  List<Datum> history = [];

  @override
  void initState() {
    super.initState();
    _token = _prefs
        .then((SharedPreferences prefs) => prefs.getString('token') ?? "");

    _name =
        _prefs.then((SharedPreferences prefs) => prefs.getString('name') ?? "");
  }

  Future logout() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('token');
    prefs.remove('name');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getData() async {
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${await _token}',
    };
    var response = await http.get(
      Uri.parse('$baseUrl/api/get-presensi'),
      headers: headers,
    );
    homeResModel = HomeRespon.fromMap(json.decode(response.body));
    history.clear();
    homeResModel!.data.forEach((element) {
      if (element.isHariIni) {
        today = element;
      } else {
        history.add(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                  child: Column(children: [
                const Icon(
                  Icons.warning_rounded,
                ),
                const SizedBox(
                  height: 80,
                ),
                Text(
                  "Error: ${snapshot.error} \n\n ${snapshot.stackTrace}",
                  style: Style.inter,
                )
              ]));
            } else {
              return SafeArea(
                child: RefreshIndicator(
                  onRefresh: getData,
                  child: Scaffold(
                    backgroundColor: Style.primaryColor,
                    appBar: AppBar(
                      centerTitle: true,
                      elevation: 0,
                      iconTheme: IconThemeData(color: Style.primaryColor),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.logout, color: Style.primaryColor),
                          onPressed: logout,
                        )
                      ],
                      backgroundColor: Style.secondaryColor,
                      title: FutureBuilder(
                          future: _name,
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!,
                                  style: Style.heading.copyWith(fontSize: 20),
                                );
                              } else {
                                return const Text("-");
                              }
                            }
                          }),
                    ),
                    body: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.center,
                          child: Container(
                            margin: const EdgeInsets.all(size),
                            decoration: Style.container.copyWith(
                              boxShadow: [
                                BoxShadow(
                                  color: Style.secondaryColor,
                                  offset: const Offset(7, -7),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(today?.tanggal.toString() ?? '-',
                                      style: Style.inter.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 21)),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(size),
                                      child: Column(
                                        children: [
                                          Text(today?.masuk.toString() ?? '-',
                                              style: Style.inter.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                          Text("Masuk",
                                              style: Style.inter
                                                  .copyWith(fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(size),
                                      child: Column(
                                        children: [
                                          Text(today?.pulang.toString() ?? '-',
                                              style: Style.inter.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          Text("Pulang",
                                              style: Style.inter
                                                  .copyWith(fontSize: 13)),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: size, vertical: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Riwayat Kehadiran",
                              style: Style.inter.copyWith(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: history.length,
                            itemBuilder: (context, index) => Card(
                              color: Style.tertiaryColor,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: size, horizontal: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Tanggal Absensi",
                                            style: Style.inter.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            history[index].tanggal,
                                            style: Style.inter.copyWith(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Masuk",
                                            style: Style.inter.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(history[index].masuk,
                                              style: Style.inter
                                                  .copyWith(fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    Column(children: [
                                      Text(
                                        "Pulang",
                                        style: Style.inter.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        history[index].pulang,
                                        style:
                                            Style.inter.copyWith(fontSize: 12),
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                      ],
                    ),
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: Style.secondaryColor,
                      onPressed: () {
                        Navigator.pushNamed(context, '/tambah_data')
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Icon(
                        Icons.add,
                        color: Style.tertiaryColor,
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        });
  }
}
