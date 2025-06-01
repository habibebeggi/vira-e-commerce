class CartItem {
  int cartId;
  String name;
  String image;
  String category;
  int price;
  String brand;
  int quantity;
  String username;

  CartItem({
    required this.cartId,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.brand,
    required this.quantity,
    required this.username,
  });


  factory CartItem.fromJson(Map<String, dynamic> json){
    return CartItem(
      cartId: json["sepetId"] as int,
      name: json["ad"] as String,
      image: json["resim"] as String,
      category: json["kategori"] as String,
      price: json["fiyat"] as int,
      brand: json["marka"] as String,
      quantity: json["siparisAdeti"] as int,
      username: json["kullaniciAdi"] as String,
    );
  }

}