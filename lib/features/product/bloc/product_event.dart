part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProducts extends ProductEvent {}

class FetchProductsByCategory extends ProductEvent {
  final int categoryId;

  const FetchProductsByCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}