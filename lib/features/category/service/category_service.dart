import '../model/category_model.dart';
import '../../../core/network/api_client.dart';

class CategoryService {
  final ApiClient _apiClient;

  CategoryService(this._apiClient);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.get('categories');
      print('Raw category response: $response');
      if (response is List) {
        return response.map((category) {
          print('Category: ${category['name']}, Image: ${category['image']}');
          return CategoryModel.fromJson(category);
        }).toList();
      } else {
        throw Exception('Unexpected response format: $response');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Failed to fetch categories: $e');
    }
  }
}