class Category {
  final int id;
  final String name;
  final int? parentCategoryId;
  final String? imageKey;
  final List<Category> subCategories;

  Category({
    required this.id,
    required this.name,
    this.parentCategoryId,
    this.imageKey,
    this.subCategories = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      parentCategoryId: json['parentCategoryId'] as int?,
      imageKey: json['imageKey'] as String?,
      subCategories: (json['subCategories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
