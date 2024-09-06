import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tmdb_ott_providers_extractor/models/ott_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherService {

  ///[directLink] is the link from [OTTProviderItemModel] link property.
  static Future launchDirectLink(String directLink) async {
    Completer completer = Completer();

    var uri = Uri.parse(directLink);

    var hl = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri.uri(uri),
      ),
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        if (navigationAction.request.url?.host != uri.host) {
          await launchUrl(navigationAction.request.url ?? uri);
          if (!completer.isCompleted) {
            completer.complete();
          }
          return NavigationActionPolicy.CANCEL;
        } else {
          return NavigationActionPolicy.ALLOW;
        }
      },
    )..run();

    await completer.future;

    hl.dispose();

    return;
  }
}