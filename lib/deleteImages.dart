import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> deleteFile(String fileName) async {
  // try {
  //   final directory = await getApplicationDocumentsDirectory();
  //   print('mypath' + directory.path);
  //   final file = File('/images/' + fileName);
  //   print(file);
  //   print("the deleted is: " + file.path);
  //   await file.delete();
  //
  // } catch (e) {
  //   print('exception in deleteFile' + e.toString());
  //   return 0;
  // }
  // return 1;



  // final directory = await getApplicationDocumentsDirectory(); //   /data/user/0/com.example.test_zero/app_flutter
  // final dir = await getApplicationSupportDirectory(); //  /data/user/0/com.example.test_zero/files
  // //final dire = await getLibraryDirectory();
  // final dii = await getExternalStorageDirectory();  //  /storage/emulated/0/Android/data/com.example.test_zero/files
  // print("dir" + dir.path);
  // //print("dire" + dire.path);
  // print("d" + dii!.path);
  // print('mypath ' + directory.path);

  //final p = await getTemporaryDirectory();

  // final file = File('lib/images/' + fileName);
  // file.writeAsString(fileName);
  // print('file ' + file.path);
  // try {
  //     await file.delete();
  // } catch (e) {
  //   print('error' + e.toString());
  //   // Error in getting access to the file.
  // }

  final dir = Directory('flutter/lib/images');
  print('dir ' + dir.path);
  dir.deleteSync(recursive: true);


  // var myimage = await rootBundle.load('lib/images/' + fileName);
  // myimage.delete();

}

// Future<String> get _localPath async {
//   final directory = await getApplicationDocumentsDirectory();
//
//   return directory.path;
// }
//
// Future<File> _localFile(String name) async {
//   final path = await _localPath;
//   print('path ${path}');
//   return File('$path/$name');
// }
//
// Future<int> deleteFile(String fileName) async {
//   try {
//     final file = await _localFile(fileName);
//
//     await file.delete();
//   } catch (e) {
//     return 0;
//   }
//   return 1;
// }