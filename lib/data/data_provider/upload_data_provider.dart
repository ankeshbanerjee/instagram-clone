import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UploadDataProvider {
  final FirebaseStorage firebaseStorage;
  UploadDataProvider({required this.firebaseStorage});

  Future<String> upload(File file, String directory) async {
    var fileName = DateTime.now().millisecondsSinceEpoch.toString();
    var storageRef = firebaseStorage.ref().child('$directory/').child(fileName);
    var snapshot = await storageRef.putFile(file);
    return await snapshot.ref.getDownloadURL();
  }
}
