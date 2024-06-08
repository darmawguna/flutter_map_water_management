import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultMargin = 30.0;

Color primaryColor = Colors.indigoAccent.shade700;
Color primaryDarkColor = Colors.blueAccent;
Color secondaryColor = const Color(0XFF39D2C0);
Color tertiaryColor = const Color(0xFFEE8B60);
Color primaryTextColor = const Color(0xFF29313E);
Color greenTextColor = const Color(0xFF09323B);
Color redTextColor = const Color(0xFFEB5757);
Color secondaryTextColor = const Color(0xFF728196);
Color hintTextColor = const Color(0xFF728196).withOpacity(0.5);
Color backgorundColor = const Color(0xFFF6F6F6);
Color backgorundFieldColor = const Color(0xFFEAEAEA);
Color whiteColor = const Color(0xFFFFFFFF);
Color black80 = const Color(0XFF1E1F2B);
Color black60 = const Color(0XFF666666);
Color black40 = const Color(0XFFE5E5E5);
//String base_url="http://192.168.1.5/registri/public";
String base_url = "http://10.10.18.110/registri/public";
TextStyle primaryTextStyle = GoogleFonts.poppins(
  color: primaryTextColor,
);

TextStyle secondaryTextStyle = GoogleFonts.poppins(
  color: secondaryTextColor,
);

TextStyle darkGreenTextStyle = GoogleFonts.poppins(
  color: greenTextColor,
);

TextStyle greenTextStyle = GoogleFonts.poppins(
  color: primaryColor,
);

TextStyle whiteTextStyle = GoogleFonts.poppins(
  color: whiteColor,
);
TextStyle hintTextStyle = GoogleFonts.poppins(
  color: hintTextColor,
);
final ButtonStyle elevatedstyle = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 14), backgroundColor: primaryColor);
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
