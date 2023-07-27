import '../ad/Ad.dart';

class LandAd extends Ad {
  final String? area;
  final String? priceType;
  final String? description;

  LandAd({
    int? id,
    required String name,
    required double price,
    required String localization,
    this.area,
    this.priceType,
    this.description,
    String? batch,
    bool? isFavorite,
    images
  }) : super(
    id: id,
    name: name,
    price: price,
    localization: localization,
    batch: batch,
    isFavorite: isFavorite,
    images: images
  );

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'area': area,
      'priceType': priceType,
      'description': description,
    });
    return data;
  }
}
