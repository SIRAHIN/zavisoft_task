import 'dart:io';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zavisoft_task/core/endpoints/api_endpoints.dart';
import 'package:zavisoft_task/models/error_response_model/error_response.dart';
import 'package:zavisoft_task/models/product_response/product_response.dart';

abstract class UserApiService {
  UserApiService() {
    client.interceptors.add(AwesomeDioInterceptor());
  }

  // Dio Client
  Dio client = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
      contentType: "application/json",
    ),
  );

  Future<Either<ErrorResponse, List<String>>> getCategories();

  Future<Either<ErrorResponse, List<ProductResponse>>> getProducts(String category);
}

@LazySingleton(as: UserApiService)
class IUserApiService extends UserApiService {
  ErrorResponse checkResponseError(DioException err) {
    if (err.type == DioExceptionType.badResponse) {
      var errorData = err.response?.data;
      var errorModel = ErrorResponse.fromJson(errorData);
      return errorModel;
    } else {
      return const ErrorResponse();
    }
  }

  // Helper method to handle all types of errors including timeouts \\
  ErrorResponse handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ErrorResponse(
            message: 'No internet connection. Please check your network.',
            status: 408,
          );
        case DioExceptionType.sendTimeout:
          return ErrorResponse(
            message: 'Request timeout. The server took too long to respond.',
            status: 408,
          );
        case DioExceptionType.receiveTimeout:
          return ErrorResponse(
            message:
                'Response timeout. The server is taking too long to send data.',
            status: 408,
          );
        case DioExceptionType.connectionError:
          return ErrorResponse(
            message: 'No internet connection. Please check your network.',
            status: 0,
          );
        case DioExceptionType.badResponse:
          return checkResponseError(error);
        default:
          return checkResponseError(error);
      }
    } else if (error is SocketException) {
      return ErrorResponse(
        message: 'No internet connection. Please check your network.',
        status: 0,
      );
    } else {
      return ErrorResponse(message: error.toString(), status: 0);
    }
  }

  @override
  Future<Either<ErrorResponse, List<String>>> getCategories() async {
    try {
      Response response = await client.get(ApiEndpoints.getCategories);
      print("This is response $response");
      final List<String> catList = [];
      for (var item in response.data as List) {
        catList.add(item);
      }
      return right(catList);
    } catch (e) {
      return left(handleError(e));
    }
  }

  @override
  Future<Either<ErrorResponse, List<ProductResponse>>> getProducts(String category) async {
    try {
      Response response = await client.get(ApiEndpoints.getProductsByCategory(category));
      print("This is response $response");
      final List<ProductResponse> productList = [];
      for (var item in response.data as List) {
        productList.add(ProductResponse.fromJson(item));
      }
      return right(productList);
    } catch (e) {
      return left(handleError(e));
    }
  }
}
