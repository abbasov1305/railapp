import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  Function pickImg;
  UserImagePicker(this.pickImg);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final _picker = ImagePicker();

    final img = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = File(img!.path);
      widget.pickImg(_pickedImage!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.black45,
            backgroundImage:
                _pickedImage != null ? NetworkImage(_pickedImage!.path) : null,
          ),
          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.upload_file),
            label: Text('upload image'),
          ),
        ],
      ),
    );
  }
}
