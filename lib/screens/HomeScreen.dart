import 'package:cropdeal/widgets/CropDealHeader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ListingScreen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ListingScreen(),
    //Center(child: Text("hello there")),
    Center(child: Text("Messages")),
    Center(child: Text("Add Post")),
    Center(child: Text("My Posts")),
    Center(child: Text("My Accounts")),
  ];

  void _changePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: Stack(
        children: [
          Column(
            children: [
              CropDealHeader(),
              Expanded(
                child: _pages[_selectedIndex],
              ),
            ],
          ),

          /// Bottom Navigation
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 82,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black12,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    _navItem(
                      icon: Icons.home_outlined,
                      label: "Home",
                      index: 0,
                    ),
                    _navItem(
                      icon: Icons.chat_bubble_outline,
                      label: "Messages",
                      index: 1,
                    ),

                    const SizedBox(width: 75),

                    _navItem(
                      icon: Icons.article_outlined,
                      label: "My Posts",
                      index: 3,
                    ),
                    _navItem(
                      icon: Icons.person_outline,
                      label: "My Accounts",
                      index: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Floating Button
          Positioned(
            bottom: 38,
            left: MediaQuery.of(context).size.width / 2 - 32,
            child: GestureDetector(
              onTap: () {
                _changePage(2);
              },
              child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: const Color(0xff228B22),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(.25),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool selected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _changePage(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: selected ? const Color(0xff228B22) : Colors.black87,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                selected ? FontWeight.w600 : FontWeight.w500,
                color:
                selected ? const Color(0xff228B22) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}