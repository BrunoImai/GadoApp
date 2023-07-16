class Ad {
  final int? id;
  final String name;
  final double price;
  final String localization;
  final String? batch;
  bool? isFavorite;

  Ad({
    this.id,
    required this.name,
    required this.price,
    required this.localization,
    this.batch = "0000",
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'localization': localization,
    };
  }
}