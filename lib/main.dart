import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/cart/bloc/cart_bloc.dart';
import 'core/cart/bloc/cart_event.dart';
import 'core/cart/repository/cart_repository.dart';
import 'core/favorite/bloc/favorite_bloc.dart';
import 'core/favorite/bloc/favorite_event.dart';
import 'core/favorite/repository/favorite_repository.dart';
import 'core/product/view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cartRepository = CartRepository();
    final favoriteRepository = FavoriteRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartBloc(cartRepository)..add(LoadCart())),
        BlocProvider(create: (_) => FavoriteBloc(favoriteRepository)..add(LoadFavorites())),
      ],
      child: MaterialApp(
        title: 'Vira E-Ticaret',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const HomePage(),
      ),
    );
  }
}
