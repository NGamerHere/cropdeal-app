import 'package:flutter/material.dart';

/// ============================================================
/// Top-level widget that reproduces the screenshot using your
/// actual PNG assets from assets/images/homePage/
///
/// 1. Category icons row (Crop, Aqua, Meat, Dairy, Settings)
/// 2. Segmented tab bar (All Posts / Sell / Buy / Services)
/// 3. Stats row (4 stat cards)
/// 4. "Post Your Listing" CTA banner
///
/// Make sure your pubspec.yaml declares:
///   flutter:
///     assets:
///       - assets/images/homePage/
/// ============================================================
class MarketplaceHeader extends StatefulWidget {
  const MarketplaceHeader({super.key});

  @override
  State<MarketplaceHeader> createState() => _MarketplaceHeaderState();
}

class _MarketplaceHeaderState extends State<MarketplaceHeader> {
  int _selectedTab = 0; // 0=All, 1=Sell, 2=Buy, 3=Services

  static const Color primaryGreen = Color(0xFF1F7A3D);
  static const Color lightGreenBg = Color(0xFFEFF7EF);
  static const String _assetPath = 'assets/images/homePage/';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _buildCategoryRow(),
          const SizedBox(height: 12),
          _buildTabBar(),
          const SizedBox(height: 10),
          _buildStatsRow(),
          const SizedBox(height: 10),
          _buildPostBanner(context),
        ],
      ),
    );
  }

  // ---------------- Category icons row ----------------
  Widget _buildCategoryRow() {
    final categories = [
      _CategoryItem(label: 'Crop', asset: 'crop_icon.png', bg: const Color(0xFFDFF3E1)),
      _CategoryItem(label: 'Aqua', asset: 'aqua_icon.png', bg: const Color(0xFFDCEEF9)),
      _CategoryItem(label: 'Meat', asset: 'live_stock_icon.png', bg: const Color(0xFFFBE0DE)),
      _CategoryItem(label: 'Dairy', asset: 'diary_icon.png', bg: const Color(0xFFE6DFF7)),
      _CategoryItem(label: 'Settings', asset: 'setting_icon.png', bg: const Color(0xFFFCF3D8)),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories.map((c) => _categoryIcon(c)).toList(),
    );
  }

  Widget _categoryIcon(_CategoryItem item) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: item.bg,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(9),
          child: Image.asset(
            '$_assetPath${item.asset}',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          item.label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ---------------- Segmented tab bar ----------------
  Widget _buildTabBar() {
    final tabs = [
      _TabItem(asset: 'all_post_icon.png', title: 'All', subtitle: 'All Posts'),
      _TabItem(asset: 'sell_listing_icon.png', title: 'Sell', subtitle: 'Sell Listings'),
      _TabItem(asset: 'buy_listing_icon.png', title: 'Buy', subtitle: 'Buy Requests'),
      _TabItem(asset: 'services_listing_icon.png', title: 'Services', subtitle: 'Service Posts'),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: lightGreenBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = index == _selectedTab;
          final tab = tabs[index];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      '$_assetPath${tab.asset}',
                      width: 35,
                      height: 20,
                      color: selected ? Colors.white : Colors.black54,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      tab.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: selected ? Colors.white70 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------- Stats row ----------------
  Widget _buildStatsRow() {
    final stats = [
      _StatItem(asset: 'active_seller_icon.png', value: '12.5K+', label: 'Active Sellers', color: const Color(0xFF2E7D32)),
      _StatItem(asset: 'active_buyer_icon.png', value: '8.2K', label: 'Active Buyers', color: const Color(0xFF1976D2)),
      _StatItem(asset: 'daily_listing_icon.png', value: '25K+', label: 'Daily Listings', color: const Color(0xFFF9A825)),
      _StatItem(asset: null, fallbackIcon: Icons.verified_user_rounded, value: '98%', label: 'Trust Rate', color: const Color(0xFF2E7D32)),
    ];

    return Row(
      children: stats
          .map((s) => Expanded(child: _statCard(s)))
          .toList(),
    );
  }

  Widget _statCard(_StatItem stat) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          stat.asset != null
              ? Image.asset(
            '$_assetPath${stat.asset}',
            width: 16,
            height: 16,
            color: stat.color,
            fit: BoxFit.contain,
          )
              : Icon(stat.fallbackIcon, color: stat.color, size: 16),
          const SizedBox(height: 3),
          Text(
            stat.value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: stat.color,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            stat.label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 8, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ---------------- Post banner CTA ----------------
  Widget _buildPostBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: lightGreenBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            padding: const EdgeInsets.all(7),
            child: Image.asset(
              '${_assetPath}post_listing_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post Your Listing',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(height: 1),
                const Text(
                  "It's quick easy and free",
                  style: TextStyle(fontSize: 9, color: Colors.black54),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: navigate to post listing screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF6C90E),
              foregroundColor: Colors.black87,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 14),
                SizedBox(width: 3),
                Text('Post Now',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- Data models ----------------
class _CategoryItem {
  final String label;
  final String asset;
  final Color bg;
  _CategoryItem({
    required this.label,
    required this.asset,
    required this.bg,
  });
}

class _TabItem {
  final String asset;
  final String title;
  final String subtitle;
  _TabItem({required this.asset, required this.title, required this.subtitle});
}

class _StatItem {
  final String? asset;
  final IconData? fallbackIcon;
  final String value;
  final String label;
  final Color color;
  _StatItem({
    this.asset,
    this.fallbackIcon,
    required this.value,
    required this.label,
    required this.color,
  });
}