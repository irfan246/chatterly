import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Chatterly',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
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
          child: Icon(
            Icons.add_comment,
            color: Colors.white,
            size: 20,
          ),
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
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
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
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
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
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children: [
            ListTile(
              title: Text(
                'Chat 1',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'This is chat 1',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              leading: CircleAvatar(
                child: Text('C1'),
              ),
              trailing: Icon(Icons.notifications_active),
              onTap: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
