import "package:chattes/ui/menu/providers/chats.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final selectedChatIdProvider = NotifierProvider.autoDispose(
  SelectedChatIdNotifier.new,
);

class SelectedChatIdNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void set(int? value) {
    state = value;
  }
}

final selectedChatProvider = Provider.autoDispose((ref) {
  final id = ref.watch(selectedChatIdProvider);
  if (id == null) return null;

  final chats = ref.watch(chatsProvider).value ?? [];

  return chats.firstWhere((chat) => chat.id == id);
});
