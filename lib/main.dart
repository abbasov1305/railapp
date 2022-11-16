import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rail_app/providers/base_provider.dart';
import 'firebase_options.dart';
import './screens/main_screen.dart';
import './screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences pref = await SharedPreferences.getInstance();
  bool bIsDark = false;

  if (pref != null) {
    if (pref.getBool('bIsDark') != null) {
      bIsDark = pref.getBool('bIsDark')!;
    }
  }

  runApp(MyApp(bIsDark != null ? bIsDark : false));
}

List<String>? newLooginData;
Future<void> getLooginData() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref != null) {
    if (pref.getStringList('loogin') != null) {
      newLooginData = pref.getStringList('loogin');
    }
    newLooginData = null;
  }

  newLooginData = null;
}

class MyApp extends StatelessWidget {
  bool bIsDark;

  MyApp(this.bIsDark);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BaseProvider(bIsDark),
      builder: (context, child) => MaterialApp(
        title: 'rail app',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.blue[900],
          colorScheme: ColorScheme.light().copyWith(
            primary: Colors.blue[600],
          ),
          fontFamily: 'R4',
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color.fromARGB(255, 18, 28, 37),
          canvasColor: Color.fromARGB(255, 14, 22, 29),
          primaryColor: Colors.blue[900],
          accentColor: Color.fromARGB(255, 1, 42, 105),
          textTheme: ThemeData.dark().textTheme.apply(
                fontFamily: 'R4',
              ),
        ),
        themeMode: Provider.of<BaseProvider>(context).getCurrentTheme(),
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
            getLooginData();
            if (newLooginData != null) {
              Provider.of<BaseProvider>(context)
                  .signIn(newLooginData![0], newLooginData![1], context);
            }
            return AuthScreen();
          },
        ),
      ),
    );
  }
}
