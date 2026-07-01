import 'package:cropdeal/models/BusinessType.dart';
import 'package:cropdeal/models/Country.dart';
import 'package:cropdeal/models/UserRole.dart';
import 'package:cropdeal/models/State.dart';
import 'package:cropdeal/models/User.dart';

class AppConfigState {
  final List<UserRole> userRoles;
  final List<BusinessType> businessTypes;
  final List<Country> countries;
  final List<State> states;
  final User? user;

  const AppConfigState({
    this.userRoles = const [],
    this.businessTypes = const [],
    this.states = const [],
    this.countries = const [],
    this.user,
  });

  AppConfigState copyWith({
    List<UserRole>? userRoles,
    List<BusinessType>? businessTypes,
    List<Country>? country,
    List<State>? states,
    User? user,
  }) {
    return AppConfigState(
      userRoles: userRoles ?? this.userRoles,
      businessTypes: businessTypes ?? this.businessTypes,
      states: states ?? this.states,
      countries: country ?? countries,
      user: user ?? this.user,
    );
  }
}