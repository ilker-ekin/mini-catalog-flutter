class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;

  /// Price as it comes from the data, e.g. "$1,299".
  final String price;
  final String currency;
  final String image;
  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.specs,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final specs = json['specs'] as Map<String, dynamic>? ?? {};
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] as String,
      currency: json['currency'] as String? ?? 'USD',
      image: json['image'] as String? ?? '',
      specs: specs.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'price': price,
      'currency': currency,
      'image': image,
      'specs': specs,
    };
  }

  /// Numeric price, e.g. "$1,299" -> 1299.0. Used for totals and filtering.
  double get priceValue =>
      double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
}

/// Formats a number like the prices in the data: 2598 -> "$2,598".
String formatPrice(double value, {String currency = 'USD'}) {
  final symbol = currency == 'USD' ? '\$' : '$currency ';
  final whole = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return '$symbol$buffer';
}
