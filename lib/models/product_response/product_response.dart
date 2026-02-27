import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_response.freezed.dart';
part 'product_response.g.dart';

@freezed
class ProductResponse with _$ProductResponse {
  const factory ProductResponse({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
    required Rating rating,
  }) = _ProductResponse;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);
}

@freezed
class Rating with _$Rating {
  const factory Rating({
    required double rate,
    required int count,
  }) = _Rating;

  factory Rating.fromJson(Map<String, dynamic> json) =>
      _$RatingFromJson(json);
}