part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatRoomJoined extends ChatEvent {
  const ChatRoomJoined(this.roomId);

  final String roomId;

  @override
  List<Object> get props => [roomId];
}

class ChatRoomLeft extends ChatEvent {
  const ChatRoomLeft();
}

class ChatMessageReceived extends ChatEvent {
  const ChatMessageReceived(this.message);

  final ChatMessage message;

  @override
  List<Object> get props => [message];
}

class ChatMessageSent extends ChatEvent {
  const ChatMessageSent(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class ChatHistoryRequested extends ChatEvent {
  const ChatHistoryRequested(this.roomId, [this.limit = 50]);

  final String roomId;
  final int limit;

  @override
  List<Object> get props => [roomId, limit];
}

class ChatTypingStarted extends ChatEvent {
  const ChatTypingStarted();
}

class ChatTypingStopped extends ChatEvent {
  const ChatTypingStopped();
}

class ChatTypingStatusReceived extends ChatEvent {
  const ChatTypingStatusReceived(this.status);

  final Map<String, dynamic> status;

  @override
  List<Object> get props => [status];
}

class ChatRoomCreated extends ChatEvent {
  const ChatRoomCreated({
    required this.name,
    this.description,
    this.type = 'Public',
  });

  final String name;
  final String? description;
  final String type;

  @override
  List<Object?> get props => [name, description, type];
}
