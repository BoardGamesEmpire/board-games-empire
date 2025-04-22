import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../models/chat_message.dart';
import '../../models/user.dart';
import '../../widgets/chat/chat_bubble.dart';
import '../../widgets/chat/typing_indicator.dart';

class ChatScreenBloc extends StatefulWidget {
  final String roomId;

  const ChatScreenBloc({super.key, this.roomId = 'general'});

  @override
  State<ChatScreenBloc> createState() => _ChatScreenBlocState();
}

class _ChatScreenBlocState extends State<ChatScreenBloc> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_handleTypingDetection);

    // Join room on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatBloc>().add(ChatRoomJoined(widget.roomId));
    });
  }

  void _handleTypingDetection() {
    final text = _messageController.text;
    final wasTyping = _isTyping;
    final isCurrentlyTyping = text.isNotEmpty;

    if (wasTyping != isCurrentlyTyping) {
      _isTyping = isCurrentlyTyping;

      if (isCurrentlyTyping) {
        context.read<ChatBloc>().add(const ChatTypingStarted());
        _startTypingTimer();
      } else {
        context.read<ChatBloc>().add(const ChatTypingStopped());
        _typingTimer?.cancel();
      }
    }
  }

  void _startTypingTimer() {
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 5), () {
      if (_isTyping && mounted) {
        _isTyping = false;
        context.read<ChatBloc>().add(const ChatTypingStopped());
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(ChatMessageSent(text));
    _messageController.clear();
  }

  void _refreshChat() {
    final currentRoomId = context.read<ChatBloc>().state.currentRoomId;
    if (currentRoomId != null) {
      context.read<ChatBloc>().add(ChatHistoryRequested(currentRoomId));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();

    // Leave room on dispose
    context.read<ChatBloc>().add(const ChatRoomLeft());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ChatBloc, ChatState>(
          buildWhen:
              (previous, current) =>
                  previous.currentRoomId != current.currentRoomId,
          builder: (context, state) {
            return Text('Chat: ${state.currentRoomId ?? 'No Room'}');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh chat history',
            onPressed: _refreshChat,
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listenWhen:
            (previous, current) =>
                previous.hasError != current.hasError && current.hasError,
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Typing indicator
              if (state.hasTypingUsers)
                TypingIndicator(text: state.getTypingText()),

              // Messages list
              Expanded(
                child:
                    state.hasMessages
                        ? _buildMessageList(state.messages)
                        : const Center(child: Text('No messages yet')),
              ),

              // Message input
              _buildMessageInput(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages) {
    final User? currentUser = context.select<AuthBloc, User?>(
      (bloc) => bloc.state.user,
    );

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      itemCount: messages.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemBuilder: (context, index) {
        final message = messages[index];
        return ChatBubble(
          message: message,
          isFromCurrentUser: message.senderId == currentUser?.id,
        );
      },
    );
  }

  Widget _buildMessageInput(ChatState state) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
