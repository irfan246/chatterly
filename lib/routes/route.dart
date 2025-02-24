import 'package:chatterly/application/auth/auth_bloc.dart';
import 'package:chatterly/application/search_animation/search_animation_bloc.dart';
import 'package:chatterly/presentation/page/add_chat_screen.dart';
import 'package:chatterly/presentation/page/chat_screen.dart';
import 'package:chatterly/presentation/page/home_screen.dart';
import 'package:chatterly/presentation/page/login_or_register.dart';
import 'package:chatterly/presentation/page/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/loginOrRegister':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AuthBloc(),
                  child: const LoginOrRegister(),
                ));
      case '/addChat':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => SearchAnimationBloc(),
                  child: const AddChatScreen(),
                ));
      case '/chat':
        return MaterialPageRoute(builder: (_) => const ChatScreen());
      case '/settings':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AuthBloc(),
                  child: const SettingsScreen(),
                ));
      default:
        return _errorRoute();
    }
  }


  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Page not found!")),
      ),
    );
  }
}
