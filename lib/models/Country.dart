class Country {
  final int id;
  final String name;
  final String code;
  final int stateCount;

  Country({
    required this.id,
    required this.name,
    required this.code,
    this.stateCount = 0,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int,
      name: json['name'] as String,
      code: (json['code'] as String?) ?? '',
      stateCount: (json['stateCount'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'stateCount': stateCount,
    };
  }
}
