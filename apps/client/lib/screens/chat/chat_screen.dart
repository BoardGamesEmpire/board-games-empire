import 'package:flutter/material.dart';
import '../../di/injection.dart';
import '../../models/chat_message.dart';
import '../../services/chat/chat_service.dart';
import '../../services/websocket/websocket_manager.dart';
import '../../services/auth/auth_service.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = getIt<ChatService>();
  final WebSocketManager _websocketManager = getIt<WebSocketManager>();
  final AuthService _authService = getIt<AuthService>();

  final TextEditingController _messageController = TextEditingController();
  final String _roomId = 'general';

  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isTyping = false;

  final Map<String, DateTime> _typingUsers = {};

  @override
  void initState() {
    super.initState();
    _loadChatHistory();

    _chatService.messageStream.listen((message) {
      if (message.roomId == _roomId && mounted) {
        setState(() {
          _typingUsers.remove(message.senderId);
          _messages.insert(0, message);
        });
      }
    });

    _chatService.typingStream.listen((data) {
      if (data['roomId'] == _roomId && mounted) {
        final userId = data['userId'];
        final isTyping = data['isTyping'] as bool;

        setState(() {
          if (isTyping) {
            _typingUsers[userId] = DateTime.now();
          } else {
            _typingUsers.remove(userId);
          }
        });
      }
    });

    _chatService.joinRoom(_roomId).catchError((e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join chat: ${e.toString()}')),
        );
      }
    });

    _startTypingCleanupTimer();
  }

  void _startTypingCleanupTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;

      final now = DateTime.now();
      bool changed = false;

      _typingUsers.removeWhere((userId, timestamp) {
        final isExpired = now.difference(timestamp).inSeconds > 5;

        if (isExpired) {
          changed = true;
        }

        return isExpired;
      });

      if (changed) {
        setState(() {});
      }

      _startTypingCleanupTimer();
    });
  }

  Future<void> _loadChatHistory() async {
    try {
      final history = await _chatService.getChatHistory(_roomId);
      if (mounted) {
        setState(() {
          _messages = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load chat history: ${e.toString()}'),
          ),
        );
      }
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final userId = _authService.currentUser?.id ?? 'unknown';
    final userName = _authService.currentUser?.username ?? 'Anonymous';

    final optimisticMessage = ChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: userId,
      senderName: userName,
      content: text,
      timestamp: DateTime.now(),
      roomId: _roomId,
    );

    setState(() {
      _messages.insert(0, optimisticMessage);
      _isTyping = false;
    });

    _messageController.clear();

    _chatService.sendMessage(text, roomId: _roomId).catchError((e) {
      if (mounted) {
        setState(() {
          _messages.removeWhere((m) => m.id == optimisticMessage.id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: ${e.toString()}')),
        );
      }
    });

    _chatService.sendTypingIndicator(_roomId, false);
  }

  void _handleTypingIndicator(String text) {
    final isCurrentlyTyping = text.isNotEmpty;

    if (isCurrentlyTyping != _isTyping) {
      _isTyping = isCurrentlyTyping;
      _chatService.sendTypingIndicator(_roomId, isCurrentlyTyping);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat: $_roomId'),
        actions: [
          // WebSocket status indicator
          StreamBuilder<bool>(
            stream: _websocketManager.statusStream,
            initialData: _websocketManager.isConnected,
            builder: (context, snapshot) {
              final isConnected = snapshot.data ?? false;
              return Tooltip(
                message:
                    isConnected
                        ? 'Live chat via WebSocket'
                        : 'Limited functionality via REST',
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isConnected ? Icons.bolt : Icons.sync,
                    color: isConnected ? Colors.green : Colors.orange,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh chat history',
            onPressed: _loadChatHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_typingUsers.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.grey.shade200,
              width: double.infinity,
              child: Text(
                _getTypingText(),
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),

          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _messages.isEmpty
                    ? const Center(child: Text('No messages yet'))
                    : ListView.builder(
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isFromCurrentUser =
                            message.senderId ==
                            (_authService.currentUser?.id ?? '');

                        return _ChatBubble(
                          message: message,
                          isFromCurrentUser: isFromCurrentUser,
                        );
                      },
                    ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
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
                    onChanged: _handleTypingIndicator,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                StreamBuilder<bool>(
                  stream: _websocketManager.statusStream,
                  initialData: _websocketManager.isConnected,
                  builder: (context, snapshot) {
                    final isConnected = snapshot.data ?? false;

                    return IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                      color: isConnected ? Colors.blue : Colors.grey,
                      tooltip:
                          isConnected
                              ? 'Send message via WebSocket'
                              : 'Send message via REST',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTypingText() {
    if (_typingUsers.isEmpty) {
      return '';
    } else if (_typingUsers.length == 1) {
      return 'Someone is typing...';
    } else {
      return '${_typingUsers.length} people are typing...';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatService.leaveRoom(_roomId).catchError((e) {
      print('Failed to leave room: $e');
    });

    super.dispose();
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isFromCurrentUser;

  const _ChatBubble({required this.message, required this.isFromCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isFromCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromCurrentUser)
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: Text(
                message.senderName?.isNotEmpty == true
                    ? message.senderName![0].toUpperCase()
                    : '?',
              ),
            ),

          const SizedBox(width: 8),

          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isFromCurrentUser
                        ? Colors.blue.shade100
                        : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isFromCurrentUser)
                    Text(
                      message.senderName ?? 'Anonymous',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                  Text(message.content),

                  Text(
                    _formatTime(message.timestamp),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),

          if (isFromCurrentUser) const SizedBox(width: 8),

          if (isFromCurrentUser)
            CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              child: Text(
                message.senderName?.isNotEmpty == true
                    ? message.senderName![0].toUpperCase()
                    : '?',
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return 'Today ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Yesterday ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.day}/${time.month}/${time.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
