class Variant {
  final int id;
  final String variantName;
  final double unitValue;
  final String unitType;

  Variant({
    required this.id,
    required this.variantName,
    required this.unitValue,
    required this.unitType,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'] as int,
      variantName: json['variantName'] as String,
      unitValue: (json['unitValue'] as num).toDouble(),
      unitType: json['unitType'] as String,
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final String brand;
  final int variantCount;
  final String? imageUrl;
  final List<Variant> variants;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.brand,
    required this.variantCount,
    this.imageUrl,
    this.variants = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      variantCount: json['variantCount'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String?,
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) => Variant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
