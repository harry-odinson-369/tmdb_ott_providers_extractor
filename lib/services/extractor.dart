import 'package:html/parser.dart' show parse;

import '../models/ott_provider.dart';

class ExtractorService {
  static List<OTTProviderModel> extract(String source) {

    List<OTTProviderModel> temp = [];

    var document = parse(source);

    var ottOfferWindow = document.querySelector("#ott_offers_window");

    var ottProviders = ottOfferWindow?.querySelectorAll(".ott_provider");

    if (ottProviders == null) return [];

    for (var provider in ottProviders) {

      var h3 = provider.getElementsByTagName("h3");

      var lis = provider.getElementsByTagName("li");

      List<OTTProviderItemModel> items = [];

      for (var li in lis) {
        var a = li.getElementsByTagName("a");
        var link = a.first.attributes["href"];
        var name = a.first.attributes["title"];

        var img = li.getElementsByTagName("img");
        var image = img.first.attributes["src"];

        var span = li.querySelector("div > span > span.price");
        var span1 = li.querySelector("div > span > span.presentation_type");
        var price = "";
        var presentationType = "";

        if (span != null) {
          price = span.text;
        }

        if (span1 != null) {
          presentationType = span1.text;
        }

        items.add(OTTProviderItemModel(
          name: name ?? "",
          link: link ?? "",
          image: image ?? "",
          price: price,
          presentation: presentationType,
        ));

      }

      temp.add(OTTProviderModel(
        name: h3.first.text,
        providers: items,
      ));
    }

    return temp;
  }
}