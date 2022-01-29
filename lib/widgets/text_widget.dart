// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CText extends StatelessWidget {
  String text;
  TextStyle? textStyle;
  Color? color;
  Color? backgroundColor;
  double? fontSize;
  FontWeight? fontWeight;
  FontStyle? fontStyle;
  double? letterSpacing;
  double? wordSpacing;
  TextBaseline? textBaseline;
  double? height;
  Locale? locale;
  Paint? foreground;
  Paint? background;
  List<Shadow>? shadows;
  List<FontFeature>? fontFeatures;
  TextDecoration? decoration;
  Color? decorationColor;
  TextDecorationStyle? decorationStyle;
  double? decorationThickness;
  CText(this.text,
      {this.textStyle,
      this.color,
      this.backgroundColor,
      this.fontSize,
      this.fontWeight,
      this.fontStyle,
      this.letterSpacing,
      this.wordSpacing,
      this.textBaseline,
      this.height,
      this.locale,
      this.foreground,
      this.background,
      this.shadows,
      this.fontFeatures,
      this.decoration,
      this.decorationColor,
      this.decorationStyle,
      this.decorationThickness,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          textStyle: textStyle,
          color: color,
          backgroundColor: backgroundColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          textBaseline: textBaseline,
          height: height,
          locale: locale,
          foreground: foreground,
          background: background,
          shadows: shadows,
          fontFeatures: fontFeatures,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThickness: decorationThickness),
    );
  }
}
