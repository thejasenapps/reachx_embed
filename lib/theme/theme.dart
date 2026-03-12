import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reachx_embed/core/constants/color.dart';
import 'package:reachx_embed/core/helper/hexColor.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: HexColor(mainColor),
      primaryColorDark: HexColor(mainColor),
      primaryColorLight: HexColor(mainColor),
      iconTheme: IconThemeData(
        color: HexColor(black),
      ),
      cardColor: HexColor(containerColor),
      scaffoldBackgroundColor: HexColor(secondaryBackgroundColor),
      fontFamily: GoogleFonts.outfit().fontFamily,
      textTheme: TextTheme(
        bodySmall: TextStyle(
          color: HexColor(black),
        ),
        bodyLarge: TextStyle(
          color: HexColor(black),
        ),
        bodyMedium: TextStyle(
          color: HexColor(black),
        )
      )
    );
  }
}