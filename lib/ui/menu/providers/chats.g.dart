// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Chats)
final chatsProvider = ChatsProvider._();

final class ChatsProvider extends $AsyncNotifierProvider<Chats, List<Chat>> {
  ChatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatsHash();

  @$internal
  @override
  Chats create() => Chats();
}

String _$chatsHash() => r'ed07dc3ca1e892d282f7f44346ed67b0d4f93653';

abstract class _$Chats extends $AsyncNotifier<List<Chat>> {
  FutureOr<List<Chat>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Chat>>, List<Chat>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Chat>>, List<Chat>>,
              AsyncValue<List<Chat>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedChatId)
final selectedChatIdProvider = SelectedChatIdProvider._();

final class SelectedChatIdProvider
    extends $NotifierProvider<SelectedChatId, int?> {
  SelectedChatIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedChatIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedChatIdHash();

  @$internal
  @override
  SelectedChatId create() => SelectedChatId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$selectedChatIdHash() => r'cd35ebbb08c589cc5a9f6a5814c64adc1fa57b5a';

abstract class _$SelectedChatId extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(selectedChat)
final selectedChatProvider = SelectedChatProvider._();

final class SelectedChatProvider
    extends $FunctionalProvider<Chat?, Chat?, Chat?>
    with $Provider<Chat?> {
  SelectedChatProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedChatProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedChatHash();

  @$internal
  @override
  $ProviderElement<Chat?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Chat? create(Ref ref) {
    return selectedChat(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Chat? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Chat?>(value),
    );
  }
}

String _$selectedChatHash() => r'75c7eb7a1ab44521e217bc08147122f6876f768f';
