import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final themeModeProvider = NotifierProvider.autoDispose(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => .system;

  void set(ThemeMode value) {
    state = value;
  }
}
