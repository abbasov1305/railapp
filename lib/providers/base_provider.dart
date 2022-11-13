import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rail_app/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseProvider with ChangeNotifier {
  bool _bIsDark = false;

  Future<void> signIn(String email, String password, BuildContext ctx) async {
    try {
      final authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      throw (e);
    }
    notifyListeners();
  }

  Future<void> signUp(
    String email,
    String password,
    String username,
    String imageUrl,
    BuildContext ctx,
  ) async {
    try {
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (authResult == null) return print('auth result is null');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'uid': authResult.user!.uid,
        'email': email,
        'username': username,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      throw (e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> addText(String text, BuildContext ctx) async {
    final _uid = await FirebaseAuth.instance.currentUser!.uid;
    try {
      await FirebaseFirestore.instance.collection('texts').add({
        'uid': _uid,
        'text': text,
        'createdAt': Timestamp.now(),
        'likes': 0,
        'dislikes': 0,
        'reactedUsers': [],
      });

      Navigator.of(ctx).push(MaterialPageRoute(
        builder: (context) => MainScreen(),
      ));
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      throw (e);
    }

    notifyListeners();
  }

  void switchTheme() {
    _bIsDark = !_bIsDark;
    _saveData();
    notifyListeners();
  }

  ThemeMode getCurrentTheme() {
    return _bIsDark ? ThemeMode.dark : ThemeMode.light;
  }

  void _saveData() async {
    await SharedPreferences.getInstance()
        .then((value) => value.setBool('bIsDark', _bIsDark));
  }

  void loadData() async {
    await SharedPreferences.getInstance().then((value) {
      if (value.getBool('bIsDark') != null) {
        _bIsDark = value.getBool('bIsDark')!;
      }
    });
  }
}
