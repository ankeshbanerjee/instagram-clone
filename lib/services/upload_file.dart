import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> upload(File file, String directory) async {
  var fileName = DateTime.now().millisecondsSinceEpoch.toString();
  var storageRef =
      FirebaseStorage.instance.ref().child('$directory/').child(fileName);
  var snapshot = await storageRef.putFile(file);
  return await snapshot.ref.getDownloadURL();
}
