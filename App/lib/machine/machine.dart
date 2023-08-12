
import '../ad/Ad.dart';

class MachineryAd extends Ad {
  final int? quantity;
  final String? priceType;
  final String? description;

  MachineryAd({
    int? id,
    required String name,
    required double price,
    required String localization,
    this.quantity,
    this.priceType,
    this.description,
    String? batch,
    bool? isFavorite,
    images,
    ownerId,
    status,
    imageUrl
  }) : super(
    id: id,
    name: name,
    price: price,
    localization: localization,
    batch: batch,
    isFavorite: isFavorite,
    images: images,
      ownerId: ownerId,
      status: status,
      imageUrl: imageUrl
  );

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'quantity': quantity,
      'priceType': priceType,
      'description': description,
    });
    return data;
  }
}