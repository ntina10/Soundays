import 'package:flutter/material.dart';
import 'package:test_zero/models/track.dart';
import 'package:test_zero/models/seed.dart';

class Recommendation{
  List<Track> tracks;
  List<Seed> seeds;

  Recommendation({
    required this.tracks,
    required this.seeds
  });

  static Recommendation fromMap(Map<String, dynamic> json) {
      return Recommendation(
        tracks: Track.listFromMap(json),
        seeds: Seed.listFromMap(json['seeds']),
      );
  }

}