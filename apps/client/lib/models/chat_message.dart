class ChatMessage {
  final String id;
  final String senderId;
  final String? senderName;
  final String content;
  final DateTime timestamp;
  final String? roomId;

  ChatMessage({
    required this.id,
    required this.senderId,
    this.senderName,
    required this.content,
    required this.timestamp,
    this.roomId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      roomId: json['roomId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'roomId': roomId,
    };
  }
}
