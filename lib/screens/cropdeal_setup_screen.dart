import 'package:flutter/material.dart';

class CropDealSetupScreen extends StatefulWidget {
  const CropDealSetupScreen({Key? key}) : super(key: key);

  @override
  State<CropDealSetupScreen> createState() => _CropDealSetupScreenState();
}

class _CropDealSetupScreenState extends State<CropDealSetupScreen> {
  // Dropdown states
  String selectedCountry = 'India';
  String selectedLanguage = 'Hindi';
  String selectedCurrency = 'INR (₹)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/top_illustration.png',
                height: 220,
                fit: .cover,
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/crop_deal_logo.png',
                height: 70,
              ),
              const SizedBox(height: 25),
              _buildDropdownCard(
                title: 'Country',
                backgroundColor: const Color(0xFFF1FDF3),
                iconColor: const Color(0xFF00A624),
                icon: Icons.public,
                child: _buildDropdownButton(
                  value: selectedCountry,
                  items: ['India', 'USA', 'UK'],
                  onChanged: (val) => setState(() => selectedCountry = val!),
                  prefix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.white, Colors.green],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              _buildDropdownCard(
                title: 'Language',
                backgroundColor: const Color(0xFFF7F3FF),
                iconColor: const Color(0xFF5E27B6),
                icon: Icons.translate,
                child: _buildDropdownButton(
                  value: selectedLanguage,
                  items: ['Hindi', 'English', 'Telugu'],
                  onChanged: (val) => setState(() => selectedLanguage = val!),
                  prefix: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.g_translate, size: 18, color: Color(0xFF5E27B6)),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _buildDropdownCard(
                title: 'Currency',
                backgroundColor: const Color(0xFFFFF6EE),
                iconColor: const Color(0xFFF37021),
                icon: Icons.currency_exchange,
                child: _buildDropdownButton(
                  value: selectedCurrency,
                  items: ['INR(₹)', 'USD(\$)', 'EUR(€)'],
                  onChanged: (val) => setState(() => selectedCurrency = val!),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('Country', selectedCountry, Icons.public, const Color(0xFF00A624)),
                    _buildDivider(),
                    _buildSummaryItem('Language', selectedLanguage, Icons.translate, const Color(0xFF5E27B6)),
                    _buildDivider(),
                    _buildSummaryItem('Currency', selectedCurrency.split(' ')[0], Icons.currency_exchange, const Color(0xFFF37021)),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009919),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 18, color: Colors.green),
                  const SizedBox(width: 6),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black87, fontSize: 13),
                      children: [
                        TextSpan(text: 'You Can change these setting later in '),
                        TextSpan(
                          text: 'Profile',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card Builder Helper
  Widget _buildDropdownCard({
    required String title,
    required Color backgroundColor,
    required Color iconColor,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Left Icon Container
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          // Dropdown content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dropdown Button Customizer
  Widget _buildDropdownButton({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    Widget? prefix,
  }) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Row(
                children: [
                  if (prefix != null) prefix,
                  Text(
                    val,
                    style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Summary Row Sub-Items
  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color,
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade200,
    );
  }
}