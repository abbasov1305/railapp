import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rail_app/providers/base_provider.dart';
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
      create: (context) => BaseProvider(),
      builder: (context, child) => MaterialApp(
        title: 'rail app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.blue[900],
          //scaffoldBackgroundColor: Colors.lightBlue,
          colorScheme: ColorScheme.light().copyWith(
            primary: Colors.lightBlue[900],
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color.fromARGB(255, 18, 28, 37),
          canvasColor: Color.fromARGB(255, 14, 22, 29),
          primaryColor: Colors.blue[900],
          accentColor: Color.fromARGB(255, 1, 42, 105),
        ),
        themeMode: BaseProvider().getCurrentTheme(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              BaseProvider().loadData();
              return MainScreen();
            }
            return AuthScreen();
          },
        ),
      ),
    );
  }
}
