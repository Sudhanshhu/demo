class Rating {
  String rate;
  String count;
  Rating({required this.rate, required this.count});
  fromMap(Map<String, dynamic> map) {
    rate = map['rate'].toString();
    count = map['count'].toString();
  }
}

class Product {
  final String title, id, category;
  final String description;
  final double price;
  final String imageUrl;
  final String rate;
  final String count;

  Product({
    required this.title,
    required this.category,
    required this.id,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rate,
    required this.count,
  });
  fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      category: json['category'],
      id: json['id'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      rate: json['rate'],
      count: json['count'],
    );
  }
}
