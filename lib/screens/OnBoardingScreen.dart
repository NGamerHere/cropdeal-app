import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // Mock field values matching UI
  String selectedUserType = 'Both (Seller & Buyer)';
  String selectedBusinessType = 'Farmer';
  String selectedCountry = 'India';
  String selectedState = 'Telangana';
  String selectedDistrict = 'Warangal';

  final TextEditingController _nameController = TextEditingController(text: "Ramesh Kumar");
  final TextEditingController _phoneController = TextEditingController(text: "99592 88004");
  final TextEditingController _pincodeController = TextEditingController(text: "533003");
  final TextEditingController _mandalController = TextEditingController(text: "Hanamkonda");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Header Graphic
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              'assets/images/login_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    // CropDeal Logo
                    Image.asset(
                      'assets/images/LoginBgIcon.png',
                      width: 140,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    // Step Progress Marker Indicator (Step 2 of 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Step 2 of 3 ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
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
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Tell us a few details to personalize\nyour HARVEX experience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 130),

                    // --- Main Card Form Container ---
                    Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
                      margin: const EdgeInsets.only(bottom: 25.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Full Name Field
                          _buildFieldLabel(Icons.person_outline, "Full Name"),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _nameController,
                            decoration: _buildInputDecoration(
                              suffixIcon: const Icon(Icons.edit_outlined, color: Colors.green, size: 20),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Mobile Number Field
                          _buildFieldLabel(Icons.phone_outlined, "Mobile Number"),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    // Simulated India Flag Icon
                                    const SizedBox(width: 6),
                                    const Text("+91", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    const Icon(Icons.arrow_drop_down, size: 18, color: Colors.grey),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: _buildInputDecoration(
                                    suffixIcon: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Verified", style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
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
                          const SizedBox(height: 18),

                          // User Type Dropdown
                          _buildFieldLabel(Icons.people_outline, "User Type"),
                          const SizedBox(height: 6),
                          _buildDropdownField(
                            value: selectedUserType,
                            items: ['Both (Seller & Buyer)', 'Seller Only', 'Buyer Only'],
                            onChanged: (val) => setState(() => selectedUserType = val!),
                          ),
                          const SizedBox(height: 18),

                          // Business / User Sub-Type Dropdown
                          _buildFieldLabel(Icons.business_center_outlined, "User Type"),
                          const SizedBox(height: 6),
                          _buildDropdownField(
                            value: selectedBusinessType,
                            items: ['Farmer', 'Trader', 'Agri Business Owner'],
                            onChanged: (val) => setState(() => selectedBusinessType = val!),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 6.0, left: 4),
                            child: Text(
                              "Choose the option that best describes your business",
                              style: TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Location Sub-Section Header
                          _buildFieldLabel(Icons.location_on_outlined, "Location"),
                          const SizedBox(height: 8),

                          // Location auto-detected badge notice
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "We've detected your location automatically",
                                        style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "You can still edit the details if needed.",
                                        style: TextStyle(color: Colors.grey, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Country Dropdown
                          const Text("Country", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          _buildDropdownField(
                            value: selectedCountry,
                            items: ['India', 'United States', 'Other'],
                            onChanged: (val) => setState(() => selectedCountry = val!),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.flag_outlined, size: 20),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // State Dropdown
                          const Text("State", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          _buildDropdownField(
                            value: selectedState,
                            items: ['Telangana', 'Andhra Pradesh', 'Maharashtra', 'Karnataka'],
                            onChanged: (val) => setState(() => selectedState = val!),
                            prefixIcon: const Icon(Icons.location_city, size: 20, color: Colors.grey),
                          ),
                          const SizedBox(height: 14),

                          // District & Mandal Split Row Layout
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("District", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    _buildDropdownField(
                                      value: selectedDistrict,
                                      items: ['Warangal', 'Hyderabad', 'Nizamabad'],
                                      onChanged: (val) => setState(() => selectedDistrict = val!),
                                      prefixIcon: const Icon(Icons.pin_drop_outlined, size: 18, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Mandal / City", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    const SizedBox(height: 4),
                                    TextFormField(
                                      controller: _mandalController,
                                      decoration: _buildInputDecoration(
                                        prefixIcon: const Icon(Icons.storefront, size: 18, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Pincode Input
                          const Text("Pincode", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          _buildDropdownField(
                            value: selectedState == 'Telangana' ? '533003' : '500001',
                            items: ['533003', '500001', '506001'],
                            onChanged: (val) {},
                            prefixIcon: const Icon(Icons.local_post_office_outlined, size: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),

                          // Change Location Text Trigger Link
                          Center(
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit, size: 14, color: Colors.green),
                              label: const Text(
                                "Change Location",
                                style: TextStyle(color: Colors.green, fontSize: 13, decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Location usage info note banner text
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.green, size: 16),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "We'll use your location to show you relevant listings and better match opportunities.",
                                    style: TextStyle(fontSize: 10, color: Colors.black87),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Primary Continue Button Actions
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F9D1E), // Vivid Green
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {},
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
                          const SizedBox(height: 16),

                          // Safety verification subtitle label text
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

  // Helper builder methods for structured uniform UI layout
  Widget _buildStepDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: isActive ? 22 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildFieldLabel(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.green),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }

  InputDecoration _buildInputDecoration({Widget? prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.green, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    Widget? prefixIcon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 14, color: Colors.black)),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: _buildInputDecoration(prefixIcon: prefixIcon),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      dropdownColor: Colors.white,
    );
  }
}