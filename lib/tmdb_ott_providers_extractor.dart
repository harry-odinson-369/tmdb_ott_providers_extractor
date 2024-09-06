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

export 'package:tmdb_ott_providers_extractor/services/launcher.dart';

class TMDbOTTProvidersExtractor {
  static Future<List<OTTProviderModel>> extract(String id, String type, String locale) async {
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
        final source = await controller.evaluateJavascript(source: "document.documentElement.outerHTML;");
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
