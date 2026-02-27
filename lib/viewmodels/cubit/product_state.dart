import 'package:zavisoft_task/models/product_response/product_response.dart';

class ProductState {
  final Map<String, ProductStatus> productMap;
  final List<String> categoryType;
  final bool isLoading;

  ProductState({required this.productMap, required this.categoryType, required this.isLoading});

  ProductState copyWith({
    Map<String, ProductStatus>? productMap,
    List<String>? categoryType,
    bool? isLoading
  }) {
    return ProductState(
      productMap: productMap ?? this.productMap,
      categoryType: categoryType ?? this.categoryType,
      isLoading: isLoading ?? this.isLoading
    );
  }
}

class ProductStatus {
  final bool isLoading;
  final List<ProductResponse> products;
  final String? error;

  ProductStatus({
    this.isLoading = false,
    this.products = const [],
    this.error,
  });
}
