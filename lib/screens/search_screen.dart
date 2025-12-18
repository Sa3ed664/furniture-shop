// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../app_router.dart';
import '../utils/colors.dart';
import '../data/dummy_data.dart';
import '../models/product.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _suggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(_searchController.text);
    });
  }

  void _performSearch(String queryText) {
    final query = queryText.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    final startsWithList = DummyData.allProducts
        .where((p) => p.name.toLowerCase().startsWith(query))
        .toList();
    final containsList = DummyData.allProducts
        .where((p) => p.name.toLowerCase().contains(query))
        .toList();
    final startsWithIds = startsWithList.map((p) => p.id).toSet();
    final uniqueContainsList =
    containsList.where((p) => !startsWithIds.contains(p.id)).toList();
    final finalSuggestions = [...startsWithList, ...uniqueContainsList];
    setState(() {
      _suggestions = finalSuggestions;
    });
  }

  // ==================== (بداية التعديل) ====================
  // دالة الهايلايت المعدلة
  Widget _buildHighlightedText(String text, String query) {
    // 1. هنجيب الستايل الافتراضي بتاع العنوان من الـ Theme
    final defaultStyle = Theme.of(context).textTheme.titleMedium;

    // 2. هنعمل ستايل الهايلايت (أتقل سيكة)
    final highlightedStyle = defaultStyle?.copyWith(
      fontWeight: FontWeight.w600, // "أتقل حاجة بسيطة"
      color: Colors.black, // نتأكد إن لونه أسود
    ) ?? const TextStyle(fontWeight: FontWeight.w600, color: Colors.black);


    if (query.isEmpty) {
      return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: defaultStyle);
    }

    final textLower = text.toLowerCase();
    final queryLower = query.toLowerCase();
    final List<TextSpan> spans = [];
    int lastMatchEnd = 0;
    int start = textLower.indexOf(queryLower, lastMatchEnd);

    while (start != -1) {
      if (start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, start),
          // الستايل هنا هو الـ defaultStyle
        ));
      }
      spans.add(TextSpan(
        text: text.substring(start, start + query.length),
        style: highlightedStyle, // <-- تطبيق الستايل الأتقل
      ));
      lastMatchEnd = start + query.length;
      start = textLower.indexOf(queryLower, lastMatchEnd);
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
      ));
    }

    return RichText(
      text: TextSpan(
        style: defaultStyle, // <-- تطبيق الستايل الافتراضي الصح
        children: spans,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
  // ==================== (نهاية التعديل) ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(fontSize: 16),
          decoration: const InputDecoration(
            hintText: 'Search furniture...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onSubmitted: (query) {
            _performSearch(query);
          },
        ),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_suggestions.isEmpty && _searchController.text.isEmpty)
              _buildPopularUI()
            else if (_suggestions.isNotEmpty)
              _buildSuggestionsList() // <-- هيستخدم الدالة الجديدة
            else if (_searchController.text.isNotEmpty)
                const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Text('No products found...'),
                    ))
          ],
        ),
      ),
    );
  }

  // دالة عرض المقترحات
  Widget _buildSuggestionsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          final product = _suggestions[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade200,
                    child: Icon(Icons.error, size: 20, color: Colors.grey)),
              ),
            ),
            // استخدام الدالة المعدلة
            title: _buildHighlightedText(product.name, _searchController.text),
            subtitle: Text('\$${product.effectivePrice.toStringAsFixed(0)}'),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.productDetail,
                arguments: product,
              );
            },
          );
        },
      ),
    );
  }

  // (دالة الـ UI القديم - زي ما هي)
  Widget _buildPopularUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Popular Categories',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['All', 'Bed', 'Chair', 'Sofa', 'Storage', 'Table']
              .map((e) => FilterChip(
            label: Text(e),
            selected: e == 'All',
            selectedColor: AppColors.primary,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: e == 'All' ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            onSelected: (selected) {
              if (e != 'All') {
                Navigator.pushNamed(
                  context,
                  AppRoutes.searchResults,
                  arguments: e.toLowerCase(),
                );
              }
            },
          ))
              .toList(),
        ),
        const SizedBox(height: 24),
        const Text('Popular Searches',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Modern Chair',
            'Sofa Set',
            'Dining Table',
            'Office Chair',
            'TV Cabinet'
          ]
              .map((e) => ActionChip(
            label: Text(e),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.searchResults,
                arguments: e.toLowerCase(),
              );
            },
          ))
              .toList(),
        ),
      ],
    );
  }
}