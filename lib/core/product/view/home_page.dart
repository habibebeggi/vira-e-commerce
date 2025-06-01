import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vira/core/api/api_endpoints.dart';
import 'package:vira/core/product/view/product_details_page.dart';
import 'package:vira/shared/formatter/price_formatter.dart';
import 'package:vira/shared/theme/app_colors.dart';
import '../../../shared/widgets/custom_snackbar.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/bloc/cart_state.dart';
import '../../cart/service/cart_service.dart';
import '../../cart/view/cart_page.dart';
import '../../cart/model/cart_item_model.dart';
import '../../favorite/bloc/favorite_bloc.dart';
import '../../favorite/bloc/favorite_event.dart';
import '../../favorite/bloc/favorite_state.dart';
import '../../favorite/model/favorite_model.dart';
import '../../favorite/view/favorites_page.dart';
import '../model/product_model.dart';
import '../service/product_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> futureProducts;
  final productService = ProductService();

  List<String> categories = [];
  String selectedCategory = "Tümü";

  @override
  void initState() {
    super.initState();
    futureProducts = productService.fetchProducts().then((products) {
      final uniqueCategories = products.map((e) => e.category).toSet().toList();
      setState(() {
        categories = ["Tümü", ...uniqueCategories];
      });
      return products;
    });

    context.read<FavoriteBloc>().add(LoadFavorites());
  }

  void goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    ).then((_) {
      context.read<CartBloc>().add(LoadCart());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
          appBar: AppBar(
              title: const Text("Ürünler"),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesPage()),
                  );
                },
              ),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  int cartItemCount = 0;
                  if (state is CartLoaded) {
                    cartItemCount = state.items.length;
                  }

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: goToCart,
                      ),
                      if (cartItemCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '$cartItemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
      body: Column(
        children: [
          // Kategoriler
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (value) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.background,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Hiç ürün bulunamadı.'));
                }

                final allProducts = snapshot.data!;
                final filteredProducts = selectedCategory == "Tümü"
                    ? allProducts
                    : allProducts
                    .where((product) => product.category == selectedCategory)
                    .toList();

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(product: product),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SizedBox(
                            height: 270,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Container(
                                    height: 130,
                                    width: double.infinity,
                                    child: Image.network(
                                      '${ApiEndpoints.imageBaseUrl}${product.image}',
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 60),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        product.brand,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${PriceFormatter.format(product.price)} ',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          BlocBuilder<FavoriteBloc, FavoriteState>(
                                            builder: (context, state) {
                                              bool isFavorite = false;
                                              if (state is FavoriteLoaded) {
                                                isFavorite = state.favorites
                                                    .any((fav) => fav.id == product.id);
                                              }

                                              return IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(
                                                    minWidth: 28, minHeight: 28),
                                                iconSize: 20,
                                                icon: Icon(
                                                  isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: isFavorite ? Colors.red : Colors.grey,
                                                ),
                                                onPressed: () {
                                                  final favorite = Favorite(
                                                    id: product.id,
                                                    name: product.name,
                                                    image: product.image,
                                                    category: product.category,
                                                    price: product.price,
                                                    brand: product.brand,
                                                  );

                                                  if (isFavorite) {
                                                    context
                                                        .read<FavoriteBloc>()
                                                        .add(RemoveFavorite(product.id));
                                                  } else {
                                                    context
                                                        .read<FavoriteBloc>()
                                                        .add(AddFavorite(favorite));
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                                minWidth: 28, minHeight: 28),
                                            iconSize: 20,
                                            icon: const Icon(
                                              Icons.add_shopping_cart_outlined,
                                              color: Colors.orange,
                                            ),
                                            onPressed: () async {
                                              final cartItem = CartItem(
                                                cartId: 0,
                                                name: product.name,
                                                image: product.image,
                                                category: product.category,
                                                price: product.price,
                                                brand: product.brand,
                                                quantity: 1,
                                                username: ApiEndpoints.username,
                                              );

                                              await CartService().smartAddToCart(cartItem);
                                              context.read<CartBloc>().add(LoadCart());

                                              showCustomSnackbar(
                                                  context, "${product.name} sepete eklendi");
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}
