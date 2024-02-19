import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static Color primaryColor = const Color(0xffF9E6E6);
  static Color secondaryColor = const Color(0xFF474BCA);
  static Color tertiaryColor = const Color(0xFFFFF2F9);

  static TextStyle heading =
      GoogleFonts.poppins(color: primaryColor, fontSize: 25.0);

  static TextStyle heading2 = GoogleFonts.poppins(
    color: Style.secondaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  static TextStyle inter =
      GoogleFonts.inter(color: Style.secondaryColor, fontSize: 14);

  static BoxDecoration container = BoxDecoration(
    color: Style.primaryColor,
    boxShadow: [
      BoxShadow(color: Style.secondaryColor, offset: const Offset(6, 6))
    ],
    border: Border.all(
      color: Style.secondaryColor,
      width: 1,
      style: BorderStyle.solid,
    ),
  );

  static ButtonStyle btnPrimary = ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Style.secondaryColor),);
}
