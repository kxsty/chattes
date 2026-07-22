import "package:flutter/material.dart";

const kBorderSide = BorderSide(style: .solid);

const kDivider = Divider(height: 1);
const kVerticalDivider = VerticalDivider(width: 1);

final themeNotifier = ValueNotifier<ThemeMode>(.system);
