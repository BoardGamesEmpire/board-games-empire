part of 'chat_bloc.dart';

enum ChatStatus { inactive, loading, active, error }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.inactive,
    this.currentRoomId,
    this.messages = const [],
    this.typingUsers = const {},
    this.error,
  });

  final ChatStatus status;
  final String? currentRoomId;
  final List<ChatMessage> messages;
  final Map<String, DateTime> typingUsers;
  final String? error;

  bool get isLoading => status == ChatStatus.loading;
  bool get isActive => status == ChatStatus.active;
  bool get hasError => status == ChatStatus.error;
  bool get isInRoom => currentRoomId != null;
  bool get hasMessages => messages.isNotEmpty;
  bool get hasTypingUsers => typingUsers.isNotEmpty;

  String getTypingText() {
    if (!hasTypingUsers) {
      return '';
    } else if (typingUsers.length == 1) {
      return 'Someone is typing...';
    } else {
      return '${typingUsers.length} people are typing...';
    }
  }

  ChatState copyWith({
    ChatStatus? status,
    String? currentRoomId,
    List<ChatMessage>? messages,
    Map<String, DateTime>? typingUsers,
    String? error,
  }) {
    return ChatState(
      status: status ?? this.status,
      currentRoomId: currentRoomId ?? this.currentRoomId,
      messages: messages ?? this.messages,
      typingUsers: typingUsers ?? this.typingUsers,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentRoomId,
    messages,
    typingUsers,
    error,
  ];
}
