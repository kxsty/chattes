import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

final themeModeProvider = AsyncNotifierProvider.autoDispose(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final instance = await SharedPreferences.getInstance();
    final index = instance.getInt("theme_mode");
    if (index == null) {
      return .system;
    }

    return ThemeMode.values[index];
  }

  Future<void> set(ThemeMode value) async {
    final instance = await SharedPreferences.getInstance();
    instance.setInt("theme_mode", value.index);

    state = AsyncData(value);
  }
}
