import "package:flutter/material.dart";

class AppTheme {
  static final lightDefault = ThemeData.light().copyWith(
    appBarTheme: AppBarThemeData(scrolledUnderElevation: 0),
    dividerTheme: DividerThemeData(space: 1),
  );
  static final darkDefault = ThemeData.dark().copyWith(
    appBarTheme: AppBarThemeData(scrolledUnderElevation: 0),
    dividerTheme: DividerThemeData(space: 1),
  );

  static final lightMaterial = ThemeData(
    brightness: .light,
    appBarTheme: AppBarThemeData(scrolledUnderElevation: 0),
    dividerTheme: DividerThemeData(space: 1),
  );

  static final darkMaterial = ThemeData(
    brightness: .dark,
    appBarTheme: AppBarThemeData(scrolledUnderElevation: 0),
    dividerTheme: DividerThemeData(space: 0),
  );

  static final amoled = ThemeData.dark().copyWith(
    colorScheme: ThemeData.dark().colorScheme.copyWith(
      brightness: .dark,
      surface: Colors.black,
      onSurface: Colors.white,
      surfaceDim: Colors.black,
      surfaceBright: Colors.black,
      surfaceContainerLowest: Colors.black,
      surfaceContainerLow: Colors.black,
      surfaceContainer: Colors.black,
      surfaceContainerHigh: Colors.black,
      surfaceContainerHighest: Colors.black,
      onSurfaceVariant: Colors.white,
      primary: Colors.white,
    ),
    appBarTheme: AppBarThemeData(scrolledUnderElevation: 0),
    dividerTheme: DividerThemeData(space: 1),
  );
}
