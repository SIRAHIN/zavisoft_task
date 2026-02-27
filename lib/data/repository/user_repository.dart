import 'package:injectable/injectable.dart';
import 'package:zavisoft_task/data/services/user_api_service.dart';
import 'package:dartz/dartz.dart';
import 'package:zavisoft_task/models/error_response_model/error_response.dart';
import 'package:zavisoft_task/models/product_response/product_response.dart';

abstract class UserRepository {
  final UserApiService userApiService;
  UserRepository(this.userApiService);

  Future<Either<ErrorResponse, List<String>>> getCategories();

  Future<Either<ErrorResponse, List<ProductResponse>>> getProducts(String category);
}

/**
 * UserRepository implementation
 */
@LazySingleton(as: UserRepository)
class IUserRepository extends UserRepository {
  IUserRepository(super.userApiService);

  @override
  Future<Either<ErrorResponse, List<String>>> getCategories() {
    return userApiService.getCategories();
  }

  @override
  Future<Either<ErrorResponse, List<ProductResponse>>> getProducts(String category) {
    return userApiService.getProducts(category);
  }
}
