import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../model/category_model.dart';
import '../service/category_service.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryService categoryService;

  CategoryBloc(this.categoryService) : super(CategoryInitial()) {
    on<FetchCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await categoryService.getCategories();
        print('Categories fetched: ${categories.length}'); // Debug log
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}