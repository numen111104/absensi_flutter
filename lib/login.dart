import 'dart:async';
import 'dart:convert';
import 'package:absensi_flutter/models/login_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:absensi_flutter/config.dart';
import 'package:http/http.dart' as http;
import 'package:absensi_flutter/style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  static const route = '/login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.primaryColor,
      appBar: AppBar(
        backgroundColor: Style.secondaryColor,
        centerTitle: false,
        title: Text(
          "Absensi",
          textAlign: TextAlign.center,
          style: Style.heading,
        ),
      ),
      body: const SafeArea(
        child: MobileLoginWidget(),
      ),
    );
  }
}

class MobileLoginWidget extends StatefulWidget {
  const MobileLoginWidget({super.key});

  @override
  State<MobileLoginWidget> createState() => _PasswordState();
}

class _PasswordState extends State<MobileLoginWidget> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token, _name;
  bool _isEmailValid = true;
  bool _isHidden = true;
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pswrdCtrl = TextEditingController();

  Future login(email, password) async {
    LoginRespon? loginResModel;
    Map<String, String> body = {"email": email, "password": password};
    var response = await http.post(
      Uri.parse("$baseUrl/api/login"),
      body: body,
    );
    if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          backgroundColor: Style.tertiaryColor,
          content: Text(
        "Email / Password Salah", style: Style.inter,
      )));
    } else {
      loginResModel = LoginRespon.fromMap(jsonDecode(response.body));
      saveuser(loginResModel.data.token, loginResModel.data.name);
    }
  }

  Future saveuser(token, name) async {
    try {
      final SharedPreferences prefs = await _prefs;
      prefs.setString('token', token);
      prefs.setString('name', name);
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text(
        "Terjadi Kesalahan, ${e.toString()}",
      )));
    }
    Navigator.pushNamed(context, '/home');
  }

  checkToken(token, name) async {
    String tokenStr = await token;
    String nameStr = await name;
    if (tokenStr.isNotEmpty && nameStr.isNotEmpty) {
      Navigator.pushNamed(context, '/home');
    }
  }

  void _toggleVisablity() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Image.network(
              'https://raw.githubusercontent.com/numen111104/login-flutter/master/images/login.png',
              width: 200,
              height: 200,
            ),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: Style.container,
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Masuk ke Akun Anda",
                      style: Style.heading2,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8.5, bottom: 2.5),
                    child: TextField(
                      controller: _emailCtrl,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Style.secondaryColor,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Style.secondaryColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Style.secondaryColor)),
                        hintText: "Masukkan email anda",
                        hintStyle: Style.inter,
                        labelText: 'Email',
                        errorText: _isEmailValid ? null : "Email Gak Valid",
                        labelStyle: Style.inter,
                        filled: true,
                        fillColor: Style.primaryColor,
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _isEmailValid =
                              value.isEmpty ? true : isEmailValidRegex(value);
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8.5, bottom: 5),
                    child: TextField(
                      controller: _pswrdCtrl,
                      obscureText: _isHidden,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.key,
                          color: Style.secondaryColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: _toggleVisablity,
                          icon: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                            size: 20.0,
                            color: Style.secondaryColor,
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Style.secondaryColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Style.secondaryColor)),
                        hintText: "Masukkan password anda",
                        hintStyle:
                            GoogleFonts.inter(color: Style.secondaryColor),
                        labelText: 'Password',
                        labelStyle:
                            GoogleFonts.inter(color: Style.secondaryColor),
                        filled: true,
                        fillColor: Style.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Visibility(
                    visible: _isEmailValid && _pswrdCtrl.text.isNotEmpty,
                    child: ElevatedButton(
                        style: Style.btnPrimary,
                        onPressed: () {
                          login(_emailCtrl.text, _pswrdCtrl.text);
                        },
                        child: Text(
                          "Masuk",
                          style: TextStyle(color: Style.primaryColor),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 50,
          child: Center(
            child: Text(
              "- Dibuat dengan ❤ oleh Nu'man Nasyar MZ -",
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 10,
                  fontWeight: FontWeight.w100,
                  letterSpacing: 1.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pswrdCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    _token = _prefs
        .then((SharedPreferences prefs) => prefs.getString('token') ?? "");

    _name =
        _prefs.then((SharedPreferences prefs) => prefs.getString('name') ?? "");
    checkToken(_token, _name);
  }

  bool isEmailValidRegex(String email) {
    RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return regex.hasMatch(email);
  }
}
