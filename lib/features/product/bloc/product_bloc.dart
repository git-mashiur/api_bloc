import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/product_model.dart';
import '../service/product_service.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;

  ProductBloc(this.productService) : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productService.getProducts();
        print('Products fetched: ${products.length}'); // Debug log
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<FetchProductsByCategory>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await productService.getProductsByCategory(event.categoryId);
        print('Products fetched for category ${event.categoryId}: ${products.length}'); // Debug log
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}