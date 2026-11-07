import "package:chattes/data/frb_generated.dart";
import "package:chattes/ui/core/constants.dart";
import "package:chattes/ui/core/rust_app.dart";
import "package:chattes/ui/menu/providers/theme_mode.dart";
import "package:chattes/ui/widget_tree.dart";
import "package:dynamic_color/dynamic_color.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

Future<void> main() async {
  await RustLib.init();
  await Api().initialize();

  final themeMode = await ThemeModeNotifier().build();

  runApp(
    ProviderScope(
      overrides: [themeModeProvider.overrideWithBuild((_, _) => themeMode)],
      child: const _App(),
    ),
  );
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) => DynamicColorBuilder(
    builder: (lightDynamic, darkDynamic) {
      if (lightDynamic == null || darkDynamic == null) {
        return const SizedBox.shrink();
      }

      return Consumer(
        builder: (context, ref, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Chattes",
            theme: .from(colorScheme: lightDynamic).copyWith(
              highlightColor: kColorTransparent,
              actionIconTheme: .new(
                backButtonIconBuilder: (_) =>
                    const Icon(Icons.arrow_back_rounded),
              ),
            ),
            darkTheme: .from(colorScheme: darkDynamic).copyWith(
              highlightColor: kColorTransparent,
              actionIconTheme: .new(
                backButtonIconBuilder: (_) =>
                    const Icon(Icons.arrow_back_rounded),
              ),
            ),
            themeMode: ref.watch(themeModeProvider).value ?? .system,
            supportedLocales: const [Locale("en")],
            home: const WidgetTree(),
          );
        },
      );
    },
  );
}
