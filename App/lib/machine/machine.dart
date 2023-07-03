class MachineAdRequest {
  final String name;
  final double price;
  final String localization;
  final int? quantity;
  final String? priceType;
  final String? description;


  MachineAdRequest(
      {required this.name, required this.price, required this.localization,
        this.quantity, this.priceType, this.description});


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'localization': localization,
      'priceType': priceType,
      'quantity': quantity,
      'description': description,
    };
  }
}