import 'package:chatterly/domain/message_model.dart';
import 'package:chatterly/infrastructure/firebase_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseService _firebaseService;

  ChatBloc(this._firebaseService) : super(ChatInitial()) {
    on<SendMessageEvent>((event, emit) async {
      await _firebaseService.sendMessage(
        event.chatId,
        event.senderId,
        event.text,
      );
    });

    on<LoadMessagesEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        final messages = await _firebaseService.getMessages(event.chatId).first;
        emit(ChatSuccess(messages));
      } catch (e) {
        emit(ChatFailure(e.toString()));
      }
    });
  }
}
