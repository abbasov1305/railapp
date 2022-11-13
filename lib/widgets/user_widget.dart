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
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.network(
            'https://assets10.lottiefiles.com/packages/lf20_bYM6JctQrv.json',
          ),
          Text(
            'SETTINGS',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
