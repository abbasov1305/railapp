import 'package:flutter/material.dart';
import '../widgets/user_image_picker.dart';
import '../providers/base_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoggin = true;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  String? email;
  String? username;
  String? password;
  File? _pickedImage;

  void pickImg(File imgFile) {
    setState(() {
      _pickedImage = imgFile;
    });
  }

  void _submitData() async {
    FocusScope.of(context).unfocus();
    final validate = formKey.currentState!.validate();

    if (validate == null) return;
    try {
      setState(() {
        isLoading = true;
      });
      if (_isLoggin) {
        await Provider.of<BaseProvider>(context, listen: false)
            .signIn(email!, password!, context);
      } else {
        if (_pickedImage == null) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'upload image',
          style: TextStyle(color: Colors.white),
          
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));

          setState(() {
            isLoading = false;
          });
          return;
        }
        Provider.of<BaseProvider>(context, listen: false)
            .signUp(email!, password!, username!, _pickedImage!, context);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.blue, Color.fromARGB(255, 12, 53, 87)],
            center: Alignment.center,
            radius: 1,
            //end: Alignment.topCenter,
          ),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/1024.png'),
                maxRadius: 100,
              ),
              SizedBox(height: 20),
              Card(
                elevation: 10,
                margin: EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isLoggin ? 'LOOG IN' : 'CREATE A NEW ACCOUNT',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              //color: Theme.of(context).accentColor,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (!_isLoggin) UserImagePicker(pickImg),
                          TextFormField(
                            key: ValueKey('email'),
                            decoration:
                                InputDecoration(label: Text('email adress')),
                            onChanged: (value) => email = value,
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return 'please write a valid email adress';
                              }
                              return null;
                            },
                          ),
                          if (!_isLoggin)
                            TextFormField(
                              key: ValueKey('username'),
                              decoration:
                                  InputDecoration(label: Text('user name')),
                              onChanged: (value) => username = value,
                              validator: (value) {
                                if (value == null || value.trim().length < 4) {
                                  return 'please write at least 5 characters';
                                }
                                return null;
                              },
                            ),
                          TextFormField(
                            key: ValueKey('password'),
                            decoration:
                                InputDecoration(label: Text('password')),
                            obscureText: true,
                            onChanged: (value) => password = value,
                            validator: (value) {
                              if (value == null || value.trim().length < 5) {
                                return 'please write minimum 5 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (isLoading) CircularProgressIndicator(),
                          if (!isLoading)
                            ElevatedButton(
                                onPressed: _submitData,
                                child: _isLoggin
                                    ? Text('loog in')
                                    : Text('create a new account')),
                          if (!isLoading)
                            SizedBox(
                              height: 12,
                            ),
                          if (!isLoading)
                            OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoggin = !_isLoggin;
                                  });
                                },
                                child: _isLoggin
                                    ? Text('sign up')
                                    : Text('loog in')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
