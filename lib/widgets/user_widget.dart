import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rail_app/providers/base_provider.dart';
import 'package:lottie/lottie.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  ThemeMode _themeMode = ThemeMode.system;
  void _switchTheme() {
    Provider.of<BaseProvider>(context, listen: false).switchTheme();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Lottie.network(
            'https://assets10.lottiefiles.com/packages/lf20_bYM6JctQrv.json',
            //height: 200,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'SETTINGS',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 20),
              IconButton(
                onPressed: _switchTheme,
                icon: Icon(
                  color: Theme.of(context).primaryColor,
                  ThemeMode.light ==
                          Provider.of<BaseProvider>(context, listen: false)
                              .getCurrentTheme()
                      ? Icons.light_mode
                      : Icons.dark_mode_rounded,
                ),
              ),
              SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  Provider.of<BaseProvider>(context, listen: false).signOut();
                },
                style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                        Theme.of(context).primaryColor)),
                icon: Icon(
                  Icons.logout_outlined,
                ),
                label: Text('loog out'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
