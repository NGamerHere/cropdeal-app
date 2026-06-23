import 'package:cropdeal/models/Country.dart';

class State {
  final int id;
  final String name;
  final Country country;
  final int cityCount;

  State({
    required this.id,
    required this.name,
    Country? country,
    this.cityCount = 0,
  }) : country = country ??
            Country(id: 0, name: '', code: '');

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      id: json['id'] as int,
      name: json['name'] as String,
      country: json['country'] != null
          ? Country.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      cityCount: (json['cityCount'] as int?) ?? 0,
    );
  }
}
