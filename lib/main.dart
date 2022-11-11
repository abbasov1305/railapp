import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rail_app/providers/auth_provider.dart';
import 'firebase_options.dart';
import './screens/main_screen.dart';
import './screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      builder: (context, child) => MaterialApp(
        title: 'rail app',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData(
          accentColor: Colors.blue[900],
          //scaffoldBackgroundColor: Colors.lightBlue,
          colorScheme: ColorScheme.light().copyWith(
            primary: Colors.lightBlue[900],
          ),
        ),
        darkTheme: ThemeData(
          // colorScheme: ColorScheme.light().copyWith(
          //   primary: Color.fromARGB(255, 0, 21, 37),
          // ),
          colorScheme: ColorScheme.dark(),
          // scaffoldBackgroundColor: Color.fromARGB(255, 1, 39, 68),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return MainScreen();
            }
            return AuthScreen();
          },
        ),
      ),
    );
  }
}
