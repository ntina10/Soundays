import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
  //   (await rootBundle.load('lib/assets/my_test.jpg')).buffer.asUint8List(),
  //   filename: 'my_test.jpg', // use the real name if available, or omit
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

  var res;
  var response;
  try {
    res = await request.send().timeout(
      const Duration(seconds: 15),
    );
    response = await http.Response.fromStream(res);
  } on TimeoutException catch (e) {
    print('Runtime error' + e.toString()); // SocketException: Connection timed out (OS Error: Connection timed out, errno = 110), address = 192.168.1.10, port = 43004
    response = http.Response('Connection timed out', 408);
  }

  return response;
}

Future<http.Response> setRate(emo, rat, url) async {
  var response = await http.post(
      url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'emotion': emo, 'rating': rat}));
  print('response is ${response.statusCode}');
  return response;
}
