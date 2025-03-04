part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String senderId;
  final String text;

  const SendMessageEvent({
    required this.chatId,
    required this.senderId,
    required this.text,
  });

  @override
  List<Object> get props => [chatId, senderId, text];
}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;

  const LoadMessagesEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}
