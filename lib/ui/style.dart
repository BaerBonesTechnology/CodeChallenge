import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData dListThemeData = ThemeData(
    appBarTheme: AppBarTheme(
        shape: Border.fromBorderSide(BorderSide(
          color: Color(Colors.grey[300]?.value ?? 0xFFE0E0E0),
          width: 1,
          strokeAlign: BorderSide.strokeAlignOutside,
          style: BorderStyle.solid,
        )),
        iconTheme: IconThemeData(
          color: Colors.blue[700],
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.blue[800]),
          padding:
              const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 2.0)),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          minimumSize: const WidgetStatePropertyAll(Size(200, 60))),
    ),
    colorSchemeSeed: Colors.blue[700],
    textTheme: GoogleFonts.nunitoSansTextTheme(const TextTheme(
      displayLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
      displaySmall: TextStyle(
        fontSize: 13,
        color: Color(0xFF070f1c),
      ),
      bodyLarge: TextStyle(
        fontSize: 16
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
      )
    )),
    checkboxTheme: const CheckboxThemeData(
      side: BorderSide(width: 0, strokeAlign: BorderSide.strokeAlignOutside),
    ),
    iconTheme: IconThemeData(
      color: Colors.blue[700],
    ),
    snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF070f1c),
        closeIconColor: Colors.white,
        showCloseIcon: false,
        actionTextColor: Colors.white,
        contentTextStyle: TextStyle(
          fontSize: 12,
        ),
      insetPadding: EdgeInsets.all(5.0)
    ));
