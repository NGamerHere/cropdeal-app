import 'package:cropdeal/models/BusinessType.dart';
import 'package:cropdeal/models/Country.dart';
import 'package:cropdeal/models/UserRole.dart';
import 'package:cropdeal/models/State.dart';

class AppConfigState {
  final List<UserRole> userRoles;
  final List<BusinessType> businessTypes;
  final List<Country> countries;
  final List<State> states;

  const AppConfigState({
    this.userRoles = const [],
    this.businessTypes = const [],
    this.states = const [],
    this.countries = const []
  });

  AppConfigState copyWith({
    List<UserRole>? userRoles,
    List<BusinessType>? businessTypes,
    List<Country>? country,
    List<State>? states,
  }) {
    return AppConfigState(
      userRoles: userRoles ?? this.userRoles,
      businessTypes: businessTypes ?? this.businessTypes,
      states: states ?? this.states,
      countries: country ?? countries,
    );
  }
}