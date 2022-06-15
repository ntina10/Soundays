import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<http.Response> getDataCam(file, url) async {
  //String filename = file.path.split('/').last;
  print("Got in get data");
  var request = http.MultipartRequest(
    'POST',
    url,
  );
  Map<String, String> headers = {"Content-type": "multipart/form-data"};

  print("This is file"+file.toString());
  // var multipartFile = http.MultipartFile.fromBytes(
  //   'image',
  //   (await rootBundle.load('lib/assets/'+filename)).buffer.asUint8List(),
  //   filename: filename, // use the real name if available, or omit
  //   // contentType: MediaType('image', 'jpg'),
  // );

  request.files.add(
    //multipartFile
    http.MultipartFile.fromBytes(
      'image',
      file,

    ),
  );

  print(request.files[0]);

  request.headers.addAll(headers);
  print("request: " + request.toString());
  var res = await request.send();
  var response = await http.Response.fromStream(res);
  print("This is response:" + response.body);

  return response;
}

