class Favorite{
  final int id;
  final String name;
  final String image;
  final String category;
  final int price;
  final String brand;

  Favorite({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.brand
  });

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
        id: map["id"],
        name: map["name"],
        image: map["image"],
        category: map["category"],
        price: map["price"],
        brand: map["brand"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "image": image,
      "category": category,
      "price": price,
      "brand": brand,
    };
  }
}