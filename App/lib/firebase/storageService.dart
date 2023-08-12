import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebaseCore;
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;

class Storage{
  final firebaseStorage.FirebaseStorage storage = firebaseStorage.FirebaseStorage.instance;

  Future<bool> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('animalAds/$fileName').putFile(file);
      return true; // Return true if the upload was successful.
    } on firebaseCore.FirebaseException catch (e) {
      print(e);
      return false; // Return false if an exception occurred during the upload.
    }
  }

  Future<String> getImageUrl(String imageName) async {
    final ref = storage.ref('animalAds/$imageName');
    return await ref.getDownloadURL();
  }

  Future<void> uploadFiles(List<ImageFile> images) async {
    try {
      for (int i = 0; i < images.length; i++) {
        if (images[i].filePath != "") {
          File file = File(images[i].filePath);
          String fileName = images[i].fileName; // Explicit type casting
          await storage.ref('animalAds/$fileName').putFile(file);
        }
      }
    } on firebaseCore.FirebaseException catch (e) {
      print(e);
    }

  }
}

class ImageFile<path, name> {
  final String filePath;
  final String fileName;

  ImageFile(this.fileName, this.filePath);
}

