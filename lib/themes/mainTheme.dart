
import 'package:flutter/material.dart';

const textColor = Color(0xFFecefee);
const backgroundColor = Color(0xFF070e0b);
const primaryColor = Color(0xFF95debd);
const primaryFgColor = Color(0xFF070e0b);
const secondaryColor = Color(0xFF15985d);
const secondaryFgColor = Color(0xFF070e0b);
const accentColor = Color(0xFF23fd9a);
const accentFgColor = Color(0xFF070e0b);

const colorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  surface: backgroundColor,
  onSurface: textColor,
  error: Brightness.dark == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
  onError: Brightness.dark == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
);