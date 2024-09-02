class OTTProviderModel {
  String name;
  List<OTTProviderItemModel> providers;

  OTTProviderModel({
    this.name = "",
    this.providers = const [],
  });
}

class OTTProviderItemModel {
  String name;
  String link;
  String price;
  String image;
  String presentation;

  OTTProviderItemModel({
    this.name = "",
    this.link = "",
    this.price = "",
    this.image = "",
    this.presentation = "",
  });


  @override
  String toString() => "OTTProviderItemModel($name, $link, $price, $image, $presentation)";
}
