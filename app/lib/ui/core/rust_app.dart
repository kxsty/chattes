import "package:chattes/core/app/app.dart";
import "package:chattes/core/app/chats.dart";
import "package:chattes/core/app/messages.dart";

class Api {
  Api._internal();

  static final Api _instance = Api._internal();

  factory Api() => _instance;

  late final App _app;

  Future<void> initialize() async {
    _app = await App.newInstance();
  }

  Chats get chats => _app.chats;
  Messages get messages => _app.messages;
}
