import "package:riverpod_annotation/riverpod_annotation.dart";

part "response_notifier.g.dart";

@riverpod
class Layout extends _$Layout {
  @override
  bool build() => false;

  void setIsPhone(bool isPhone) {
    state = isPhone;
  }
}
