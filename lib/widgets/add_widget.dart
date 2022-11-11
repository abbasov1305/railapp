import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rail_app/providers/auth_provider.dart';

class AddWidget extends StatefulWidget {
  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  final _textController = TextEditingController();
  bool _isShared = false;

  void _shareText() {
    try {
      setState(() {
        _isShared = true;
      });
      Provider.of<AuthProvider>(context, listen: false)
          .addText(_textController.text, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isShared = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).accentColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              maxLines: 6,
            ),
            SizedBox(height: 20),
            if (!_isShared)
              OutlinedButton.icon(
                onPressed:
                    _textController.text.trim() == null ? null : _shareText,
                icon: Icon(Icons.public),
                label: Text('share'),
              ),
            if (_isShared) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
