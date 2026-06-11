import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      assetsTitle: 'assets/images/onboarding1.png',
      titleNormal: 'One Platform\n',
      titleAccent: 'Endless Opportunities.',
      subtitle: 'Buy and sell agri, aqua, meat and dairy products. All in one place.',
    ),
    _OnboardingPage(
      assetsTitle: 'assets/images/onboarding2.png',
      titleNormal: 'Connect. Trade.\n',
      titleAccent: 'Grow Together.',
      subtitle: 'Connect with verified buyers and sellers from around the world.',
    ),
    _OnboardingPage(
      assetsTitle: 'assets/images/onboarding3.png',
      titleNormal: 'Trusted. Secure,\n',
      titleAccent: 'Always.',
      subtitle: 'Connect with verified buyers and sellers from around the world.',
    ),
  ];

  // Perfected background colors sampled directly from image_0158a7.png
  static const Color _bgGradientTop = Color(0xFFF7F9FA);
  static const Color _bgGradientBottom = Color(0xFFFAF9F6);
  static const Color _primaryGreen = Color(0xFF0F5126);
  static const Color _accentGreen = Color(0xFF1B7A3D);
  static const Color _textDark = Color(0xFF1E293B);
  static const Color _textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Replacing the solid background with a structural container for the exact canvas gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _bgGradientTop,
              _bgGradientBottom,
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Content Slider
            PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _pages.length,
              itemBuilder: (context, index) => _buildPage(_pages[index]),
              physics: const BouncingScrollPhysics(), // Smoother native swipe feel
            ),

            // Skip Button
            Positioned(
              top: 52,
              right: 24,
              child: TextButton(
                onPressed: _goToLogin,
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory, // Keeps the design clean on tap
                ),
                child: Text(
                  'Skip',
                  style: GoogleFonts.poppins(
                    color: _accentGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Bottom Controls (Dots & Buttons)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicator Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) => _buildDot(i)),
                  ),
                  const SizedBox(height: 36),

                  // Dynamic Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _goToLogin();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryGreen,
                          foregroundColor: Color(0xFFFAF9F5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_ios, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bottom Login Redirection Link
                  GestureDetector(
                    onTap: _goToLogin,
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(fontSize: 14, color: _textMuted),
                        children: const [
                          TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: _primaryGreen,
                              fontWeight: FontWeight.w700,
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

  Widget _buildPage(_OnboardingPage page) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Illustration Box
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Image.asset(
                page.assetsTitle,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback container placeholder if paths change/assets are missing
                  return Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 80, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),

          // Typography Grouping
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(text: page.titleNormal, style: const TextStyle(color: _textDark)),
                        TextSpan(text: page.titleAccent, style: const TextStyle(color: _accentGreen)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    page.subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: _textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isSelected = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isSelected ? _primaryGreen : Colors.black12,
        shape: BoxShape.circle,
      ),
    );
  }

  void _goToLogin() {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const LoginScreen()),
    // );
    Navigator.pushReplacementNamed(
      context,
      '/login',
    );
  }
}

class _OnboardingPage {
  final String assetsTitle;
  final String titleNormal;
  final String titleAccent;
  final String subtitle;

  const _OnboardingPage({
    required this.assetsTitle,
    required this.titleNormal,
    required this.titleAccent,
    required this.subtitle,
  });
}