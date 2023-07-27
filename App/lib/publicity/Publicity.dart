class Publicity {
  final String? title;
  final String? description;
  final List<String> images;

  Publicity({
    this.title,
    this.description,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': images,
    };
  }
}
