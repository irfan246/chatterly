class ChatModel {
  final String chatId;
  final List<String> participants;
  final DateTime createdAt;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatModel({
    required this.chatId,
    required this.participants,
    required this.createdAt,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    return ChatModel(
      chatId: data['chatId'],
      participants: List<String>.from(data['participants']),
      createdAt: data['createdAt'].toDate(),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'participants': participants,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }
}
