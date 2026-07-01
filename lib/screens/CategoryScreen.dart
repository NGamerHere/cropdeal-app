import 'package:cropdeal/main.dart' as app;
import 'package:cropdeal/models/Category.dart';
import 'package:cropdeal/models/Product.dart';
import 'package:cropdeal/services/ApiClient.dart';
import 'package:cropdeal/stateNotifiers/AppConfigNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  final ApiClient _apiClient = ApiClient(navigatorKey: app.navigatorKey);

  List<Category> _mainCategories = [];
  Category? _selectedMainCategory;
  Category? _selectedSubCategory;
  List<Product> _products = [];
  final Set<int> _selectedProductIds = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  bool _isLoadingCategories = true;
  bool _isLoadingProducts = false;
  bool _isSubmitting = false;

  // ── Design tokens (matching Figma) ──
  static const _bgColor      = Color(0xFFF5F7F2);
  static const _primaryGreen = Color(0xFF1B5E20);
  static const _accentGreen  = Color(0xFF2E7D32);
  static const _chipGreen    = Color(0xFF4CAF50);
  static const _sidebarBg   = Color(0xFFFFFFFF);
  static const _sidebarSelBg = Color(0xFFF1F8E9);
  static const _textDark     = Color(0xFF1C2B1E);
  static const _textMuted    = Color(0xFF78909C);
  static const _divider      = Color(0xFFE0E0E0);
  static const _sidebarWidth = 88.0;

  // ── Stock photo fallbacks per category keyword (Unsplash) ──
  // Used when category.imageUrl is null/empty.
  static const Map<String, String> _catStockPhotos = {
    'crop':       'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=200&q=80',
    'crops':      'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=200&q=80',
    'aqua':       'https://images.unsplash.com/photo-1534043464124-3be32fe000c9?w=200&q=80',
    'aquaculture':'https://images.unsplash.com/photo-1534043464124-3be32fe000c9?w=200&q=80',
    'livestock':  'https://images.unsplash.com/photo-1527153818091-1a9638521e2a?w=200&q=80',
    'live stock': 'https://images.unsplash.com/photo-1527153818091-1a9638521e2a?w=200&q=80',
    'dairy':      'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=200&q=80',
    'fertilizer': 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=200&q=80',
    'seeds':      'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=200&q=80',
    'vegetables': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200&q=80',
    'fruits':     'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=200&q=80',
    'poultry':    'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=200&q=80',
  };

  // Icon fallback (used only when image also fails to load)
  static const Map<String, IconData> _catIcons = {
    'crop':       Icons.eco_rounded,
    'aqua':       Icons.set_meal_rounded,
    'livestock':  Icons.pets_rounded,
    'live stock': Icons.pets_rounded,
    'dairy':      Icons.local_drink_rounded,
    'fertilizer': Icons.science_rounded,
  };

  // Tint colour for the fallback icon circle
  static const Map<String, Color> _catColors = {
    'crop':       Color(0xFF43A047),
    'aqua':       Color(0xFF0288D1),
    'livestock':  Color(0xFF8D6E63),
    'live stock': Color(0xFF8D6E63),
    'dairy':      Color(0xFFFFA726),
    'fertilizer': Color(0xFF7B1FA2),
  };

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Helpers ──

  /// Returns the best image URL for a category:
  /// 1. category.imageUrl (from API)
  /// 2. Stock photo mapped by category name keyword
  /// 3. null → show icon fallback
  String? _imageUrlFor(Category cat) {
    if (cat.imageKey != null && cat.imageKey!.isNotEmpty) return cat.imageKey;
    final key = cat.name.toLowerCase();
    // Try exact match first, then partial match
    if (_catStockPhotos.containsKey(key)) return _catStockPhotos[key];
    for (final entry in _catStockPhotos.entries) {
      if (key.contains(entry.key) || entry.key.contains(key)) return entry.value;
    }
    return null;
  }

  /// Circular image widget used in both the sidebar and subcategory chips.
  ///
  /// [size]       — diameter of the circle
  /// [cat]        — category to resolve image/icon for
  /// [selected]   — whether to show the selection border
  /// [borderColor]— color of the selection ring
  Widget _buildCategoryCircle({
    required double size,
    required Category cat,
    required bool selected,
    Color borderColor = _chipGreen,
  }) {
    final imageUrl = _imageUrlFor(cat);
    final key = cat.name.toLowerCase();
    final tint = _catColors[key] ?? _accentGreen;
    final icon = _catIcons[key] ?? Icons.category_rounded;

    final border = selected
        ? Border.all(color: borderColor, width: 2.5)
        : Border.all(color: _divider, width: 1.5);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border,
        color: tint.withOpacity(0.1),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null
          ? CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildImagePlaceholder(size, tint),
        errorWidget: (context, url, error) => _buildIconFallback(icon, tint),
      )
          : _buildIconFallback(icon, tint),
    );
  }

  Widget _buildImagePlaceholder(double size, Color tint) {
    return Container(
      color: tint.withOpacity(0.08),
      child: Center(
        child: SizedBox(
          width: size * 0.35,
          height: size * 0.35,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: tint.withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  Widget _buildIconFallback(IconData icon, Color tint) {
    return Center(child: Icon(icon, color: tint, size: 22));
  }

  Widget _defaultAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _accentGreen.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: _accentGreen, size: 20),
    );
  }

  // ── Data ──

  Future<void> _fetchCategories() async {
    setState(() => _isLoadingCategories = true);
    try {
      final response = await _apiClient.get('/api/category');
      final all = (response.data as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() {
        _mainCategories = all.where((c) => c.parentCategoryId == null).toList();
        _isLoadingCategories = false;
      });
      if (_mainCategories.isNotEmpty) _selectMainCategory(_mainCategories.first);
    } catch (e) {
      setState(() => _isLoadingCategories = false);
      debugPrint('fetch categories error: $e');
    }
  }

  void _selectMainCategory(Category cat) {
    setState(() {
      _selectedMainCategory = cat;
      _selectedSubCategory  = null;
      _products             = [];
      _searchQuery          = '';
      _searchController.clear();
    });
    if (cat.subCategories.isNotEmpty) _selectSubCategory(cat.subCategories.first);
  }

  void _selectSubCategory(Category sub) {
    setState(() {
      _selectedSubCategory = sub;
      _products            = [];
      _searchQuery         = '';
      _searchController.clear();
    });
    _fetchProducts(sub.id);
  }

  Future<void> _fetchProducts(int categoryId) async {
    setState(() => _isLoadingProducts = true);
    try {
      final response = await _apiClient.get('/api/products', queryParams: {
        'page': 1, 'limit': 100, 'categoryId': categoryId,
      });
      final data = response.data as Map<String, dynamic>;
      final list = data['products'] as List<dynamic>;
      setState(() {
        _products = list
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();
        _isLoadingProducts = false;
      });
    } catch (e) {
      setState(() => _isLoadingProducts = false);
      debugPrint('fetch products error: $e');
    }
  }

  void _toggleProduct(int id) {
    setState(() {
      _selectedProductIds.contains(id)
          ? _selectedProductIds.remove(id)
          : _selectedProductIds.add(id);
    });
  }

  Future<void> _submitInterests() async {
    if (_selectedProductIds.isEmpty) {
      _showSnack('Select at least one product');
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await _apiClient.post(
        '/api/userinterests/products',
        data: {'productIds': _selectedProductIds.toList()},
      );
      if (!mounted) return;
      _showSnack('Interests saved!');
      Navigator.pushReplacementNamed(context, '/login');
    } catch (_) {
      if (mounted) _showSnack('Submission failed. Try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: _accentGreen,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Filtered + grouped products ──

  List<Product> get _filteredProducts {
    if (_searchQuery.isEmpty) return _products;
    final q = _searchQuery.toLowerCase();
    return _products.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  List<dynamic> get _groupedItems {
    final sorted = List<Product>.from(_filteredProducts)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final result = <dynamic>[];
    String? lastLetter;
    for (final p in sorted) {
      final letter = p.name[0].toUpperCase();
      if (letter != lastLetter) {
        result.add(letter);
        lastLetter = letter;
      }
      result.add(p);
    }
    return result;
  }

  // ─────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoadingCategories
                  ? const Center(child: CircularProgressIndicator(color: _accentGreen))
                  : _mainCategories.isEmpty
                  ? const Center(child: Text('No categories found'))
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSidebar(),
                  const VerticalDivider(width: 1, thickness: 1, color: _divider),
                  Expanded(child: _buildMainContent()),
                ],
              ),
            ),
            if (!_isLoadingCategories) _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ── Top header ──

  Widget _buildHeader() {
    final user = ref.watch(appConfigProvider).user;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: user.profilePhoto != null
                        ? CachedNetworkImage(
                            imageUrl: user.profilePhoto!,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              width: 36,
                              height: 36,
                              color: Colors.grey.shade200,
                            ),
                            errorWidget: (_, __, ___) => _defaultAvatar(),
                          )
                        : _defaultAvatar(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi ${user.name.split(' ').first} 👋',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _textDark,
                          ),
                        ),
                        Text(
                          'Select the products you deal with',
                          style: const TextStyle(
                            fontSize: 12,
                            color: _textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(22),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(fontSize: 14, color: _textDark),
              decoration: InputDecoration(
                hintText: 'Search Here',
                hintStyle: const TextStyle(color: _textMuted, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: _textMuted, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                  onTap: () => setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                  }),
                  child: const Icon(Icons.close, color: _textMuted, size: 18),
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'What are you Interested in?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _textDark,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Select the products you deal with or are interested in.\nYou can add more later.',
            style: TextStyle(fontSize: 12.5, color: _textMuted, height: 1.45),
          ),
        ],
      ),
    );
  }

  // ── Left sidebar ──

  Widget _buildSidebar() {
    return Container(
      width: _sidebarWidth,
      color: _sidebarBg,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _mainCategories.length,
        itemBuilder: (_, i) {
          final cat      = _mainCategories[i];
          final selected = cat.id == _selectedMainCategory?.id;

          return GestureDetector(
            onTap: () => _selectMainCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: selected ? _sidebarSelBg : Colors.transparent,
                border: selected
                    ? const Border(left: BorderSide(color: _chipGreen, width: 3))
                    : const Border(left: BorderSide(color: Colors.transparent, width: 3)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCategoryCircle(
                    size: 48,
                    cat: cat,
                    selected: selected,
                    borderColor: selected ? _chipGreen : _divider,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? _primaryGreen : _textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Main right content ──

  Widget _buildMainContent() {
    if (_selectedMainCategory == null) {
      return const Center(child: Text('Select a category'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubCategoryRow(),
        if (_selectedSubCategory != null) ...[
          const Divider(height: 1, thickness: 1, color: _divider),
          _buildProductSearchBar(),
        ],
        const Divider(height: 1, thickness: 1, color: _divider),
        Expanded(child: _buildProductList()),
      ],
    );
  }

  // ── Subcategory horizontal chips ──

  Widget _buildSubCategoryRow() {
    final subs = _selectedMainCategory?.subCategories ?? [];
    if (subs.isEmpty) return const SizedBox(height: 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          child: Text(
            '${_selectedMainCategory!.name} Categories',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
        ),
        SizedBox(
          height: 96,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: subs.length,
            itemBuilder: (_, i) {
              final sub      = subs[i];
              final selected = sub.id == _selectedSubCategory?.id;
              return GestureDetector(
                onTap: () => _selectSubCategory(sub),
                child: Container(
                  width: 76,
                  margin: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      _buildCategoryCircle(
                        size: 62,
                        cat: sub,
                        selected: selected,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        sub.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? _chipGreen : _textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // ── Inline product search bar ──

  Widget _buildProductSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _divider),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v),
          style: const TextStyle(fontSize: 13, color: _textDark),
          decoration: const InputDecoration(
            hintText: 'Choose Your Product',
            hintStyle: TextStyle(color: _textMuted, fontSize: 13),
            prefixIcon: Icon(Icons.search, color: _textMuted, size: 18),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 11),
          ),
        ),
      ),
    );
  }

  // ── Alphabetically grouped product list ──

  Widget _buildProductList() {
    if (_isLoadingProducts) {
      return const Center(child: CircularProgressIndicator(color: _accentGreen));
    }

    final items = _groupedItems;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: _textMuted.withOpacity(.5)),
            const SizedBox(height: 10),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No results for "$_searchQuery"'
                  : 'No products here',
              style: const TextStyle(color: _textMuted, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedSubCategory != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 2),
            child: Text(
              'More ${_selectedSubCategory!.name}',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final item = items[i];
              if (item is String) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _chipGreen,
                    ),
                  ),
                );
              }
              final product  = item as Product;
              final selected = _selectedProductIds.contains(product.id);
              return _buildProductRow(product, selected);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductRow(Product product, bool selected) {
    return InkWell(
      onTap: () => _toggleProduct(product.id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
        ),
        child: Row(
          children: [
            // Product image circle — uses product.imageUrl if available
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE8F5E9),
              ),
              clipBehavior: Clip.antiAlias,
              child: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  ? CachedNetworkImage(
                imageUrl: product.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: _accentGreen,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => const Icon(
                  Icons.eco_rounded,
                  color: _accentGreen,
                  size: 18,
                ),
              )
                  : const Icon(Icons.eco_rounded, color: _accentGreen, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                  if (product.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: 11.5, color: _textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? _accentGreen : Colors.transparent,
                border: Border.all(
                  color: selected ? _accentGreen : const Color(0xFFBDBDBD),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom bar ──

  Widget _buildBottomBar() {
    final count = _selectedProductIds.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _divider)),
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: count > 0
                ? Row(
              key: ValueKey(count),
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accentGreen,
                  ),
                  child: const Icon(Icons.check_rounded,
                      size: 20, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$count Selected',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    const Text(
                      'You Can select more later',
                      style: TextStyle(fontSize: 10.5, color: _textMuted),
                    ),
                  ],
                ),
              ],
            )
                : const SizedBox.shrink(key: ValueKey(0)),
          ),
          const Spacer(),
          SizedBox(
            height: 46,
            child: FilledButton.icon(
              onPressed: _isSubmitting || count == 0 ? null : _submitInterests,
              style: FilledButton.styleFrom(
                backgroundColor: _primaryGreen,
                disabledBackgroundColor: const Color(0xFFBDBDBD),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isSubmitting
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
                  : const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(
                _isSubmitting ? 'Saving…' : 'Continue',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}