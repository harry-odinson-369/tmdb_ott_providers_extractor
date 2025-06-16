import 'dart:async';
import 'dart:io';

import 'package:tmdb_ott_providers_extractor/models/ott_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherService {

  ///[directLink] is the link from [OTTProviderItemModel] link property.
  static Future launchRedirectLink(String directLink, [LaunchMode launchMode = LaunchMode.platformDefault]) async {
    var uri = Uri.parse(directLink);

    var client = HttpClient();
    var request = await client.getUrl(uri);
    request.followRedirects = false;
    var response = await request.close();
    while (response.isRedirect) {
      response.drain();
      final location = response.headers.value(HttpHeaders.locationHeader);
      if (location != null) {
        uri = uri.resolve(location);
        request = await client.getUrl(uri);
        // Set the body or headers as desired.
        request.followRedirects = false;
        response = await request.close();
      }
    }

    launchUrl(Uri.parse(response.headers[HttpHeaders.locationHeader] as String? ?? uri.toString()), mode: launchMode);

    return;
  }
}