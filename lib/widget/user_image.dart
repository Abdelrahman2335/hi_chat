import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onSelectedImage});

  // This fun is taking the data from user_image file then go to the auth screen,
  //and give this data to another var and this var will send the image to the firebase.
  final void Function(Uint8List pickedImage) onSelectedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  Uint8List? _pickedImageByte;

  void _pickImage() async {
    // This will pick the image
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result == null) {
      return;
    }
    setState(() {
      _pickedImageByte = result.files.single.bytes;
    });

    if (_pickedImageByte == null) {
      return;
    }

    /// We have created this function and used it here because we need to have access on _pickedImageByte in the auth screen
    widget.onSelectedImage(_pickedImageByte!);
  }

  // This function uses imagePicker. and this is not supported by the web
  // void _pickImage() async {
  //   // This function allowing us to take an image from the gallery.
  //   XFile? pickedImage = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     maxWidth: 150,
  //     imageQuality: 50,
  //   );
  //   if (pickedImage == null) {
  //     return;
  //   }
  //   setState(() {
  //     // here we are give [_pickedImageFile]  value, but the picked Image type is XFile so we have to give it that way.
  //     _pickedImageFile = File(pickedImage.path);
  //   });
  //   /// We have created this function and used it here because we need to have access on _pickedImageFile in the auth screen
  //   widget.onSelectedImage(_pickedImageFile!);
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageByte == null ? null : MemoryImage(_pickedImageByte!),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: Text(
            "Add Image",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }
}
