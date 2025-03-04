class MessageModel {
  final String messageId;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      messageId: data['messageId'],
      chatId: data['chatId'],
      senderId: data['senderId'],
      text: data['text'],
      timestamp: data['timestamp'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
