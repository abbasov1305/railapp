import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rail_app/providers/auth_provider.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('User Widget'),
          IconButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
