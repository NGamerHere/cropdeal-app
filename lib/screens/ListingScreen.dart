import 'package:cropdeal/widgets/HomeBanner.dart';
import 'package:cropdeal/widgets/MarketplaceHeader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListingScreen extends ConsumerStatefulWidget {
  const ListingScreen({super.key});

  @override
  ConsumerState<ListingScreen> createState() => _ListingScreenState();
}

class _ListingScreenState extends ConsumerState<ListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: const [
            HomeBanner(),
            MarketplaceHeader()
          ],
      ),
    );
  }
}