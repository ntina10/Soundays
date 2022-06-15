import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<http.Response> getData(file, url) async {
  print("Got in get data");
  String filename = file.path.split('/').last;
  var request = http.MultipartRequest(
    'POST',
    url,
  );
  Map<String, String> headers = {"Content-type": "multipart/form-data"};

  // var multipartFile = http.MultipartFile.fromBytes(
  //   'image',
  //   (await rootBundle.load('lib/assets/test_face.jpg')).buffer.asUint8List(),
  //   filename: 'test_face.jpg', // use the real name if available, or omit
  //   // contentType: MediaType('image', 'jpg'),
  // );

  request.files.add(
      // multipartFile
    http.MultipartFile(
      'image',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: filename,
    ),
  );

  request.headers.addAll(headers);
  print("request: " + request.toString());
  var res = await request.send();
  var response = await http.Response.fromStream(res);
  print("This is response:" + response.body);

  return response;
}

