import 'package:chatterly/infrastructure/firebase_service.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final String chatId;
  final TextEditingController _controller = TextEditingController();
  ChatInput({super.key, required this.chatId});
  @override
  Widget build(BuildContext context) {
    final _currentUserId = FirebaseService().currentUser!.uid;
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Color.fromARGB(255, 29, 29, 29),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () async {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  await FirebaseService().sendMessage(
                    chatId,
                    _currentUserId,
                    text,
                  );
                  _controller.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
