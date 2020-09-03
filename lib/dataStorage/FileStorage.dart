import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class FileStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> fileWithName(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<String> readFromFile(String fileName) async {
    try {
      final file = await fileWithName(fileName);

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeToFile(String fileName, String value) async {
    final file = await fileWithName(fileName);

    // Write the file
    return file.writeAsString(value);
  }
}