import 'package:flutter_test/flutter_test.dart';

import 'package:tmdb_ott_providers_extractor/tmdb_ott_providers_extractor.dart';

void main() {
  TMDbOTTProvidersExtractor.extract("693134", "movie", "US").then((res) {
    res.map((e) => print(e.toString()));
  });
}
