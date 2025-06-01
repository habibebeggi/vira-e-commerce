import 'package:equatable/equatable.dart';
import 'package:vira/core/favorite/model/favorite_model.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class AddFavorite extends FavoriteEvent {
  final Favorite product;

  const AddFavorite(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveFavorite extends FavoriteEvent {
  final int id;

  const RemoveFavorite(this.id);

  @override
  List<Object> get props => [id];
}
