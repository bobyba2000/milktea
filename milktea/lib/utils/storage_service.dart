import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Storage {
  static Future<String?> uploadFile(
      String filePath, String fileName, String storagePath) async {
    File file = File(filePath);
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      final process = await storage.ref('$storagePath/$fileName').putFile(file);
      final url = await process.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  static Future<String> downloadUrl(String fileName, String storagePath) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    String downloadURL =
        await storage.ref('$storagePath/$fileName').getDownloadURL();
    return downloadURL;
  }

  static Future<ListResult?> getAllFiles({
    required String storagePath,
  }) async {
    try {
      ListResult result =
          await FirebaseStorage.instance.ref(storagePath).listAll();
      return result;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future<List<String>> getAllFilesUrl(
      {required String storagePath}) async {
    try {
      ListResult? listResultFile = await getAllFiles(storagePath: storagePath);
      if (listResultFile == null) {
        return [];
      }
      List<String> listFileUrls = [];
      for (int i = 0; i < (listResultFile.items).length; i++) {
        String url = await listResultFile.items[i].getDownloadURL();
        listFileUrls.add(url);
      }
      return listFileUrls;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
