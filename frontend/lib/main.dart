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

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => ProviderScope(
    child: DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.copyWith(
            outlineVariant: HSLColor.fromColor(
              lightDynamic.outlineVariant,
            ).withLightness(0.8).toColor(),
          );

          darkColorScheme = darkDynamic.copyWith(
            outlineVariant: HSLColor.fromColor(
              darkDynamic.outlineVariant,
            ).withLightness(0.2).toColor(),
          );
        } else {
          lightColorScheme = .light();
          darkColorScheme = .dark();
        }

        return Consumer(
          builder: (context, ref, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Chattes",
              theme: .from(
                colorScheme: lightColorScheme,
              ).copyWith(highlightColor: kColorTransparent),
              darkTheme: .from(
                colorScheme: darkColorScheme,
              ).copyWith(highlightColor: kColorTransparent),
              themeMode: ref.watch(themeModeProvider),
              supportedLocales: const [Locale("en")],
              home: const WidgetTree(),
            );
          },
        );
      },
    ),
  );
}
