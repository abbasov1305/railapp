import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rail_app/providers/base_provider.dart';
import 'package:lottie/lottie.dart';

class AddWidget extends StatefulWidget {
  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  final _textController = TextEditingController();
  bool _isShared = false;
  bool _isEnable = false;

  void _shareText() {
    try {
      setState(() {
        _isShared = true;
      });
      Provider.of<BaseProvider>(context, listen: false)
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
    return Scaffold(
      appBar: AppBar(
        title: Text('SHARE YOUR THOUGHTS'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.network(
                'https://assets6.lottiefiles.com/private_files/lf30_ajpz5zar.json',
                animate: _isEnable ? true : false,
              ),
              TextField(
                controller: _textController,
                onChanged: (value) => setState(() {
                  if (value.isEmpty) {
                    _isEnable = false;
                  } else {
                    _isEnable = true;
                  }
                }),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).accentColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                maxLines: 6,
              ),
              SizedBox(height: 20),
              if (!_isShared && _isEnable)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: _shareText,
                  icon: Icon(Icons.public),
                  label: Text('share'),
                ),
              if (_isShared) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
