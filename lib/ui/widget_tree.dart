import "package:chattes/ui/chat/widgets/chat_screen.dart";
import "package:chattes/ui/menu/providers/chats.dart";
import "package:chattes/ui/menu/widgets/menu_divider.dart";
import "package:chattes/ui/menu/widgets/menu_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(
      (value) => {_menuDividerWidth = _menuDividerWidth},
    );
  }

  double _menuDividerWidth = 300.0;

  final double _menuDividerMinWidth = 300.0;
  final double _menuDividerMaxWidth = 500.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_isPhone(constraints)) {
          return Consumer(
            builder: (context, ref, child) {
              return Navigator(
                pages: [
                  MaterialPage(child: MenuScreen()),
                  if (ref.watch(selectedChatIdProvider) != null)
                    MaterialPage(child: ChatScreen()),
                ],
                onDidRemovePage: (_) =>
                    ref.read(selectedChatIdProvider.notifier).selectChat(null),
              );
            },
          );
        } else {
          return Row(
            children: [
              SizedBox(width: _menuDividerWidth, child: MenuScreen()),
              MenuDivider(onHorizontalOffestUpdate: _onDividerDrag),
              Expanded(child: ChatScreen()),
            ],
          );
        }
      },
    );
  }

  void _onDividerDrag(double offset) {
    setState(() {
      _menuDividerWidth = offset.clamp(
        _menuDividerMinWidth,
        _menuDividerMaxWidth,
      );
    });
  }

  bool _isPhone(BoxConstraints constraints) {
    return constraints.maxWidth < 768;
  }
}
