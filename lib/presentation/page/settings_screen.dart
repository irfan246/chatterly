import 'package:chatterly/application/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is AuthSuccess) {
                return ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundColor: const Color.fromARGB(
                          255,
                          104,
                          172,
                          228,
                        ),
                        maxRadius: 100,
                        child: Text(
                          'c1',
                          style: TextStyle(fontSize: 50, color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        state.user.name,
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {},
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      leading: Icon(Icons.description),
                      title: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Hi! ', style: TextStyle(fontSize: 14)),
                      onTap: () {},
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        state.user.email,
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {},
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        context.read<AuthBloc>().add(SignOutEvent());
                      },
                    ),
                  ],
                );
              } else {
                return Text('Loading...');
              }
            },
          ),
        ),
      ),
    );
  }
}
