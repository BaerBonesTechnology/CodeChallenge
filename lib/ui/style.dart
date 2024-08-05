import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../constants/padding_value.dart';
import '../constants/font_size.dart';

ThemeData dListThemeData = ThemeData(
  appBarTheme: AppBarTheme(
    centerTitle: true,
    shape: Border.fromBorderSide(
      BorderSide(
        color: primaryWhite,
        width: 1,
        strokeAlign: BorderSide.strokeAlignOutside,
        style: BorderStyle.solid,
      ),
    ),
    iconTheme: IconThemeData(
      color: primaryBlue,
    ),
    titleTextStyle: const TextStyle(
      fontSize: FontSize.medium,
      fontWeight: FontWeight.w800,
      color: black,
    ),
  ),
  checkboxTheme: const CheckboxThemeData(
    side: BorderSide(width: 0.0, strokeAlign: BorderSide.strokeAlignOutside),
  ),
  colorSchemeSeed: primaryBlue,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(primaryBlue),
      padding: const WidgetStatePropertyAll(
        PaddingValue.xxSmall,
      ),
      foregroundColor: WidgetStatePropertyAll(primaryWhite),
      minimumSize: const WidgetStatePropertyAll(Size(200, 60)),
      textStyle: const WidgetStatePropertyAll(TextStyle(
        fontSize: FontSize.small,
        fontWeight: FontWeight.w800,
      )),
    ),
  ),
  iconTheme: IconThemeData(
    color: primaryBlue,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: secondaryBlue,
    closeIconColor: primaryWhite,
    showCloseIcon: false,
    actionTextColor: primaryWhite,
    contentTextStyle: TextStyle(
      fontSize: FontSize.xsmall,
      color: primaryWhite,
    ),
    insetPadding: PaddingValue.snackBarDefault,
  ),
  textTheme: GoogleFonts.nunitoSansTextTheme(
    const TextTheme(
      displayLarge: TextStyle(
        fontSize: FontSize.large,
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        fontSize: FontSize.medium,
        fontWeight: FontWeight.w800,
      ),
      displaySmall: TextStyle(
        fontSize: FontSize.small,
        color: secondaryBlue,
      ),
      bodyLarge: TextStyle(fontSize: FontSize.medium),
      bodyMedium: TextStyle(
        fontSize: FontSize.displayMedium,
      ),
      bodySmall: TextStyle(
        fontSize: FontSize.xsmall,
      ),
    ),
  ),
);
