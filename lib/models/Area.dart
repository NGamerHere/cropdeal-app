import 'package:cropdeal/models/City.dart';
import 'package:cropdeal/models/Country.dart';
import 'package:cropdeal/models/State.dart';

class Area {
  final int id;
  final String name;
  final String pincode;
  final City city;
  final State state;
  final Country country;

  Area({
    required this.id,
    required this.name,
    required this.pincode,
    City? city,
    State? state,
    Country? country,
  })  : city = city ?? City(id: 0, name: ''),
        state = state ?? State(id: 0, name: ''),
        country = country ?? Country(id: 0, name: '', code: '');

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'] as int,
      name: json['name'] as String,
      pincode: (json['pincode'] as String?) ?? '',
      city: json['city'] != null
          ? City.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      state: json['state'] != null
          ? State.fromJson(json['state'] as Map<String, dynamic>)
          : null,
      country: json['country'] != null
          ? Country.fromJson(json['country'] as Map<String, dynamic>)
          : null,
    );
  }
}
