import 'package:flutter/material.dart';

class ImageObj {
  int height;
  String url;
  int width;

  ImageObj({
    required this.height,
    required this.url,
    required this.width
  });

  static ImageObj fromMap(Map json) {
    return ImageObj(
      height: json['height'],
      url: json['url'],
      width: json['width']
    );
  }

  static List<ImageObj> listFromMap(Map json) {
    List<ImageObj> response = <ImageObj>[];

    json['images'].forEach((image_obj) {
      response.add(
          ImageObj(
            height: image_obj['height'],
            url: image_obj['url'],
            width: image_obj['width'],
          )
      );
    });
    return response;
  }
}