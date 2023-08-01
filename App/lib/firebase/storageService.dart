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

  Future<void> uploadFiles(List<String> filePaths, List<String> fileNames) async {
    try {
      for (int i = 0; i < filePaths.length; i++) {
        File file = File(filePaths[i]);
        String fileName = fileNames[i] as String; // Explicit type casting
        await storage.ref('animalAds/$fileName').putFile(file);
      }
    } on firebaseCore.FirebaseException catch (e) {
      print(e);
    }

  }


}