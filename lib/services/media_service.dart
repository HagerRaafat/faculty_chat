import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MediaService {
  static MediaService instance = MediaService();
  Future<File> getImageFromLibrary() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final File file = File(pickedFile.path);
    return file;
  }
}
