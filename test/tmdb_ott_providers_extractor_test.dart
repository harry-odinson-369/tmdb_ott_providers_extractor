// ignore_for_file: avoid_print

import 'package:tmdb_ott_providers_extractor/tmdb_ott_providers_extractor.dart';

void main() {
  TMDbOTTProvidersExtractor.extract("693134", "movie", "US").then((res) {
    res.map((e) => print(e.toString()));
  });
}
