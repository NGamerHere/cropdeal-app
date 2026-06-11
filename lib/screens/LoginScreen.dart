import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/GoogleIconPainter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (i) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (i) => FocusNode());

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocusNodes) f.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/login_bg.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),

                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 110),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/LoginBgIcon.png',
                              width:180,
                              height:180,
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Connect. Trade. Grow.',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "India's trusted marketplace for\nfarmers and agri business.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ─── Entry Form Sheet ───
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Mobile Number',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "We'll send you a 6-digit OTP",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),

                  // Phone Input Field
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF2E7D32), width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            children: [
                              Text('+91',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87)),
                              const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black54),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 24, color: Colors.black12),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'Enter Mobile Number',
                              hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                              suffixIcon: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Resend OTP',
                                  style: TextStyle(
                                    color: const Color(0xFFD32F2F),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    'Enter OTP',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enter the 6-digit code sent to your mobile number',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 18),

                  // OTP Entry Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 44,
                        height: 52,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          onChanged: (value) => _onOtpChanged(value, index),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: const Color(0xFFF8F9FA),
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF1B4D3E), width: 2),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),

                  // Submission Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _goToApp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B4D3E),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Submit & Continue',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Federated Divider Splitter
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.black12)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Login With Google',
                          style: TextStyle(fontSize: 13, color: Colors.black45, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.black12)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Google Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _goToApp,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black12),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(20, 20),
                            painter: GoogleIconPainter(),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Terms & Privacy Note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified_user_outlined, size: 16, color: Color(0xFF2E7D32)),
                      const SizedBox(width: 6),
                      Text(
                        'Your Data is safe and secure with us.',
                        style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(fontSize: 12, color: Colors.black45, height: 1.4),
                        children: [
                          const TextSpan(text: 'By continuing, you agree to our \n'),
                          TextSpan(
                            text: 'Terms & Privacy Policy',
                            style: const TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToApp() {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
    // );
  }
}