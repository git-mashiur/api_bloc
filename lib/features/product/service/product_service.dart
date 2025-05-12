import '../model/product_model.dart';
import '../../../core/network/api_client.dart';

class ProductService {
  final ApiClient _apiClient;

  ProductService(this._apiClient);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiClient.get('products');
      print('Raw product response: $response');
      if (response is List) {
        return response.map((product) => ProductModel.fromJson(product)).toList();
      } else {
        throw Exception('Unexpected response format: $response');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _apiClient.get('categories/$categoryId/products');
      print('Raw product response for category $categoryId: $response');
      if (response is List) {
        return response.map((product) => ProductModel.fromJson(product)).toList();
      } else {
        throw Exception('Unexpected response format: $response');
      }
    } catch (e) {
      print('Error fetching products for category $categoryId: $e');
      throw Exception('Failed to fetch products for category $categoryId: $e');
    }
  }
}