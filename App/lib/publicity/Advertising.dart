class Advertising {
  final int? id;
  final String? name;
  final String? description;
  final List<String> images;
  final String? imageUrl;

  Advertising({
    this.id,
    this.name,
    this.description,
    required this.images,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'images': images,
    };
  }
}
