import 'package:flutter/foundation.dart';

class WishlistItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  WishlistItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });
}

class WishlistProvider extends ChangeNotifier {
  final Map<String, WishlistItem> _items = {};

  Map<String, WishlistItem> get items => _items;

  bool isInWishlist(String productId) {
    return _items.containsKey(productId);
  }

  void toggleWishlist(
      String productId,
      String title,
      double price,
      String imageUrl,
      ) {
    if (_items.containsKey(productId)) {
      // موجود → احذفه
      _items.remove(productId);
    } else {
      // مش موجود → ضيفه
      _items.putIfAbsent(
        productId,
            () => WishlistItem(
          id: productId,
          title: title,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
// TODO Implement this library.// TODO Implement this library.