import 'package:cropdeal/models/Country.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/AppConfigData.dart';
import 'package:cropdeal/models/BusinessType.dart';
import 'package:cropdeal/models/UserRole.dart';
import 'package:cropdeal/models/User.dart';

import '../models/State.dart';

class AppConfigNotifier extends Notifier<AppConfigState> {

  @override
  AppConfigState build() {
    return const AppConfigState();
  }

  void setCountries(List<Country> countries) {
    state = state.copyWith(country: countries);
  }

  void setStates(List<State> states) {
    state = state.copyWith(states: states);
  }

  void setUserRoles(List<UserRole> roles) {
    state = state.copyWith(userRoles: roles);
  }

  void setBusinessTypes(List<BusinessType> types) {
    state = state.copyWith(businessTypes: types);
  }

  void setUser(User user) {
    state = state.copyWith(user: user);
  }
}
final appConfigProvider =
NotifierProvider<AppConfigNotifier, AppConfigState>(
  AppConfigNotifier.new,
);