import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/chat_message.dart';
import '../../repositories/chat/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  StreamSubscription? _messagesSubscription;
  StreamSubscription? _typingSubscription;

  ChatBloc({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(const ChatState()) {
    on<ChatRoomJoined>(_onRoomJoined);
    on<ChatRoomLeft>(_onRoomLeft);
    on<ChatMessageReceived>(_onMessageReceived);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatHistoryRequested>(_onHistoryRequested);
    on<ChatTypingStarted>(_onTypingStarted);
    on<ChatTypingStopped>(_onTypingStopped);
    on<ChatTypingStatusReceived>(_onTypingStatusReceived);
    on<ChatRoomCreated>(_onRoomCreated);

    _messagesSubscription = _chatRepository.messages.listen(
      (message) => add(ChatMessageReceived(message)),
    );

    _typingSubscription = _chatRepository.typingStatus.listen(
      (status) => add(ChatTypingStatusReceived(status)),
    );
  }

  Future<void> _onRoomJoined(
    ChatRoomJoined event,
    Emitter<ChatState> emit,
  ) async {
    if (state.currentRoomId == event.roomId) {
      return;
    }

    emit(
      state.copyWith(status: ChatStatus.loading, currentRoomId: event.roomId),
    );

    try {
      await _chatRepository.joinRoom(event.roomId);

      add(ChatHistoryRequested(event.roomId));

      emit(state.copyWith(status: ChatStatus.active, error: null));
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: 'Failed to join room: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onRoomLeft(ChatRoomLeft event, Emitter<ChatState> emit) async {
    if (state.currentRoomId == null) {
      return;
    }

    try {
      await _chatRepository.leaveRoom(state.currentRoomId!);

      emit(
        state.copyWith(
          status: ChatStatus.inactive,
          currentRoomId: null,
          messages: const [],
          typingUsers: const {},
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: 'Failed to leave room: ${e.toString()}',
        ),
      );
    }
  }

  void _onMessageReceived(ChatMessageReceived event, Emitter<ChatState> emit) {
    if (state.currentRoomId != event.message.roomId) {
      return;
    }

    final typingUsers = Map<String, DateTime>.from(state.typingUsers);
    typingUsers.remove(event.message.senderId);

    final messages = [event.message, ...state.messages];

    emit(state.copyWith(messages: messages, typingUsers: typingUsers));
  }

  Future<void> _onMessageSent(
    ChatMessageSent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.currentRoomId == null || event.message.isEmpty) {
      return;
    }

    try {
      await _chatRepository.sendMessage(event.message, state.currentRoomId!);
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: 'Failed to send message: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onHistoryRequested(
    ChatHistoryRequested event,
    Emitter<ChatState> emit,
  ) async {
    if (state.currentRoomId == null) {
      return;
    }

    emit(state.copyWith(status: ChatStatus.loading));

    try {
      final history = await _chatRepository.getChatHistory(
        event.roomId,
        event.limit,
      );

      emit(
        state.copyWith(
          status: ChatStatus.active,
          messages: history,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: 'Failed to load chat history: ${e.toString()}',
        ),
      );
    }
  }

  void _onTypingStarted(ChatTypingStarted event, Emitter<ChatState> emit) {
    if (state.currentRoomId == null) {
      return;
    }

    _chatRepository.sendTypingIndicator(state.currentRoomId!, true);
  }

  void _onTypingStopped(ChatTypingStopped event, Emitter<ChatState> emit) {
    if (state.currentRoomId == null) {
      return;
    }

    _chatRepository.sendTypingIndicator(state.currentRoomId!, false);
  }

  void _onTypingStatusReceived(
    ChatTypingStatusReceived event,
    Emitter<ChatState> emit,
  ) {
    if (state.currentRoomId != event.status['roomId']) {
      return;
    }

    final userId = event.status['userId'];
    final isTyping = event.status['isTyping'] as bool;

    final typingUsers = Map<String, DateTime>.from(state.typingUsers);

    if (isTyping) {
      typingUsers[userId] = DateTime.now();
    } else {
      typingUsers.remove(userId);
    }

    emit(state.copyWith(typingUsers: typingUsers));
  }

  Future<void> _onRoomCreated(
    ChatRoomCreated event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final roomId = await _chatRepository.createRoom(
        event.name,
        event.description,
        event.type,
      );

      add(ChatRoomJoined(roomId));
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: 'Failed to create room: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _typingSubscription?.cancel();
    return super.close();
  }
}
