import '../ad/Ad.dart';

class AnimalAd extends Ad {
  final String? weight;
  final int? quantity;
  final String? priceType;
  final String? description;

  AnimalAd({
    int? id,
    required String name,
    required double price,
    required String localization,
    this.weight,
    this.quantity,
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
    images: images,
  );

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'weight': weight,
      'quantity': quantity,
      'priceType': priceType,
      'description': description,
    });
    return data;
  }
}