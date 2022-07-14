import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Authentication {
  final String url = "https://accounts.spotify.com/api/token";
  final Map<String, String> body = {"grant_type": "client_credentials"};
  static Map<String, String> headers = {};
  String id = '';
  String secret = '';

  // Future _setTokenExpirationDate() async {
  //   if (prefs == null) {
  //     prefs = await SharedPreferences.getInstance();
  //   }
  //   DateTime _hourFromNow = new DateTime.now();
  //   _hourFromNow = _hourFromNow.add(new Duration(minutes: 55));
  //
  //   String dateString = _hourFromNow.toString();
  //   prefs.setString('token_date', dateString);
  // }


  Future<String> getAuthToken() async {
    //prefs = await SharedPreferences.getInstance();
    id = 'ea02e1bbc577462bbb9d9baa73c55151';
    secret = '9b895619bd414c1eae753515e45f2561';
    Map<String, String> headers = {
      "Authorization": "Basic " + base64.encode(utf8.encode(id + ':' + secret)),
      "Content-Type": "application/x-www-form-urlencoded",
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
        encoding: Encoding.getByName("utf-8"),
      );
      Map<dynamic, dynamic> map = jsonDecode(response.body);
      //await _setTokenExpirationDate();

      // prefs.setString('access_token', map['access_token']);
      debugPrint('spotify token: ');
      debugPrint(map['access_token']);
      return map['access_token'];
    } on SocketException catch (e) {
      debugPrint(e.message + ', ' + e.osError.toString());
      throw AuthError(e.message);
    }
  }

}

class AuthError extends Error {
  final String message;
  AuthError(this.message);
}