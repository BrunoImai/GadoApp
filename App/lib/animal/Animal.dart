

class AnimalAd {
  final String name;
  final double price;
  final String localization;
  final String? weight;
  final int? quantity;
  final String? priceType;
  final String? description;
  final String? batch = "0000";


  AnimalAd({required this.name, required this.price, required this.localization, this.weight,
      this.quantity, this.priceType, this.description, required batch});


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'localization': localization,
      'priceType': priceType,
      'quantity': quantity,
      'description': description,
      'weight': weight,
    };
  }
}