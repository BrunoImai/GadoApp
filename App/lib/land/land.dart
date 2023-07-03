class LandAdRequest {
  final String name;
  final double price;
  final String localization;
  final String? area;
  final String? priceType;
  final String? description;


  LandAdRequest(
      {required this.name, required this.price, required this.localization, this.area, this.priceType, this.description});


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'localization': localization,
      'priceType': priceType,
      'description': description,
      'area': area,
    };
  }
}