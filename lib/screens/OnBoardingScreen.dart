import 'dart:io';

import 'package:cropdeal/main.dart' show navigatorKey;
import 'package:cropdeal/models/Area.dart';
import 'package:cropdeal/models/BusinessType.dart';
import 'package:cropdeal/models/City.dart';
import 'package:cropdeal/models/Country.dart';
import 'package:cropdeal/models/District.dart';
import 'package:cropdeal/models/UserRole.dart';
import 'package:cropdeal/services/ApiClient.dart';
import 'package:cropdeal/stateNotifiers/AppConfigNotifier.dart';
import 'package:cropdeal/widgets/custom_dropdown.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/State.dart' as Models;

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  ConsumerState<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(text: "Ramesh Kumar");
  final TextEditingController _phoneController = TextEditingController(text: "99592 88004");

  UserRole? selectedUserType;
  BusinessType? selectedBusinessType;

  // ---- Cascade state ----
  List<Country> _countries = [];
  Country? _selectedCountry;
  bool _loadingCountries = false;

  List<Models.State> _states = [];
  Models.State? _selectedState;
  bool _loadingStates = false;

  List<District> _districts = [];
  District? _selectedDistrict;
  bool _loadingDistricts = false;

  List<City> _cities = [];
  City? _selectedCity;
  bool _loadingCities = false;

  List<Area> _areas = [];
  Area? _selectedArea;
  bool _loadingAreas = false;

  File? _profileImage;
  String? profileKey = '';

  Future<void> _pickProfileImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });

      FormData formData = FormData();
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(image.path),
        ),
      );
      
      var res= await _api.post("/api/upload",data: formData);
      setState(() {
        profileKey = res.data['key'];
      });
      
    }
  }

  late final config = ref.read(appConfigProvider);
  late final userRoles = config.userRoles;
  late final businessTypes = config.businessTypes;

  final _api = ApiClient(navigatorKey: navigatorKey);

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  // -------------------------------------------------------
  //  API fetchers
  // -------------------------------------------------------

  Future<void> _fetchCountries() async {
    setState(() => _loadingCountries = true);
    try {
      final res = await _api.get('/api/locations/countries');
      final list = (res.data as List).map((e) => Country.fromJson(e)).toList();
      setState(() {
        _countries = list;
        _loadingCountries = false;
      });
    } catch (_) {
      setState(() => _loadingCountries = false);
    }
  }

  Future<void> _fetchStates(int countryId) async {
    setState(() => _loadingStates = true);
    try {
      final res = await _api.get('/api/locations/states', queryParams: {'countryId': countryId});
      final list = (res.data as List).map((e) => Models.State.fromJson(e)).toList();
      setState(() {
        _states = list;
        _loadingStates = false;
      });
    } catch (_) {
      setState(() => _loadingStates = false);
    }
  }

  Future<void> _fetchDistricts(int stateId) async {
    setState(() => _loadingDistricts = true);
    try {
      final res = await _api.get('/api/locations/districts', queryParams: {'stateId': stateId});
      final list = (res.data as List).map((e) => District.fromJson(e)).toList();
      setState(() {
        _districts = list;
        _loadingDistricts = false;
      });
    } catch (_) {
      setState(() => _loadingDistricts = false);
    }
  }

  Future<void> _fetchCities(int districtId) async {
    setState(() => _loadingCities = true);
    try {
      final res = await _api.get('/api/locations/cities', queryParams: {'districtId': districtId});
      final list = (res.data as List).map((e) => City.fromJson(e)).toList();
      setState(() {
        _cities = list;
        _loadingCities = false;
      });
    } catch (_) {
      setState(() => _loadingCities = false);
    }
  }

  Future<void> _fetchAreas(int cityId) async {
    setState(() => _loadingAreas = true);
    try {
      final res = await _api.get('/api/locations/areas', queryParams: {'cityId': cityId});
      final list = (res.data as List).map((e) => Area.fromJson(e)).toList();
      setState(() {
        _areas = list;
        _loadingAreas = false;
      });
    } catch (_) {
      setState(() => _loadingAreas = false);
    }
  }

  // -------------------------------------------------------
  //  Cascade handlers
  // -------------------------------------------------------

  void _onCountryChanged(Country? country) {
    setState(() {
      _selectedCountry = country;
      _selectedState = null;
      _states = [];
      _selectedDistrict = null;
      _districts = [];
      _selectedCity = null;
      _cities = [];
      _selectedArea = null;
      _areas = [];
    });
    if (country != null) _fetchStates(country.id);
  }

  void _onStateChanged(Models.State? state) {
    setState(() {
      _selectedState = state;
      _selectedDistrict = null;
      _districts = [];
      _selectedCity = null;
      _cities = [];
      _selectedArea = null;
      _areas = [];
    });
    if (state != null) _fetchDistricts(state.id);
  }

  void _onDistrictChanged(District? district) {
    setState(() {
      _selectedDistrict = district;
      _selectedCity = null;
      _cities = [];
      _selectedArea = null;
      _areas = [];
    });
    if (district != null) _fetchCities(district.id);
  }

  void _onCityChanged(City? city) {
    setState(() {
      _selectedCity = city;
      _selectedArea = null;
      _areas = [];
    });
    if (city != null) _fetchAreas(city.id);
  }

  // -------------------------------------------------------
  //  Location summary
  // -------------------------------------------------------

  String get _locationSummary {
    final parts = <String>[];
    if (_selectedCountry != null) parts.add(_selectedCountry!.name);
    if (_selectedState != null) parts.add(_selectedState!.name);
    if (_selectedDistrict != null) parts.add(_selectedDistrict!.name);
    if (_selectedCity != null) parts.add(_selectedCity!.name);
    if (_selectedArea != null) parts.add('${_selectedArea!.name} (${_selectedArea!.pincode})');
    return parts.isEmpty ? 'No location selected' : parts.join(' > ');
  }

  // -------------------------------------------------------
  //  Build
  // -------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final double headerHeight = MediaQuery.of(context).size.height * 0.32;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerHeight,
            child: Image.asset('assets/images/login_bg.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Image.asset('assets/images/crop_deal_logo.png', width: 140, fit: BoxFit.contain),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Step 2 of 3 ",
                          style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        _buildStepDot(isActive: false),
                        _buildStepDot(isActive: true),
                        _buildStepDot(isActive: false),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Complete Your Profile",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Tell us a few details to personalize\nyour HARVEX experience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 45),

                    // ---- Form Card ----
                    Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                      margin: const EdgeInsets.only(bottom: 25.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ---- Full Name ----
                          _buildFieldLabel(Icons.person_outline, "Full Name"),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(fontSize: 14),
                            decoration: _buildInputDecoration(
                              suffixIcon: const Icon(Icons.edit_outlined, color: Colors.grey, size: 18),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ---- Mobile Number ----
                          _buildFieldLabel(Icons.phone_outlined, "Mobile Number"),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Row(
                                  children: [
                                    Text("🇮🇳", style: TextStyle(fontSize: 16)),
                                    SizedBox(width: 4),
                                    Text("+91", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    Icon(Icons.arrow_drop_down, size: 18, color: Colors.grey),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: _buildInputDecoration(
                                    suffixIcon: Container(
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Verified",
                                            style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 2),
                                          Icon(Icons.check_circle, color: Colors.green, size: 12),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ---- User Type ----
                          _buildFieldLabel(Icons.people_outline, "User Type"),
                          const SizedBox(height: 6),
                          _buildLocationDropdown<UserRole>(
                            value: selectedUserType,
                            items: userRoles,
                            itemLabel: (UserRole role) => role.name,
                            loading: false,
                            placeholder: "Select a user type",
                            prefixIcon: Icon(Icons.person_search_outlined, size: 16, color: Colors.grey.shade500),
                            onChanged: (UserRole? val) {
                              setState(() {
                                selectedUserType = val;
                                selectedBusinessType = null;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // ---- Business Type ----
                          _buildFieldLabel(Icons.business_center_outlined, "Business Type"),
                          const SizedBox(height: 6),
                          _buildLocationDropdown<BusinessType>(
                            value: selectedUserType == null ? null : selectedBusinessType,
                            items: businessTypes.where((type) {
                              if (selectedUserType == null) return false;
                              return type.id == selectedUserType!.id;
                            }).toList(),
                            itemLabel: (BusinessType type) => type.name,
                            loading: false,
                            placeholder: "Select business type",
                            prefixIcon: Icon(Icons.storefront_outlined, size: 16, color: Colors.grey.shade500),
                            onChanged: (BusinessType? val) {
                              setState(() {
                                selectedBusinessType = val;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // ---- Profile Image ----
                          const Text(
                            "Profile Image",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                _profileImage == null
                                    ? Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.green.shade400,
                                  size: 22,
                                )
                                    : CircleAvatar(
                                  radius: 20,
                                  backgroundImage: FileImage(_profileImage!),
                                ),
                                //Icon(Icons.camera_alt_outlined, color: Colors.green.shade400, size: 22),
                                const SizedBox(width: 30),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Upload Images",
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Add at least 1 clear image",
                                        style: TextStyle(fontSize: 10, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: _pickProfileImage,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.green),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  child: const Text(
                                    "Select Image",
                                    style: TextStyle(color: Colors.green, fontSize: 11),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // ---- Location Section Header ----
                          _buildFieldLabel(Icons.location_on_outlined, "Location"),
                          const SizedBox(height: 10),

                          // Container(
                          //   padding: const EdgeInsets.all(10),
                          //   decoration: BoxDecoration(
                          //     color: Colors.green.withValues(alpha: 0.05),
                          //     borderRadius: BorderRadius.circular(8),
                          //   ),
                          //   child: const Row(
                          //     children: [
                          //       Icon(Icons.check_circle, color: Colors.green, size: 16),
                          //       SizedBox(width: 6),
                          //       Expanded(
                          //         child: Text(
                          //           "We've detected your location automatically.\nYou can edit the details if needed.",
                          //           style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w500),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(height: 14),

                          // ---- Country ----
                          _buildDropdownLabel("Country"),
                          const SizedBox(height: 4),
                          _buildLocationDropdown<Country>(
                            value: _selectedCountry,
                            items: _countries,
                            itemLabel: (Country c) => c.name,
                            loading: _loadingCountries,
                            placeholder: "Select a country",
                            prefixIcon: const Text("🇮🇳", style: TextStyle(fontSize: 16)),
                            onChanged: _onCountryChanged,
                          ),
                          const SizedBox(height: 14),

                          // ---- State ----
                          _buildDropdownLabel("State"),
                          const SizedBox(height: 4),
                          _buildLocationDropdown<Models.State>(
                            value: _selectedState,
                            items: _states,
                            itemLabel: (Models.State s) => s.name,
                            loading: _loadingStates,
                            placeholder: _selectedCountry == null ? "Select a country first" : "Select a state",
                            disabled: _selectedCountry == null,
                            prefixIcon: Icon(Icons.account_balance_outlined, size: 16, color: Colors.grey.shade500),
                            onChanged: _onStateChanged,
                          ),
                          const SizedBox(height: 14),

                          // ---- District & City (Side-by-Side Dropdowns) ----
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // District Dropdown
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDropdownLabel("District"),
                                    const SizedBox(height: 4),
                                    _buildLocationDropdown<District>(
                                      value: _selectedDistrict,
                                      items: _districts,
                                      itemLabel: (District d) => d.name,
                                      loading: _loadingDistricts,
                                      placeholder: _selectedState == null ? "Select state" : "Select district",
                                      disabled: _selectedState == null,
                                      prefixIcon: Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
                                      onChanged: _onDistrictChanged,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // City Dropdown
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDropdownLabel("City"),
                                    const SizedBox(height: 4),
                                    _buildLocationDropdown<City>(
                                      value: _selectedCity,
                                      items: _cities,
                                      itemLabel: (City c) => c.name,
                                      loading: _loadingCities,
                                      placeholder: _selectedDistrict == null ? "Select district" : "Select city",
                                      disabled: _selectedDistrict == null,
                                      prefixIcon: Icon(Icons.location_city_outlined, size: 16, color: Colors.grey.shade500),
                                      onChanged: _onCityChanged,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ---- Area / Pincode ----
                          _buildDropdownLabel("Pincode / Area"),
                          const SizedBox(height: 4),
                          _buildLocationDropdown<Area>(
                            value: _selectedArea,
                            items: _areas,
                            itemLabel: (Area a) => '${a.name} (${a.pincode})',
                            loading: _loadingAreas,
                            placeholder: _selectedCity == null ? "Select a city first" : "Select an area",
                            disabled: _selectedCity == null,
                            prefixIcon: Icon(Icons.pin_drop_outlined, size: 16, color: Colors.grey.shade500),
                            onChanged: (area) => setState(() => _selectedArea = area),
                          ),
                          const SizedBox(height: 12),

                          // ---- Change Location ----
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: TextButton.icon(
                          //     onPressed: () {},
                          //     icon: const Icon(Icons.edit_outlined, size: 14, color: Colors.green),
                          //     label: const Text(
                          //       "Change Location",
                          //       style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 6),

                          // Location Summary Info Banner
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: Colors.green, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _selectedCountry == null
                                        ? "We'll use your location to show you relevant listings and better match opportunities."
                                        : _locationSummary,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedCountry == null ? Colors.grey : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ---- Continue Button ----
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F9D1E),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 0,
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  // Continue navigation routing setup
                                }
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 18),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_outline, size: 12, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(
                                "Your information is safe and secure with us.",
                                style: TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  //  Location Dropdown component helper
  // -------------------------------------------------------

  Widget _buildLocationDropdown<T>({
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required bool loading,
    required String placeholder,
    required ValueChanged<T?> onChanged,
    bool disabled = false,
    Widget? prefixIcon,
  }) {
    if (loading) {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green),
          ),
        ),
      );
    }

    final bool valueIsInItems = value != null && items.contains(value);

    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: DropdownButtonFormField<T>(
        isExpanded: true,
        value: valueIsInItems ? value : null,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(itemLabel(item), style: const TextStyle(fontSize: 13, color: Colors.black87)),
          );
        }).toList(),
        onChanged: disabled ? null : onChanged,
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
        dropdownColor: Colors.white,
        style: const TextStyle(overflow: TextOverflow.ellipsis),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.normal),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          prefixIcon: prefixIcon != null
              ? Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: prefixIcon)
              : null,
          prefixIconConstraints: prefixIcon != null
              ? const BoxConstraints(minWidth: 36, minHeight: 36)
              : null,
          filled: true,
          fillColor: disabled ? Colors.grey.shade50 : Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.green, width: 1.2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  //  UI Layout Elements Helpers
  // -------------------------------------------------------

  Widget _buildStepDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: isActive ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade700 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildFieldLabel(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.green.shade600),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }

  Widget _buildDropdownLabel(String title) {
    return Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500));
  }

  InputDecoration _buildInputDecoration({Widget? prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.green, width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}