import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePicking extends StatefulWidget {
  const ImagePicking({Key? key}) : super(key: key);

  @override
  State<ImagePicking> createState() => _ImagePickingState();
}

class _ImagePickingState extends State<ImagePicking> {
  ImagePicker imagePicker = ImagePicker();
  ImagePicker imagePickerCamera = ImagePicker();
  List<XFile> imageList = [];
  File? _image;
  File? _multiImage;

  Future<void> selectImage() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        imageList.addAll(selectedImages);
        _multiImage =
            File(imageList.first.path); // Show the first selected image
      });
    }
    print("selected");
  }

  Future<void> selectImageFromCamera() async {
    final selectedCameraImage =
        await imagePickerCamera.pickImage(source: ImageSource.camera);
    if (selectedCameraImage != null) {
      setState(() {
        _image = File(selectedCameraImage.path);
      });
    }
    print("selected");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: imageList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, crossAxisSpacing: 12),
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(imageList[index].path),
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            _image == null
                ? const Text("No Image Selected")
                : Image.file(height: 100, width: 100, _image!),
            ElevatedButton(
              onPressed: () {
                selectImage();
              },
              child: const Text("Pick Image"),
            ),
            ElevatedButton(
              onPressed: () {
                selectImageFromCamera();
              },
              child: const Text("Pick Image from camera"),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
