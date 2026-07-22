import "package:chattes/ui/menu/controllers/theme_notifier.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(children: [AppearanceSelector()]),
    );
  }
}

class AppearanceSelector extends StatelessWidget {
  const AppearanceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Appearance"),
      trailing: Consumer(
        builder: (context, ref, child) {
          return SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.brightness_auto),
                tooltip: "System",
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode),
                tooltip: "Light",
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode),
                tooltip: "Dark",
              ),
            ],
            selected: {ref.watch(themeModeProvider)},
            onSelectionChanged: (Set<ThemeMode> newSelection) =>
                ref.read(themeModeProvider.notifier).set(newSelection.first),
          );
        },
      ),
    );
  }
}
