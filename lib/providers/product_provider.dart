import 'package:flutter/foundation.dart';
import '../repository/product_repository.dart';
import '../domain/models/product_model.dart';
import '../domain/models/category_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repo;
  ProductProvider(this._repo) {
    _listenAll();
    _listenCategories();
  }

  List<ProductModel> allProducts = [];
  List<CategoryModel> categories = [];
  bool isLoading = true;

  void _listenAll() {
    _repo.allProducts().listen((products) {
      allProducts = products;
      isLoading = false;
      notifyListeners();
    });
  }

  void _listenCategories() {
    _repo.categories().listen((cats) {
      categories = cats;
      notifyListeners();
    });
  }

  Stream<List<ProductModel>> productsByCategory(String categoryId) =>
      _repo.productsByCategory(categoryId);

  Stream<List<ProductModel>> featured() => _repo.featuredProducts();

  Stream<List<ProductModel>> bestsellers() => _repo.bestsellers();

  Future<List<ProductModel>> search(String query) => _repo.search(query);
}
