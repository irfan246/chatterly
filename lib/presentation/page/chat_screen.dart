import 'package:chatterly/presentation/widget/chat_bubble.dart';
import 'package:chatterly/presentation/widget/chat_input.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          child: Text('C1'),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                'User 1',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Online',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  return ChatBubble(
                    message: 'Hello, this is a message $index',
                    isMe: index % 2 == 0,
                  );
                },
              ),
            ),
            ChatInput(),
          ],
        ),
      ),
    );
  }
}
