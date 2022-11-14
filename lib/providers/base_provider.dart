import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rail_app/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class BaseProvider with ChangeNotifier {
  bool bIsDark = false;
  BaseProvider(this.bIsDark);

  Future<void> signIn(String email, String password, BuildContext ctx) async {
    try {
      final authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _saveLooginData(email, password);
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
    File _userImage,
    BuildContext ctx,
  ) async {
    try {
      final authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (authResult == null) return print('auth result is null');

      final ref = await FirebaseStorage.instance
          .ref()
          .child('usere_images')
          .child(authResult.user!.uid + '.jpg');
      await ref.putFile(_userImage);
      String imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set({
        'uid': authResult.user!.uid,
        'email': email,
        'username': username,
        'imageUrl': imageUrl,
      });

      _saveLooginData(email, password);
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
    _deleteLooginData();
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
    bIsDark = !bIsDark;
    _saveThemeData();
    //notifyListeners();
  }

  ThemeMode getCurrentTheme() {
    return bIsDark ? ThemeMode.dark : ThemeMode.light;
  }

  void _saveThemeData() async {
    await SharedPreferences.getInstance()
        .then((value) => value.setBool('bIsDark', bIsDark));
    notifyListeners();
  }

  void _saveLooginData(String email, String password) async {
    await SharedPreferences.getInstance()
        .then((value) => value.setStringList('loogin', [email, password]));
  }

  void _deleteLooginData() async {
    await SharedPreferences.getInstance()
        .then((value) => value.getStringList('loogin')!.clear());
  }
}
