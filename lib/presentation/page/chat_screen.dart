import 'package:chatterly/domain/message_model.dart';
import 'package:chatterly/infrastructure/firebase_service.dart';
import 'package:chatterly/presentation/widget/chat_bubble.dart';
import 'package:chatterly/presentation/widget/chat_input.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String userName;
  const ChatScreen({super.key, required this.chatId, required this.userName});

  @override
  Widget build(BuildContext context) {
    final _currentUserId = FirebaseService().currentUser!.uid;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 80,
          flexibleSpace: SizedBox(
            height: 80,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 29, 29, 29),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FutureBuilder<String>(
                      future: FirebaseService().getOtherUserName(
                        chatId,
                        _currentUserId,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        } else if (snapshot.hasError) {
                          return const Text(
                            'Error',
                            style: TextStyle(color: Colors.white),
                          );
                        } else {
                          // final otherUserName = snapshot.data ?? 'Unknown';
                          return Row(
                            children: [
                              CircleAvatar(child: Text('C1')),
                              SizedBox(width: 15),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$userName',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Online',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.call, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: StreamBuilder<List<MessageModel>>(
          stream: FirebaseService().getMessages(chatId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final messages = snapshot.data!;
              return Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ChatBubble(
                          message: message.text,
                          isMe: message.senderId == _currentUserId,
                        );
                      },
                    ),
                  ),
                  ChatInput(chatId: chatId),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
