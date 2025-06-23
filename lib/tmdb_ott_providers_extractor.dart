// ignore_for_file: non_constant_identifier_names

library tmdb_ott_providers_extractor;

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart';
import 'package:tmdb_ott_providers_extractor/constants/urls.dart';
import 'package:tmdb_ott_providers_extractor/models/ott_provider.dart';
import 'package:tmdb_ott_providers_extractor/services/extractor.dart';

import 'package:url_launcher/url_launcher.dart' show LaunchMode, launchUrl;

class TMDbOTTProvidersExtractor {
  /// get the last redirected link from [link] property.
  static Future<Uri> redirect_to_last_link(String link) async {
    var uri = Uri.parse(link);

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

    return Uri.parse(response.headers[HttpHeaders.locationHeader] as String? ??
        uri.toString());
  }

  ///[directLink] is the url from [OTTProviderItemModel] link property.
  static Future launchRedirectLink(String directLink,
      [LaunchMode launchMode = LaunchMode.platformDefault]) async {
    final uri = await redirect_to_last_link(directLink);
    launchUrl(uri, mode: launchMode);
    return;
  }

  static Future<List<OTTProviderModel>> extract(
      String id, String type, String locale) async {
    Uri uri = Uri.parse(
        "${Urls.baseUrl}/$type/$id/watch?translate=false&locale=$locale");
    try {
      String source = await _getHttpSource(uri);
      return ExtractorService.extract(source);
    } catch (err) {
      String source = await _getWebViewSource(uri);
      return ExtractorService.extract(source);
    }
  }

  static Future<String> _getHttpSource(Uri uri) async {
    try {
      log("[TMDbOTTProvidersExtractor] Fetching using http client.");
      Response response = await get(uri);
      if (response.statusCode == HttpStatus.ok) {
        return response.body;
      } else {
        throw Exception(
            "Error occurred while trying to get data from TMDb status code (${response.statusCode}): ${uri.toString()}");
      }
    } on PlatformException catch (err) {
      throw Exception(err.toString());
    }
  }

  static Future<String> _getWebViewSource(Uri uri) async {
    log("[TMDbOTTProvidersExtractor] Fetching using headless WebView.");
    Completer<String> completer = Completer<String>();

    var hl = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri.uri(uri),
      ),
      onLoadStop: (controller, url) async {
        final source = await controller.evaluateJavascript(
            source: "document.documentElement.outerHTML;");
        if (!completer.isCompleted) {
          completer.complete(source);
        }
      },
    )..run();

    String source = await completer.future;

    hl.dispose();

    return source;
  }
}
