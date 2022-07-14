import 'package:flutter/material.dart';

class Seed {
  final int initialPoolSize;
  final int afterFilteringSize;
  final int afterRelinkingSize;
  final String id;
  final String type;
  final String href;

  Seed({
    required this.initialPoolSize,
    required this.afterFilteringSize,
    required this.afterRelinkingSize,
    required this.id,
    required this.type,
    required this.href
  });

  static Seed fromMap(Map json) {
    return Seed(
      initialPoolSize: json['initialPoolSize'],
      afterFilteringSize: json['afterFilteringSize'],
      afterRelinkingSize: json['afterRelinkingSize'],
      id: json['id'],
      type: json['type'],
      href: json['href'] != null ? json['href'] : ''
    );
  }

  static List<Seed> listFromMap(List<dynamic> json) {
    List<Seed> response = <Seed>[];

    json.forEach((seed) {
      response.add(Seed.fromMap(seed));
    });
    return response;
  }
}