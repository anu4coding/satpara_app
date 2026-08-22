/// Firestore collection: "categories"
/// Matches the site structure: Skin Care (Soap, Face Mask), Food (Pickle)
class CategoryModel {
  final String id;
  final String name;
  final String parentId; // '' if top-level (e.g. "Skin Care", "Food")
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    this.parentId = '',
    this.imageUrl = '',
  });

  bool get isTopLevel => parentId.isEmpty;

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      parentId: map['parentId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'parentId': parentId,
      'imageUrl': imageUrl,
    };
  }
}
