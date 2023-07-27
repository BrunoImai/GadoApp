class Ad {
  final int? id;
  final String name;
  final double price;
  final String localization;
  final String? batch;
  bool? isFavorite;
  final List<String> images;
  Ad({
    this.id,
    required this.name,
    required this.price,
    required this.localization,
    this.batch = "0000",
    this.isFavorite = false,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'localization': localization,
      'images': images
    };
  }
}