import 'package:flutter/material.dart';
import 'package:soundays/models/album.dart';
import 'package:soundays/models/artist.dart';

class Track {
  final Album album;
  final List<Artist> artists;
  final int discNumber;
  final int durationInMs;
  final bool explicit;
  final dynamic externalIds;
  final dynamic externalUrls;
  final String href;
  final String id;
  final bool isLocal;
  final bool isPlayable;
  final String name;
  final int popularity;
  final String previewUrl;
  final int trackNumber;
  final String type;
  final String uri;

  Track({
    required this.album,
    required this.artists,
    required this.discNumber,
    required this.durationInMs,
    required this.explicit,
    required this.externalIds,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.isLocal,
    required this.isPlayable,
    required this.name,
    required this.popularity,
    required this.previewUrl,
    required this.trackNumber,
    required this.type,
    required this.uri,
  });

  static Track fromMap(Map<String, dynamic> json) {
    return Track(
      album: Album.fromMap(json['album']),
      artists: Artist.listFromMap(json),
      discNumber: json['disc_number'],
      durationInMs: json['duration_ms'],
      explicit: json['explicit'],
      externalIds: json['external_ids'],
      externalUrls: json['external_urls'],
      href: json['href'],
      id: json['id'],
      isLocal: json['is_local'] != null ? json['is_local'] : false,
      isPlayable: json['is_playable'] != null ? json['is_playable'] : false,
      name: json['name'],
      popularity: json['popularity'],
      previewUrl: json['preview_url'] != null ? json['preview_url'] : '',
      trackNumber: json['track_number'],
      type: json['type'],
      uri: json['uri'],
    );
  }

  static List<Track> listFromMap(Map<String, dynamic> json) {
    List<Track> response = <Track>[];

    json['tracks'].forEach((track) {
      response.add(Track.fromMap(track));
    });
    return response;
  }
}