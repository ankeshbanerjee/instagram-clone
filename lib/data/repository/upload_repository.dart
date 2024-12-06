import 'dart:developer';
import 'dart:io';
import 'package:instagram_clone/data/data_provider/upload_data_provider.dart';

class UploadRepository {
  final UploadDataProvider uploadDataProvider;
  UploadRepository({required this.uploadDataProvider});

  Future<String> upload(File file, String directory) async {
    try {
      return await uploadDataProvider.upload(file, directory);
    } catch (e) {
      log("Error uploading file: ${e.toString()}");
      throw e.toString();
    }
  }
}
