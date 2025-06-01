import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vira/shared/formatter/price_formatter.dart';
import 'package:vira/shared/theme/app_colors.dart';
import 'package:vira/shared/widgets/loader.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../../../core/api/api_endpoints.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sepetim"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const CustomLoader();
          } else if (state is CartLoaded) {
            final items = state.items;
            if (items.isEmpty) {
              return const Center(
                child: Text(
                  "Sepetiniz şu anda boş.",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              );
            }

            final total = items.fold<int>(
              0, (sum, item) => sum + (item.price * item.quantity),
            );

            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${ApiEndpoints.imageBaseUrl}${item.image}',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          context.read<CartBloc>().add(RemoveCartItem(item.cartId));
                                        },
                                        child: Icon(Icons.close, color: AppColors.error),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Birim Fiyatı : ',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: PriceFormatter.format(item.price),
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          OutlinedButton(
                                            onPressed: () {
                                              if (item.quantity > 1) {
                                                context.read<CartBloc>().add(
                                                  UpdateCartItemQuantity(item, item.quantity - 1),
                                                );
                                              } else{
                                                context.read<CartBloc>().add(
                                                  RemoveCartItem(item.cartId),
                                                );
                                              }
                                            },
                                            style: OutlinedButton.styleFrom(
                                              padding: const EdgeInsets.all(4),
                                              minimumSize: const Size(16, 16),
                                              shape: const CircleBorder(),
                                              foregroundColor: AppColors.primary,
                                            ),
                                            child: const Icon(Icons.remove, size: 18),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 2),
                                            child: Text(
                                              '${item.quantity}',
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color:  AppColors.primary),
                                            ),
                                          ),
                                          OutlinedButton(
                                            onPressed: () {
                                              context.read<CartBloc>().add(
                                                UpdateCartItemQuantity(item, item.quantity + 1),
                                              );
                                            },
                                            style: OutlinedButton.styleFrom(
                                              padding: const EdgeInsets.all(4),
                                              minimumSize: const Size(16, 16),
                                              shape: const CircleBorder(),
                                              foregroundColor: AppColors.primary,
                                            ),
                                            child: const Icon(Icons.add, size: 18),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: const Border(top: BorderSide(color: Colors.grey, width: 0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Toplam Tutar: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              PriceFormatter.format(total),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Ödeme Yap",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text("Sepet yüklenemedi."));
          }
        },
      ),
      backgroundColor: const Color(0xFFF8F8F8),
    );
  }
}
