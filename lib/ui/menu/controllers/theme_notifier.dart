import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "theme_notifier.g.dart";

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => .system;

  void set(ThemeMode value) {
    state = value;
  }
}
