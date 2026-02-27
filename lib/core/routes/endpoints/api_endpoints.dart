class ApiEndpoints {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String getCategories = '/products/categories';
  static String getProductsByCategory(String category) => '/products/category/$category';
}