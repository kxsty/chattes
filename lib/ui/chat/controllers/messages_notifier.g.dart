// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Messages)
final messagesProvider = MessagesProvider._();

final class MessagesProvider
    extends $AsyncNotifierProvider<Messages, MessagesState?> {
  MessagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messagesHash();

  @$internal
  @override
  Messages create() => Messages();
}

String _$messagesHash() => r'eded23295006ccbbc20affde0b8a849bc8e43a3b';

abstract class _$Messages extends $AsyncNotifier<MessagesState?> {
  FutureOr<MessagesState?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MessagesState?>, MessagesState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MessagesState?>, MessagesState?>,
              AsyncValue<MessagesState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(draft)
final draftProvider = DraftFamily._();

final class DraftProvider
    extends $FunctionalProvider<MessageDraft, MessageDraft, MessageDraft>
    with $Provider<MessageDraft> {
  DraftProvider._({
    required DraftFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'draftProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$draftHash();

  @override
  String toString() {
    return r'draftProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MessageDraft> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MessageDraft create(Ref ref) {
    final argument = this.argument as int;
    return draft(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessageDraft value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessageDraft>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DraftProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$draftHash() => r'be7ed910ea13de99cf7577cfe5ff5eed1f4f419e';

final class DraftFamily extends $Family
    with $FunctionalFamilyOverride<MessageDraft, int> {
  DraftFamily._()
    : super(
        retry: null,
        name: r'draftProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DraftProvider call(int chatId) =>
      DraftProvider._(argument: chatId, from: this);

  @override
  String toString() => r'draftProvider';
}
