class OTTProviderModel {
  String name;
  List<OTTProviderItemModel> providers;

  OTTProviderModel({
    this.name = "",
    this.providers = const [],
  });

  factory OTTProviderModel.fromMap(Map<String, dynamic> map) => OTTProviderModel(
    name: map["name"] ?? "",
    providers: List<OTTProviderItemModel>.from((map["providers"] ?? []).map((e) => OTTProviderItemModel.fromMap(e))),
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "providers": providers.map((e) => e.toMap()).toList(),
  };

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

  factory OTTProviderItemModel.fromMap(Map<String, dynamic> map) => OTTProviderItemModel(
    name: map["name"] ?? "",
    link: map["link"] ?? "",
    price: map["price"] ?? "",
    image: map["image"] ?? "",
    presentation: map["presentation"] ?? "",
  );

  @override
  String toString() => "OTTProviderItemModel($name, $link, $price, $image, $presentation)";

  Map<String, dynamic> toMap() => {
    "name": name,
    "link": link,
    "price": price,
    "image": image,
    "presentation": presentation,
  };
}
