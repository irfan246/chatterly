import 'package:chatterly/application/chat/chat_bloc.dart';
import 'package:chatterly/application/search/search_bloc.dart';
import 'package:chatterly/application/search_animation/search_animation_bloc.dart';
import 'package:chatterly/infrastructure/firebase_service.dart';
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
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => ChatBloc(FirebaseService()),
                child: const HomeScreen(),
              ),
        );
      case '/loginOrRegister':
        return MaterialPageRoute(builder: (_) => const LoginOrRegister());
      case '/addChat':
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create:
                        (context) => SearchBloc(FirebaseService())..add(
                          LoadAllUsersEvent(FirebaseService().currentUser!.uid),
                        ),
                  ),
                  BlocProvider(create: (context) => SearchAnimationBloc()),
                ],
                child: AddChatScreen(),
              ),
        );
      case '/chat':
        final args = settings.arguments as Map<String, dynamic>;
        final chatId = args['chatId'] as String;
        final userName = args['userName'] as String;
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) =>
                        ChatBloc(FirebaseService())
                          ..add(LoadMessagesEvent(chatId)),
                child: ChatScreen(chatId: chatId, userName: userName),
              ),
        );
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: const Center(child: Text("Page not found!")),
          ),
    );
  }
}
