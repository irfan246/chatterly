import 'package:chatterly/routes/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCCskNUMbqTdjFN7YmzryGejXwQAas4ppQ",
      appId: "1:639950949156:android:005bd858a1b9645faa81b1",
      messagingSenderId: "639950949156",
      projectId: "chatterly-2fe7b",
      storageBucket: "chatterly-2fe7b.firebasestorage.app",
    ),
  );
  runApp(App());
}

class App extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 236, 236, 236),
        dividerTheme: const DividerThemeData(color: Colors.transparent),
      ),
      onGenerateRoute: _appRouter.generateRoute,
      initialRoute: '/loginOrRegister',
    );
  }
}
