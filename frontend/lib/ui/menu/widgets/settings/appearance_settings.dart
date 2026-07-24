import "package:chattes/ui/menu/providers/chat_list_settings.dart";
import "package:chattes/ui/menu/providers/theme_mode.dart";
import "package:chattes/ui/menu/widgets/settings/settings_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AppearanceSettings extends StatelessWidget {
  const AppearanceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .start,
      children: [
        SettingsHeader(title: "Appearance"),

        _ThemeSelector(),

        _ChatListAlignmentSelector(),
      ],
    );
  }
}

class _ChatListAlignmentSelector extends StatelessWidget {
  const _ChatListAlignmentSelector();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Chat list alignment"),
      trailing: Consumer(
        builder: (context, ref, child) => SegmentedButton<bool>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(
              value: false,
              icon: Icon(Icons.vertical_align_top_rounded),
              tooltip: "Top",
            ),

            ButtonSegment(
              value: true,
              icon: Icon(Icons.vertical_align_bottom_rounded),
              tooltip: "Bottom",
            ),
          ],

          selected: {
            (ref.watch(chatListSettingsProvider).value ?? .new()).alignBottom,
          },

          onSelectionChanged: (Set<bool> selection) => ref
              .read(chatListSettingsProvider.notifier)
              .setAlignBottom(selection.first),
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Theme"),
      trailing: Consumer(
        builder: (context, ref, child) => SegmentedButton<ThemeMode>(
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

          selected: {ref.watch(themeModeProvider).value ?? .system},

          onSelectionChanged: (Set<ThemeMode> selection) =>
              ref.read(themeModeProvider.notifier).set(selection.first),
        ),
      ),
    );
  }
}
