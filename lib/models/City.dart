import 'package:cropdeal/models/Country.dart';
import 'package:cropdeal/models/State.dart';

class City {
  final int id;
  final String name;
  final State state;
  final Country country;
  final int areaCount;

  City({
    required this.id,
    required this.name,
    State? state,
    Country? country,
    this.areaCount = 0,
  })  : state = state ?? State(id: 0, name: ''),
        country = country ?? Country(id: 0, name: '', code: '');

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      name: json['name'] as String,
      state: json['state'] != null
          ? State.fromJson(json['state'] as Map<String, dynamic>)
          : null,
      country: json['country'] != null
          ? Country.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      areaCount: (json['areaCount'] as int?) ?? 0,
    );
  }
}
