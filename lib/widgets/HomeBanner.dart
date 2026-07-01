import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    const double bannerWidth = 360.0;
    const double bannerHeight = 160.0;

    return SizedBox(
      width: bannerWidth,
      height: bannerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: bannerWidth,
            height: bannerHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF2C7A39),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 10,
                          top: 0,
                          bottom: 0,
                          child: Image.asset(
                            height: 200,
                            width: 180,
                            'assets/images/homePage/header_background.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -8,
            bottom: 0,
            top: -5,
            child: Image.asset(
              height: 250,
              width: 200,
              'assets/images/FarmerImage.png',
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            right: 0,
            height: bannerHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Feeding The World\nWith Consistency.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "We are committed to build long \n lasting partnerships with our clients \n founded on trust to foster growth.",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 05),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD51A),
                            foregroundColor: const Color(0xFF0D3E16),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Explore Now",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}