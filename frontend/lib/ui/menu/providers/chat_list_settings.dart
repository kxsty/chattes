import "dart:convert";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

final chatListSettingsProvider = AsyncNotifierProvider.autoDispose(
  ChatListSettingsNotifier.new,
);

class ChatListSettingsNotifier extends AsyncNotifier<ChatListSettings> {
  static const key = "chat_list_settings";

  @override
  Future<ChatListSettings> build() async {
    final instance = await SharedPreferences.getInstance();
    final json = instance.getString(key);
    if (json == null) {
      return .new();
    }

    return .fromJson(jsonDecode(json));
  }

  Future<void> setReverse(bool reverse) async {
    final oldValue = state.value;

    final ChatListSettings value = oldValue == null
        ? .new(alignBottom: reverse)
        : oldValue.copyWith(alignBottom: reverse);

    final json = jsonEncode(value.toJson());
    final instance = await SharedPreferences.getInstance();
    instance.setString(key, json);

    state = AsyncData(value);
  }
}

class ChatListSettings {
  ChatListSettings({this.alignBottom = false});

  final bool alignBottom;

  ChatListSettings.fromJson(Map<String, dynamic> json)
    : alignBottom = json["alignBottom"] as bool;

  Map<String, dynamic> toJson() {
    return {"alignBottom": alignBottom};
  }

  ChatListSettings copyWith({bool? alignBottom}) {
    return .new(alignBottom: alignBottom ?? this.alignBottom);
  }
}
