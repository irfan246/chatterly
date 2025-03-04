import 'package:chatterly/domain/chat_model.dart';
import 'package:chatterly/infrastructure/firebase_service.dart';
import 'package:chatterly/presentation/widget/show_dialog_delet_chat.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _currentUserId = FirebaseService().currentUser!.uid;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Chatterly',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addChat');
          },
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            backgroundColor: Color.fromARGB(255, 29, 29, 29),
            padding: EdgeInsets.all(20),
          ),
          child: Icon(Icons.add_comment, color: Colors.white, size: 20),
        ),
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 29, 29, 29),
          child: ListView(
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    'C H A T T E R L Y',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
            ],
          ),
        ),
        body: StreamBuilder<List<ChatModel>>(
          stream: FirebaseService().getChats(_currentUserId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No chats found.'));
            } else {
              final chats = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final otherUserId = chat.participants.firstWhere(
                    (id) => id != _currentUserId,
                  );
                  return FutureBuilder(
                    future: FirebaseService().getUserName(otherUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        final otherUserName = snapshot.data ?? 'Unknown';
                        return ListTile(
                          title: Text(
                            otherUserName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            chat.lastMessage,
                            style: TextStyle(fontSize: 12),
                          ),
                          leading: CircleAvatar(child: Text('C1')),
                          trailing: Icon(Icons.notifications_active),
                          onLongPress: () {
                            _showDialogDeleteChat(context, chat.chatId);
                          },
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/chat',
                              arguments: {
                                'chatId': chat.chatId,
                                'userName': otherUserName,
                              },
                            );
                          },
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _showDialogDeleteChat(BuildContext context, String chatId) {
    showDialog(
      context: context,
      builder: (context) {
        return ShowDialogDeletChat(chatId: chatId);
      },
    );
  }
}
