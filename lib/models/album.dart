import 'package:flutter/material.dart';
import 'package:soundays/models/image_obj.dart';

class Album {
  final String albumType;
  final List<dynamic> artists;
  final dynamic externalUrls;
  final String href;
  final String id;
  final List<ImageObj> images;
  final String name;
  final String releaseDate;
  final String releaseDatePrecision;
  final int totalTracks;
  final String type;
  final String uri;

  Album({
    required this.albumType,
    required this.artists,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.totalTracks,
    required this.type,
    required this.uri,
  });

  static Album fromMap(Map json) {
    return Album(
      albumType: json['album_type'],
      artists: json['artists'],
      externalUrls: json['external_urls'],
      href: json['href'],
      id: json['id'],
      images: ImageObj.listFromMap(json),
      name: json['name'],
      releaseDate: json['release_date'],
      releaseDatePrecision: json['release_date_precision'],
      totalTracks: json['total_tracks'],
      type: json['type'],
      uri: json['uri'],
    );
  }

  // static List<Track> listFromMap(List<dynamic> json) {
  //   List<Track> response = <Track>[];
  //
  //   json.forEach((track) {
  //     response.add(Track.fromMap(track));
  //   });
  //   return response;
  // }
}