import '../backend/firestore_service.dart';
import '../domain/models/product_model.dart';
import '../domain/models/category_model.dart';

/// App-facing API for product/category data. Screens & providers should
/// talk to this class, never to FirestoreService directly - this keeps
/// Firestore swappable later (e.g. if you move to a REST backend).
class ProductRepository {
  final FirestoreService _service;
  ProductRepository(this._service);

  Stream<List<ProductModel>> allProducts() => _service.streamAllProducts();

  Stream<List<ProductModel>> productsByCategory(String categoryId) =>
      _service.streamProductsByCategory(categoryId);

  Stream<List<ProductModel>> featuredProducts() =>
      _service.streamFeaturedProducts();

  Stream<List<ProductModel>> bestsellers() => _service.streamBestsellers();

  Future<ProductModel?> productById(String id) => _service.getProductById(id);

  Future<List<ProductModel>> search(String query) =>
      _service.searchProducts(query);

  Stream<List<CategoryModel>> categories() => _service.streamCategories();
}
