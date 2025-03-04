import 'package:chatterly/application/auth/auth_bloc.dart';
import 'package:chatterly/application/chat/chat_bloc.dart';
import 'package:chatterly/infrastructure/firebase_options.dart';
import 'package:chatterly/infrastructure/firebase_service.dart';
import 'package:chatterly/presentation/page/home_screen.dart';
import 'package:chatterly/presentation/page/login_or_register.dart';
import 'package:chatterly/routes/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(App());
}

class App extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        Provider<FirebaseService>(create: (_) => FirebaseService()),
        BlocProvider(
          create:
              (context) =>
                  AuthBloc(context.read<FirebaseService>())
                    ..add(AutoLoginEvent()),
        ),
        BlocProvider(
          create: (context) => ChatBloc(context.read<FirebaseService>()),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 236, 236, 236),
          dividerTheme: const DividerThemeData(color: Colors.transparent),
        ),
        onGenerateRoute: _appRouter.generateRoute,
        initialRoute: '/',
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return HomeScreen();
            } else {
              return LoginOrRegister();
            }
          },
        ),
      ),
    );
  }
}
